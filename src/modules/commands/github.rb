require 'mechanize'
module Bot::DiscordCommands
  module Github
    extend Discordrb::Commands::CommandContainer
    command(:github,  description:"View uc3's github", usage:".github") do |event|
    	string =  "Malware Samples - https://github.com/UticaCollegeCyberSecurityClub/samples\n"
    	string += "Resources - https://github.com/UticaCollegeCyberSecurityClub/Resources\n"
    	string += "Lists - https://github.com/UticaCollegeCyberSecurityClub/Lists\n"
    	string += "Linux Guide - https://github.com/UticaCollegeCyberSecurityClub/LinuxGuide\n"
    	string += "Crypto Resources - https://github.com/UticaCollegeCyberSecurityClub/Cryptography-Resources\n"
    	string += "Video Resources - https://github.com/UticaCollegeCyberSecurityClub/VideoResources\n"
    	string += "Malware Resources - https://github.com/UticaCollegeCyberSecurityClub/MalwareResources"
		event.respond(string)
    end
  end
end