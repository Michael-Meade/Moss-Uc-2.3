require_relative 'utils'
require 'httparty'
require 'json'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Afbi
    extend Discordrb::Commands::CommandContainer
    command(:afbi, description:"<classfied>", usage:"<classfied>") do |event, status|
      channel_id = event.channel.id

      if !["669853278778949652"].include?(channel_id)
        r = HTTParty.get("http://theafbi.com/afbi/1").response.body
        results = JSON.parse(r)["afbi"]
        event.respond(results[0])
      end
    end
    command(:subcount, description: "get sub amount for afbi", usage:".subcount") do |event|
      r = HTTParty.get("http://theafbi.com").response.body
      results = JSON.parse(r)["sub_count"]
      event.respond("**Current Subcount: ** #{results}")
    end
  end
end