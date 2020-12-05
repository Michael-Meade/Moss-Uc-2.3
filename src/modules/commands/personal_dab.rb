require 'httparty'
require_relative 'utils'
require 'open-uri'
require 'fileutils'
module Bot::DiscordCommands
  module PersonalDab
    extend Discordrb::Commands::CommandContainer
    command([:pd, :personaldab], description:"Personal Dab", usage:".pd <link>") do |event|
        FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
    	url      = event.message.attachments[0].url
    	content  = HTTParty.get(url).response.body
		download = open(url)
		IO.copy_stream(download, File.join("users", event.user.id.to_s, "dab", "dab.gif"))
    end
  end
end