desc "This task is called by the Heroku scheduler add-on"
task :expire_ferraris => :environment do
  puts "Expiring ferraris"
  Ferrari.all.each do |ferrari|
    puts "About to expire Ferrari:#{ferrari.id}"
    expired = ferrari.expired?
    puts "Ferrari expired #{expired}"
  end
  puts "done."
end
