require 'json'
require 'open3'
module Bot::DiscordCommands
  	module Banner
  		extend Discordrb::Commands::CommandContainer
		command([:banner], description:"Get sites baner", usage:".banner site.com") do |event, site|
			stdout, status = Open3.capture2("curl -I #{site}")
			event.respond(stdout.to_s)
        end
	end
end
