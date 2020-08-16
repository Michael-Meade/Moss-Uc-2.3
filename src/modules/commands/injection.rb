require_relative 'utils'
require_relative 'injection/sql'
module Bot::DiscordCommands
	module Injection
		extend Discordrb::Commands::CommandContainer
		command([:sql],  description:"practicing sql", usage:".sql") do |event|
			c = event.message.content.to_s.gsub(".sql", "")
			SqlInjection.challenge_1(c)
		end
	end
end