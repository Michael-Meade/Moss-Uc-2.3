require 'httparty'
require 'json'
require 'fileutils'
require 'time'
module Bot::DiscordCommands
  module Stocks
    extend Discordrb::Commands::CommandContainer
    command(:moviejoy) do |event, search|
        base = "https://moviesjoy.to/search/"
        event.respond(base.concat(search.split(" ").join("-")))
    end
  end
end