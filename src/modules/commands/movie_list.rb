require 'httparty'
module Bot::DiscordCommands
  module MovieList
    extend Discordrb::Commands::CommandContainer
    command(:moviedb, description:"Search for movie", usage:".moviedb Lock, Stock and Two Smoking Barrels") do |event|
      s = event.message.content.to_s.gsub(".moviedb ", "").gsub(" ", "%20")
      req = HTTParty.get("http://www.omdbapi.com/?t=#{s}&apikey=24102450")
      json = JSON.parse(req.body)
      message = "**Movie:** #{json['Title']}\n **Year:** #{json['Year']}\n **RunTime:** #{json['Runtime']}\n **IMDB Rating:** #{json['imdbRating']}\n **Plot:** #{json['Plot']}\n **Genre:** #{json['Genre']}"
      event.respond(message.to_s)
    end
  end
end
