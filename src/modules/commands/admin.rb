require 'json'
require 'httparty'
module Bot::DiscordCommands
  	module Admin
  		extend Discordrb::Commands::CommandContainer
  		def self.get_owner
  			JSON.parse(File.read("config.json"))["owner_id"]
  		end
      def self.read_config
        JSON.parse(File.read("config.json"))
      end
  		def self.get_admins(user_id)
  			json = JSON.parse(File.read("config.json"))
  			json["admin"].each do |admin|
  				if user_id.to_s == admin.to_s
  					return true
  				end
  			end
  		end

    command(:debug) do |event|
      config = read_config
      if !read_config.has_key?("debug")
        config["debug"] = true
        File.open("config.json", "w") { |file| file.write(config.to_json) }
      else
        if config["debug"].to_s == true
          config["debug"] = false
        elsif config["debug"] == true
          config["debug"] = false
        end
        File.open("config.json", "w") { |file| file.write(config.to_json) }
      end
    end
		command([:lyrics], usage:".lyrics on || off") do |event|
			# if owner id OR admin is true
			if ((event.user.id.to_s == get_owner) || (get_admins(event.user.id.to_s) == true))
        puts "1"
        read = JSON.parse(File.read("config.json"))
        if read["lyrics-troll"] == true
          puts "2"
          read["lyrics-troll"] = false
          File.open("config.json", "w") { |file| file.write(read.to_json) }
        elsif read["lyrics-troll"] == false
          puts "3"
          read["lyrics-troll"] = true
          File.open("config.json", "w") { |file| file.write(read.to_json) }
        end
			end
		end
	end
end
