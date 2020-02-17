require 'httparty'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Search
    extend Discordrb::Commands::CommandContainer
    def self.youtube(search, value=nil)
      if value.nil?
        puts "https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyCCB4q5YuxILXTc8o_anxgjpibeAATUg70&q=#{search.to_s}"
    		g = HTTParty.get("https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyCCB4q5YuxILXTc8o_anxgjpibeAATUg70&q=#{search.to_s}").body
    		JSON.parse(g)['items'][0]['id']["videoId"]
    	else
    		g = HTTParty.get("https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyCCB4q5YuxILXTc8o_anxgjpibeAATUg70&q=#{search}").body
    		JSON.parse(g)['items'][value]['id']["videoId"]
    	end
    end
    command :yt do |event, *search, value|
    	s = event.message.content.to_s.gsub(".yt ", "").gsub(" ", "%20")
      begin
      	     event.respond("https://www.youtube.com/watch?v=#{youtube(s)}".to_s)
    	rescue => e
    		puts e
    	end
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
