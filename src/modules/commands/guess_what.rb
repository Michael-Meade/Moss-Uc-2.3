require "httparty"
module Bot::DiscordCommands
	module Memes
		def self.image_list
			[
				"boom.gif",
				"eats.png",
				"slap.jpg"
			]
		end
		def self.list
			rsp = HTTParty.get("https://crhallberg.com/cah/output.php").response.body
		end
		extend Discordrb::Commands::CommandContainer
		command([:fact],  description:"Random Fact", usage:".fact") do |event|
			puts list
			event.send_file(File.open("guesswhat/#{image_list.samle}", 'r'))
		end
	end
end