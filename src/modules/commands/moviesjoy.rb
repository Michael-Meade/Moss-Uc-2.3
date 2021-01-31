require 'httparty'
require 'json'
require 'fileutils'
require 'time'
module Bot::DiscordCommands
  module MovieJoy
    extend Discordrb::Commands::CommandContainer
    command(:mjoy) do |event, *search|
        p search
        base = "https://moviesjoy.to/search/#{search.join("-")}"
    end
  end
end