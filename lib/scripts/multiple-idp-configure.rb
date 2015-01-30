# Apply the new external idps's configuration
require 'mysql'
require 'fileutils'
require 'logger'  
require 'inifile'
require 'yaml'

SP_CONFIGURATION_PATH = '/etc/shibboleth/'
APACHE_CONFIGURATION_PATH = '/etc/apache2/sites-available/'
APACHE_CONFIGURATION_FILE = 'sp-multiple-idp.conf'
IDM_PATH = '/home/mirko/progetti/fi-ware-idm/'
PID_FILE = '/var/run/multiple-idp-configure.pid'
STATE_FILE = '/tmp/multiple-idp-configure.stat'
METADATA_PATH = IDM_PATH + 'public/uploads/external_idp/metadata/' # From rails carrierwave gem 

File.open(PID_FILE, 'w') { |file| file.write(Process.pid) }

def do_exit state=false
	File.open(STATE_FILE, 'w') { |file| file.write(state) }
	FileUtils.rm_f(PID_FILE)
	exit
end

# Log file
begin
	$MyLog = Logger.new('/var/log/multiple-idp-configure.log', 'monthly')
rescue
	do_exit
end

$MyLog.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{severity} - #{msg}\n"
end

$MyLog.debug('START')

Configuration = {:sp => {:configuration_path => SP_CONFIGURATION_PATH},:apache => {:configuration_path => APACHE_CONFIGURATION_PATH, :configuration_file => APACHE_CONFIGURATION_FILE},:idm => {:path => IDM_PATH, :metadata_path => METADATA_PATH}}

# Read the ini file
ini_file = 'multiple-idp-configure.ini'
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

# CONTROLLARE CHE QUELLI LETTI DALL'IDP TERMINO CON /

# IDM CONFIGURATION
Configuration[:idm][:devise_configuration_path] = File.join(Configuration[:idm][:path],"config/initializers/")
Configuration[:idm][:omniauth_configuration_path] = File.join(Configuration[:idm][:path],"config/initializers/")
Configuration[:idm][:omniauth_callbacks_path] = File.join(Configuration[:idm][:path],"app/controllers/")
Configuration[:idm][:metadata_path] = File.join(Configuration[:idm][:path],'public/uploads/external_idp/metadata/')

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

def updateShibbolethConfiguration (listOfIdps = nil, saveTemporaryTo= "")
	
	$MyLog.debug("Update SP configuration")
	
	metaDataProvider = "<MetadataProvider type=\"Chaining\">\n"
	listOfIdps.each do |key, aRow|
		metaDataProvider = metaDataProvider + "\t<MetadataProvider type=\"XML\" path=\"" + File.join(Configuration[:idm][:metadata_path],aRow["id"],aRow["metadata"]) + "\" />\n"
	end
	metaDataProvider = metaDataProvider + "</MetadataProvider>"
	
	return updateFile(Configuration[:sp][:configuration_path]+"shibboleth2.xml", Proc.new {|contents| contents.gsub(/<MetadataProvider(.|\n)*<\/MetadataProvider>/, "#{metaDataProvider}")}, saveTemporaryTo);
end

def updateApacheConfiguration (listOfIdps = nil, saveTemporaryTo = "")
	
	$MyLog.debug("Update Apache configuration")
	
	locations = ""
	listOfIdps.each do |key, aRow|
		url = File.join(aRow["url"],'idp','shibboleth')
		tag = aRow["route"]

		locations = locations + <<EOS

<Location #{tag}/callback>
	Options -MultiViews
	AuthType shibboleth
	ShibRequestSetting  entityID #{url}
	ShibRequestSetting requireSession On
	require valid-user
</Location>

EOS
	end
	return updateFile(Configuration[:apache][:configuration_path] + Configuration[:apache][:configuration_file], Proc.new {|contents| 
		contents = contents.gsub(/\n?[ \t]*\n<Location .*?\/callback>(.|\n)*\<\/Location\>\n/, "")
		contents = contents.gsub(/\<\/VirtualHost\>/, "#{locations}<\/VirtualHost>")
	}, saveTemporaryTo);
end

def updateDevise (listOfIdps = nil, saveTemporaryTo = "")
	
	$MyLog.debug("Update Devise configuration")
	
	config_omniauth = "";
	listOfIdps.each do |id, aRow|
		config_omniauth = config_omniauth + "  config.omniauth :shibboleth_idp#{id}, {:info_fields => {:email => 'mail', :name => 'cn'},:debug => false }\n";
	end

	return updateFile(Configuration[:idm][:devise_configuration_path]+"devise.rb", Proc.new {|contents| 
		contents = contents.gsub(/[ \t]*config.omniauth :shibboleth_idp\d+, {:info_fields => {:email => 'mail', :name => 'cn'},:debug => false }\n/, "")
		contents = contents.gsub(/\nend/, "#{config_omniauth}\nend")
	}, saveTemporaryTo);
end

def updateOmniAuth (listOfIdps = nil, saveTemporaryTo = "")
	$MyLog.debug("Update OmniAuth configuration")
	omniauth = "";
	listOfIdps.each do |id, aRow|
		omniauth = omniauth + <<EOS
  class ShibbolethIdp#{id} < Shibboleth
    def name 
      :shibboleth_idp#{id}
    end
  end
EOS
	end

	contents = <<EOS
# initializers/omniauth.rb

module OmniAuth::Strategies

#{omniauth}

end
EOS

	return writeFile(contents, saveTemporaryTo);
end

def updateCallbackController (listOfIdps = nil, saveTemporaryTo = "")
	$MyLog.debug("Update OmniauthCallbacksController configuration")
	omniauth_callback = "";
	listOfIdps.each do |id, aRow|

		omniauth_callback = omniauth_callback + <<EOS
  def shibboleth_idp#{id}

    autenticate_sso_user(request)
        
    whereRedirect(request)
  end
EOS
	end

	return updateFile(Configuration[:idm][:omniauth_callbacks_path]+"omniauth_callbacks_controller.rb", Proc.new {|contents| 
		contents = contents.gsub(/class OmniauthCallbacksController \< Devise::OmniauthCallbacksController\n(.|\n)*?private/, "class OmniauthCallbacksController \< Devise::OmniauthCallbacksController\n#{omniauth_callback}\nprivate")
	}, saveTemporaryTo);
end


$MyLog.debug("Connect to #{Configuration[:db][:database]} database")
begin
	db = Mysql.new("localhost", Configuration[:db][:user], Configuration[:db][:password], Configuration[:db][:database])
rescue Exception => e  
	$MyLog.error("DB Connection: " + e.message)
	do_exit
end

# Recover list of enabled idps
ris = db.query("SELECT * FROM external_idps WHERE enabled<>0 ORDER BY id ASC")
listOfIdps = Hash.new
id_idp = 1
ris.each_hash do |aRow|
	listOfIdps[id_idp] = aRow;
	id_idp += 1
end

# Create temporary files
rnd = Random.new
id_temp = rnd.rand(1..1000000)
tempDir = "/tmp/multiple-idp-configure.#{id_temp}"
$MyLog.debug("Create temporary directory #{tempDir}")
FileUtils.remove_dir(tempDir, true)
FileUtils.mkdir tempDir

backupDir = File.join(tempDir,"/org/")
FileUtils.mkdir backupDir

files = 'shibboleth2.xml', Configuration[:apache][:configuration_file],  'devise.rb', 'omniauth.rb', 'omniauth_callbacks_controller.rb'

# Create the new files version
files.each do |filename| 

	tempFile = File.join(tempDir,filename)
	begin
		# Check org file
		case filename
		when 'shibboleth2.xml'
			FileUtils.cp(File.join(Configuration[:sp][:configuration_path],filename),File.join(backupDir,filename))
			result = updateShibbolethConfiguration(listOfIdps, tempFile)
		when Configuration[:apache][:configuration_file]
			FileUtils.cp(File.join(Configuration[:apache][:configuration_path],filename),File.join(backupDir,filename))
			result = updateApacheConfiguration(listOfIdps, tempFile) 
		when 'devise.rb'
			FileUtils.cp(File.join(Configuration[:idm][:devise_configuration_path],filename),File.join(backupDir,filename))
			result = updateDevise(listOfIdps, tempFile) 
		when 'omniauth.rb'
			FileUtils.cp(File.join(Configuration[:idm][:omniauth_configuration_path],filename),File.join(backupDir,filename))
			result = updateOmniAuth(listOfIdps, tempFile)
		when 'omniauth_callbacks_controller.rb'
			FileUtils.cp(File.join(Configuration[:idm][:omniauth_callbacks_path],filename),File.join(backupDir,filename))
			result = updateCallbackController(listOfIdps, tempFile)
		end
	rescue Exception => e  
		$MyLog.error(e.message)
		do_exit
	end
	
	if !result
		$MyLog.error("Create new #{filename} configuration")	
		do_exit
	end
end

# OK Apply changes
$MyLog.debug("Apply changes")
files.each do |filename|
	
	case filename
	when 'shibboleth2.xml'
		orgDir = Configuration[:sp][:configuration_path]
	when Configuration[:apache][:configuration_file]
		orgDir = Configuration[:apache][:configuration_path]
	when 'devise.rb'
		orgDir = Configuration[:idm][:devise_configuration_path]
	when 'omniauth.rb'
		orgDir = Configuration[:idm][:omniauth_configuration_path]
	when 'omniauth_callbacks_controller.rb'
		orgDir = Configuration[:idm][:omniauth_callbacks_path]
	end
	
	tempFile = File.join(tempDir,filename)
	orgFile = File.join(orgDir,filename)
	
	# Recover owner + group
	oldStat = File.stat(orgFile)
	FileUtils.rm_f(orgFile)
	FileUtils.mv(tempFile, orgFile)
	
	# Apply old owner+group
	File.chown(oldStat.uid, oldStat.gid, orgFile)
end

$MyLog.debug("Reload apache configuration")
system "service apache2 reload"

$MyLog.debug("Restart shibd apache module")
system "service shibd restart"

$MyLog.debug("Restart passengers")
system "touch #{Configuration[:idm][:path]}/tmp/restart.txt"

do_exit true
