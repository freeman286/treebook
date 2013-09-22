desc "Import avatars from a user's gravata url"
task :import_avatars => :environment do
  User.get_gravatars
end