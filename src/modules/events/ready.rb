module Bot::DiscordEvents
  # This event is processed each time the bot succesfully connects to discord.
  module Ready
    extend Discordrb::EventContainer
    def self.check_file(file, string)
      s = true
    	File.open("lyrics.txt").each_with_index do |line, i|  
        line.chomp!
        if s.to_s == "false"
          return line
          break
        end
        if line.match(string)
          s = false
        end
         # Do whatever you want to here  
      end
    end
    message(starting_with: not!(".")) do |event|
    	puts 
    	#q = check_file("lyrics.txt", event.message.content.to_s)
      #event.respond(q)
    end
  end
end
=begin
while(line = fh.gets) != nil
              puts "#{line}"
              break if line.include?(")")
            end
=end
