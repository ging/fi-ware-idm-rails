namespace :db do
  namespace :populate do
    %w( create:ties create:groups create:posts create:messages create:site_clients ).each do |t|
      task(:create).prerequisites.delete(t)
    end

    task create: [ 'create:organizations', 'create:applications', 'create:confirm_users', 'create:admin' ]

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

      desc 'Add admin'
      task admin: :read_environment do
        puts "Add demo as admin"

        contact = Site.current.contact_to!(SocialStream::Population::Actor.demo)
        contact.user_author = SocialStream::Population::Actor.demo.user
        contact.relation_ids = [ Relation::LocalAdmin.instance.id ]
        binding.pry
      end
    end
  end
end

