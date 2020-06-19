require_relative 'bashbunny/bunny'
require_relative "utils"
require 'json'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module  BashBunnys
    extend Discordrb::Commands::CommandContainer
    command :bunny do |event, *args|
    	list = Utils.list_dir(File.join(__dir__, "bashbunny", "templates"))
    	puts list.split(".txt").to_json.strip
    	if args[0].nil? || args[0] == "ls"
    		rsp = list.gsub(File.join(__dir__, "bashbunny", "templates"), "").gsub(".txt", "").gsub("/", "")
    		event.respond(rsp.to_s)
    	end
    	#BashBunny.mac_reverse_shell("mike2", ["127.0.0.1", "8888"])
    end
  end
end
