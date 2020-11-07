###
### Rake tasks for git commit and deploy
###
require 'json'
##use it if you want commit only -no pushing
desc "Task description"
task :commit, :message  do |t, args|
  message = args.message
  if message==nil
    message = "Source updated at #{Time.now}."
  end
  old     = JSON.parse(File.read("config.json"))
  newz    = JSON.parse(File.read("config.json"))
  keys = [ "api-key", "youtube", "X-CMC_PRO_API_KEY"]
  newz.each do |key, value|
    if keys.include?(key)
      newz[key] = "key"
    end
  end
  File.open("config.json", "w") { |file| file.write(newz.to_json) }
  system "git add ."
  system "git commit -a -m \"#{message}\""
  system "git push -u origin master"
  File.open("config.json", "w") { |file| file.write(old.to_json) }
end


##it will push to remote repo after commititng if any change exists
##if no change for commit, no commit will happen
##use it always
desc "commit with stagging all changes"
task :deploy, :message do |t, args|
  
  Rake::Task[:commit].invoke(args.message) 
  puts "pushing to remote:"
  system "git remote -v"
  Rake::Task[:push].execute 
  system "git push -u origin master"
  
end

#push only
desc "push to remotes"
task :push do
  system "git push -u origin master"
end

desc "Install Gems"
task :gems do
 JSON.parse(File.read("gems.json"))["gems"].each do |value|
  system("gem install #{value}")
 end 
end