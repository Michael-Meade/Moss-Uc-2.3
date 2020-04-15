require 'json'
require 'digest'
require_relative 'utils'
module Bot::DiscordCommands
  module MemesDirectory
    extend Discordrb::Commands::CommandContainer
    command([:projects, :project], description:"Add project ideas", usage:".projects <idea>") do |event, *i|
    	idea = i.join(" ").to_json
    	Utils.create_file("projects", "projects.json", idea)
    end
    command(:random, description: "Get random shite memes", usage:".random") do |event|
    	#image = Dir.glob("memes/random/*").sample
    	if event.message.attachments[0].nil?
    		event.send_file(File.open(Dir.glob("memes/random/*").sample, 'r'))
    	else
           img = HTTParty.get(event.message.attachments[0].url).response.body
            f = File.open(File.join("memes", "random", Digest::MD5.hexdigest(img)  +  ".png"), "w")
            f.write(img)
            f.close
    		#File.join("memes", "cyber", Digest::MD5.hexdigest(img) + ".png")
            #f = File.open(File.join("memes", "random", Digest::MD5.hexdigest(img) 1 +  img.split(".")[1], "w"))
    		#f.write(img)
    		#f.close
    	end
    end
    command(:sec, description: "cyber memes for days", usage: ".sec") do |event|
        if event.message.attachments[0].nil?
            event.send_file(File.open(Dir.glob("memes/cyber/*").sample, 'r'))
        else
            img = HTTParty.get(event.message.attachments[0].url).response.body
            f   = File.open(File.join("memes", "cyber", Digest::MD5.hexdigest(img) + ".png"), "w")
            f.write(img)
            f.close
        end
    end
  end
end