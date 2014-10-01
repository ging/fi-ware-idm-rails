namespace :db do
  namespace :populate do
    %w( create:ties create:groups create:posts create:messages create:site_clients ).each do |t|
      task(:create).prerequisites.delete(t)
    end

    task create: [ 'create:organizations', 'create:applications', 'create:confirm_users' ]

    namespace :create do
      desc 'Create organizations'
      task organizations: :read_environment do
        SocialStream::Population.task 'Create organizations' do
          @owners = SocialStream::Population::Actor.available

          20.times do
            author = @owners.sample

            Organization.create! name: Forgery::Name.company_name,
              description: Forgery::LoremIpsum.sentences(2, random: true),
              author: author.id,
              user_author: author.id,
              owners: @owners.sample((10 * rand).to_i).map(&:id).join(',')
          end
        end
      end

      desc 'Create applications'
      task applications: :read_environment do
        SocialStream::Population.task 'Create applications' do
          @owners = SocialStream::Population::Actor.available

          20.times do
            author = @owners.sample
            user_author = author.is_a?(User) && author || author.receivers.first

            ::Application.create! name: Forgery::LoremIpsum.words(3, random: true),
              description: Forgery::LoremIpsum.sentences(2, random: true),
              url: "https://#{ Forgery::Internet.domain_name }",
              callback_url: "https://#{ Forgery::Internet.domain_name }/callback",
              author: author.id,
              user_author: author.id
          end
        end
      end

      desc 'Confirm users'
      task confirm_users: :read_environment do
        puts "Confirm users"

        User.all.each do |u|
          u.confirm!
        end
      end

      desc "Create current site"
      task :current_site do
        puts 'Current site population'
        current_site_start = Time.now

        Site.current.name = "FI-WARE IDM"
        unless FiWareIdm.sender.blank?
          Site.current.email = FiWareIdm.sender
        end
        Site.current.actor!.update_attribute :slug, 'idm'
        Site.current.save!

        current_site_end = Time.now
        puts '   -> ' +  (current_site_end - current_site_start).round(4).to_s + 's'
      end

      #Usage
      #Development:   bundle exec rake db:populate:create:admin
      #In production: bundle exec rake db:populate:create:admin RAILS_ENV=production
      desc "Create FI-WARE IDM Admin"
      task :admin => :environment do
        puts 'Creating admin user'

        # Create admin user if not present
        admin = User.find_by_slug('admin')
        if admin.blank?
          admin = User.new
        end

        admin.name = 'Admin'
        admin.email = 'admin@idm.org'
        admin.password = 'demonstration'
        admin.password_confirmation = admin.password
        admin.save!
        admin.actor!.update_attribute :slug, 'admin'
        admin.confirm!

        #Make the user 'admin' the administrator of the IDM Site
        contact = Site.current.contact_to!(admin)
        contact.user_author = admin
        contact.relation_ids = [ Relation::LocalAdmin.instance.id ]
        contact.save!

        puts "Admin created with email: " + admin.email + " and password: " + admin.password
      end

      #Usage
      #Development:   bundle exec rake db:populate:create:demo_user
      #In production: bundle exec rake db:populate:create:demo_user RAILS_ENV=production
      desc "Create FI-WARE IDM demo user"
      task :demo_user => :environment do
        puts 'Creating demo user'

          # Create demo user if not present
          demo = User.find_by_slug('demo')
          if demo.blank?
            demo = User.new
          end

          # If present, ensure that has the appropiate data
          demo.name = 'Demo'
          demo.email = 'demo@idm.org'
          demo.password = 'demonstration'
          demo.password_confirmation = demo.password
          demo.save!
          demo.actor!.update_attribute :slug, 'demo'
          demo.confirm!

          puts "Demo user created with email: " + demo.email + " and password: " + demo.password
      end
    end
  end

  #Usage
  #Development:   bundle exec rake db:install
  #In production: bundle exec rake db:install RAILS_ENV=production
  desc "Install database for new Fi-Ware IDM instance"
  task :install => :environment do
    puts "Installation: populating database"
    Rake::Task["db:reset"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["db:populate:create:current_site"].invoke
    Rake::Task["db:populate:create:demo_user"].invoke
    Rake::Task["db:populate:create:admin"].invoke
    puts "Populate finished"
  end

end

