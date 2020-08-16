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
  system "git add ."
  system "git commit -a -m \"#{message}\""
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