require 'httparty'
require 'json'
require 'date'
require 'nokogiri'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Flix
    extend Discordrb::Commands::CommandContainer
    command(:flix, description:"Get random movie", usage:".flix") do |event|
      req = HTTParty.get("https://api.reelgood.com/v3.0/content/roulette/netflix?availability=onAnySource&content_kind=both&genre=9&nocache=true&region=us")
      json = JSON.parse(req.body)
      event.channel.send_embed("") do |embed|
          embed.title = json["title"]
          embed.colour = 0x5345b3
          embed.description = json["overview"]
          embed.add_field(name: "Run Time",     value: json["runtime"])
          embed.add_field(name: "IMDB Rating",  value: json["imdb_rating"].to_s)
          embed.add_field(name: "Released",     value: json["released_on"])
      end
    end
    command(:hulu) do |event|
      req = HTTParty.get("https://api.reelgood.com/v3.0/content/roulette/hulu_plus?availability=onAnySource&content_kind=both&genre=9&nocache=true&region=us")
      j   = JSON.parse(req.body)
      event.channel.send_embed("") do |embed|
        embed.title         = j["title"]
        embed.colour        = 0x5345b3
        embed.description   = j["overview"]
        embed.add_field(name: "Run Time",     value: j["runtime"])
        embed.add_field(name: "IMDB Rating",  value: j["imdb_rating"].to_s)
        embed.add_field(name: "Released",     value: j["released_on"])
      end
    end
  end
end
