require 'mechanize'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Github
    extend Discordrb::Commands::CommandContainer
    command(:github,  description:"View uc3's github", usage:".github") do |event|
    	string =  "Malware Samples - https://github.com/UticaCollegeCyberSecurityClub/samples\n"
    	string += "Resources - https://github.com/UticaCollegeCyberSecurityClub/Resources\n"
    	string += "Lists - https://github.com/UticaCollegeCyberSecurityClub/Lists"
		event.respond(string)
    end
  end
end