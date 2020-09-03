require 'json'
require 'httparty'
module Bot::DiscordCommands
  	module Admin
  		extend Discordrb::Commands::CommandContainer
  		def self.get_owner
  			JSON.parse(File.read("config.json"))["owner_id"]
  		end
  		def self.get_admins(user_id)
  			json = JSON.parse(File.read("config.json"))
  			json["admin"].each do |admin|
  				if user_id.to_s == admin.to_s
  					return true
  				end
  			end
  		end
		command([:lyrics], usage:".lyrics on || off") do |event|
			# if owner id OR admin is true
			if ((event.user.id.to_s == get_owner) || (get_admins(event.user.id.to_s) == true))
				puts "yes"
			end
		end
	end
end
