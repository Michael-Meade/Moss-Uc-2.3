require_relative 'utils'
require_relative 'nmap/nmap/nmap'
module Bot::DiscordCommands
  module Map
    extend Discordrb::Commands::CommandContainer
    	command([:lsnmap],  description:"List Nmap commands", usage:".lsnmap") do |event|
    		list = Nmap.list_commands
            event.respond(list.to_s)
    	end
        command(:nmap, description:"nmap", usage:".nmap 1 ") do |event, ip, num|
            Nmap.get_commands(ip, num, File.join("users", event.user.id.to_s, "nmap.txt"))
        event.send_file(File.open(File.join("users", event.user.id.to_s, "nmap.txt")))
        end
	end
end