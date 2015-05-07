desc "This task is called by the Heroku scheduler add-on"
task :expire_ferraris => :environment do
  puts "Expiring ferraris"
  Ferrari.all.each do |ferrari|
    ferrari.expired?
  end
  puts "done."
end
