require 'json'
module Bot::DiscordCommands
  module Tell
    extend Discordrb::Commands::CommandContainer
      command([:tell], description:"tell someone a message", usage:".tell stacy moms ") do |event, *a|
        
        p event.server.users
        #File.open("tell_list.json", "a") { |file| file.write(l.to_json) }
      end
    end
end
