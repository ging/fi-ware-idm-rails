# Apply the new external idps's configuration
require 'mysql'
require 'fileutils'
require 'logger'  
require 'inifile'
require 'yaml'

IDP_CONFIGURATION_PATH = '/opt/shibboleth/'
IDM_PATH = '/home/mirko/progetti/fi-ware-idm/'
PID_FILE = '/var/run/multiple-sp-configure.pid'
STATE_FILE = '/tmp/multiple-sp-configure.stat'
METADATA_PATH = IDM_PATH + 'public/uploads/external_sp/metadata/' # From rails carrierwave gem 

File.open(PID_FILE, 'w') { |file| file.write(Process.pid) }

def do_exit state=false
	File.open(STATE_FILE, 'w') { |file| file.write(state) }
	FileUtils.rm_f(PID_FILE)
	exit
end

# Log file
begin
	$MyLog = Logger.new('/var/log/multiple-sp-configure.log', 'monthly')
rescue
	do_exit
end

$MyLog.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} - #{msg}\n"
end

$MyLog.debug('START')

Configuration = {:idp => {:configuration_path => IDP_CONFIGURATION_PATH},:idm => {:path => IDM_PATH, :metadata_path => METADATA_PATH}}

# Read the ini file
ini_file = 'multiple-sp-configure.ini'
myini = IniFile.load(ini_file)
if !myini.nil?
	$MyLog.debug("Read #{ini_file}")
	
	# Recover configuration
	myini.each_section do |section|
		myini[section].each { |key, value|
		Configuration[section.to_sym][key.to_sym] = myini[section][key]
	 }
	end
else
	$MyLog.warn("File #{ini_file} not found -> Load default configuration")
end


# IDM CONFIGURATION
Configuration[:idm][:metadata_path] = File.join(Configuration[:idm][:path],'public/uploads/external_sp/metadata/')

#### CHECK IF DEVEL OR NOT ####

# Recover info database
Configuration[:db] = {}
$MyLog.debug("Read database configuration")
dbHash = YAML.load_file(File.join(Configuration[:idm][:path],'/config/database.yml'))
Configuration[:db][:user] = dbHash['development']['user']
Configuration[:db][:password] = dbHash['development']['password']
Configuration[:db][:database] = dbHash['development']['database']

def writeFile (contents, saveTemporaryTo)
	writeOn = File.new(saveTemporaryTo, 'w')
	isItOk = false
	if (not(writeOn.closed?)) then
		writeOn.write( contents )
		isItOk = true;
		writeOn.close
	end
	
	return isItOk
end

def updateFile (originalFile, contentElaborator, saveTemporaryTo)
	file = File.open(originalFile, "r")
	contents = file.read
	contents = contentElaborator.call(contents)
	
	return writeFile contents, saveTemporaryTo
end

def updateShibbolethConfiguration (listOfSps = nil, saveTemporaryTo= "")

	$MyLog.debug("Update IDP configuration")
	
	metaDataProvider = "<metadata:MetadataProvider id=\"ShibbolethMetadata\" xsi:type=\"metadata:ChainingMetadataProvider\">\n"

	listOfSps.each do |key, aRow|
		metaDataProvider = metaDataProvider + "\t<metadata:MetadataProvider xsi:type=\"FilesystemMetadataProvider\" xmlns=\"urn:mace:shibboleth:2.0:metadata\" id=\"" + aRow["mark"] + "\" metadataFile=\"" + File.join(Configuration[:idm][:metadata_path],aRow["id"],aRow["metadata"]) + "\" />\n"
	end

	metaDataProvider = metaDataProvider + "</metadata:MetadataProvider>"

	return updateFile(File.join(Configuration[:idp][:configuration_path],"relying-party.xml"), Proc.new {|contents| contents.gsub(/<metadata:MetadataProvider(.|\n)*<\/metadata:MetadataProvider>/, "#{metaDataProvider}")}, saveTemporaryTo);
end


$MyLog.debug("Connect to #{Configuration[:db][:database]} database")
begin
	db = Mysql.new("localhost", Configuration[:db][:user], Configuration[:db][:password], Configuration[:db][:database])
rescue Exception => e  
	$MyLog.error("DB Connection: " + e.message)
	do_exit
end

# Recover list of enabled sps
ris = db.query("SELECT * FROM external_sps WHERE enabled<>0 ORDER BY id ASC")
listOfSps = Hash.new
id_sp = 1
ris.each_hash do |aRow|
	listOfSps[id_sp] = aRow;
	id_sp += 1
end

# Create temporary files
rnd = Random.new
id_temp = rnd.rand(1..1000000)
tempDir = "/tmp/multiple-sp-configure.#{id_temp}"
$MyLog.debug("Create temporary directory #{tempDir}")
FileUtils.remove_dir(tempDir, true)
FileUtils.mkdir tempDir

backupDir = tempDir + "/org/"
FileUtils.mkdir backupDir

filename = 'relying-party.xml'

tempFile = File.join(tempDir,filename)
begin
	# Check org file
	FileUtils.cp(File.join(Configuration[:idp][:configuration_path],filename),File.join(backupDir,filename))
	result = updateShibbolethConfiguration(listOfSps, tempFile)
rescue Exception => e  
	$MyLog.error(e.message)
	do_exit
end

if !result
	$MyLog.error("Create new #{filename} configuration")	
	do_exit
end

# OK Apply changes
$MyLog.debug("Apply changes")
orgDir = Configuration[:idp][:configuration_path]
	
tempFile = File.join(tempDir,filename)
orgFile = File.join(orgDir,filename)
	
# Recover owner + group
oldStat = File.stat(orgFile)
FileUtils.rm_f(orgFile)
FileUtils.mv(tempFile, orgFile)
	
# Apply old owner+group
File.chown(oldStat.uid, oldStat.gid, orgFile)

$MyLog.debug("Restart tomcat")
system "service tomcat7 restart"

do_exit true
