require 'httparty'
require 'json'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Search
    extend Discordrb::Commands::CommandContainer
    def self.youtube(search, value=nil)
      api = JSON.parse(File.read("config.json"))["youtube"]
      puts api
      puts search
      puts "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{api}&q=#{search.to_s}"
      if value.nil?
    		g = HTTParty.get("https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{api}&q=#{search.to_s}").body
    		return JSON.parse(g)['items'][0]['id']["videoId"]
    	else
    		g = HTTParty.get("https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{api}&q=#{search}").body
    		return JSON.parse(g)['items'][value]['id']["videoId"]
    	end
    end
    command :yt do |event, *search, value|
    	s = event.message.content.to_s.gsub(".yt ", "").gsub(" ", "%20")
      p youtube(s)
      begin
        
      	     event.respond("https://www.youtube.com/watch?v=#{youtube(s)}".to_s)
    	rescue => e
    		puts e
    	end
    end
    command([:wiki], description:"get wiki", usage:".wiki blockchain") do |event, *search|
      s   = search.join("+")
      if not s.empty?
        rsp = JSON.parse(HTTParty.get("https://api.duckduckgo.com/?q=#{s}&format=json&pretty=1&no_html=1&skip_disambig=1").response.body)
        if not rsp["AbstractText"].empty?
          event.respond("#{rsp["AbstractText"].to_s}")
        end
      else
        event.respond("**try:** \n .wiki blockchain")
      end
    end
    command([:manpages, :man], description:"Get access to manpage", usage:".man torsocks") do |event, item|
     response = HTTParty.get("https://www.mankier.com/api/v2/explain/?cols=70&q=#{item.strip}").response.body.to_s
     event.respond(response)
    end
    command(:moviedb, description:"Search for movie", usage:".moviedb Lock, Stock and Two Smoking Barrels") do |event|
      s = event.message.content.to_s.gsub(".moviedb ", "").gsub(" ", "%20")
      req = HTTParty.get("http://www.omdbapi.com/?t=#{s}&apikey=24102450")
      json = JSON.parse(req.body)
      message = "**Movie:** #{json['Title']}\n **Year:** #{json['Year']}\n **RunTime:** #{json['Runtime']}\n **IMDB Rating:** #{json['imdbRating']}\n **Plot:** #{json['Plot']}\n **Genre:** #{json['Genre']}"
      event.respond(message.to_s)
    end
    command(:weed, description:"classfied", usage:".weed word") do |event, strain, num|
      if num.nil?
        num = 0
      end
      strain = strain.to_s.split(" ")
      g = HTTParty.get("https://cannasos.com/api/search?page=1&search=#{strain}&type=strain")
      strain_id = g.parsed_response[num]
      event.respond("https://render.cannasos.com/api/strain/#{strain_id['_id'].to_s}/#{strain.shift}.jpeg?format=jpeg")
      event.respond("https://render.cannasos.com/api/strain/#{strain_id.to_s}/#{strain.shift}.jpeg?format=jpeg")
    end
    command([:w, :weather], description:"Get Current news.", usage:".news <idea>") do |event, zip|
      response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?zip=" + zip + ",us&appid=3e029d9d2895ddf14349dbaf24cc0851&units=imperial")
      id =  response.parsed_response
      if id["cod"] == "404"
        "Zip code doesnt exist"
      else
          event.respond("***Main:*** #{id['weather'][0]['main']} \n ***Description:*** #{id['weather'][0]['description']} \n ***Temp:*** #{id['main']['temp']} \n ***Humidity:*** #{id['main']['humidity']} \n ***Temp Min:*** #{id['main']['temp_min']} \n ***Temp Max:*** #{id['main']['temp_max']}".to_s)
      end
    end
  end
end
