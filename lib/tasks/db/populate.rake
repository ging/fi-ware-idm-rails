namespace :db do
  namespace :populate do
    desc 'Confirm users after populate'
    task create: 'create:confirm_users'

    namespace :create do
      desc 'Confirm users'
      task confirm_users: :read_environment do
        User.all.each do |u|
          u.confirm!
        end
      end
    end
  end
end

