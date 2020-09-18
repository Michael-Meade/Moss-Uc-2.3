require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Config
    extend Discordrb::Commands::CommandContainer
	    command([:status], description:"Check Config Status", usage:".status <word>") do |event, *i|
	    	status = i.join(" ")
	    	read_status = Utils.read_list(File.join("config", "config.json"))
	    	begin
	    		event.respond(read_status[status].to_json)
	    	rescue => e
	    		event.respond("Check Again. Status doesnt exist.")
	    	end
	    end
	    command([:set], description:"Set config", usage:".set <status> <string>") do |event, status, *string|
	    	string = string.join(" ")
	    	id = Utils.get_last_key(File.join("config", "config.json"))
			# read & parse file
	    	current_file = Utils.read_list(File.join("config", "config.json"))
	    	f = File.open(File.join("config", "config.json"), "w")
	    	# add new idea to current file
	    	current_file[status] = string
	    	f.write(JSON.pretty_generate(current_file))
	    	f.close
	    end
	end
end