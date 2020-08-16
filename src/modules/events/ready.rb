require 'similar_text'


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
      end
    nil
    end
    def self.check(file, string)
      s = true
      File.open("lyrics.txt").each_with_index do |line, i|
        if s == false
          return line
          s = true
          break
        end
        
        if line.strip.similar(string.strip).to_i >= 80
          p line.strip.similar(string.strip)
          s = false
        end
      end
      #"Hello, World!".similar("Hello World!") #=> 96.0
    nil
    end
    message(starting_with: not!(".")) do |event|
     lo = check("", event.message.content.to_s)
     if !lo.nil?
      event.respond(lo)
     end 
    end
  end
end
=begin
while(line = fh.gets) != nil
              puts "#{line}"
              break if line.include?(")")
            end
=end
=begin
list = File.read("config.json")
      j    = JSON.parse(list)["lyrics-troll"]
      if j == true
        q = check_file("lyrics.txt", event.message.content.to_s)
        event.respond(q)
      end
=end