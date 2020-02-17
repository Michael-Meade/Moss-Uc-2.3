require 'httparty'
require_relative 'utils'
module Bot::DiscordCommands
  module PersonalDab
    extend Discordrb::Commands::CommandContainer
    command([:pd, :personaldab], description:"Personal Dab", usage:".pd <link>") do |event|
    	url      = event.message.attachments[0].url
    	content  = HTTParty.get(url).response.body
    	Utils.user_directory(event.user.id.to_s, "dab.png", content, "png")
    end
  end
end