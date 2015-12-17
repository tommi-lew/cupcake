namespace :migration_tasks do
  task :add_roles_to_user => :environment do
    User.find_each do |user|
      user.roles << user.role
      user.save
    end
  end
end
