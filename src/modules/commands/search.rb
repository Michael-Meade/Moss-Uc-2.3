require 'httparty'
require 'json'
require 'date'
require 'nokogiri'
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
    command([:tv], description:"get tv show info", usage: ".tv white collar") do |event, *tv|
      tv = tv.join("+")
      rsp = JSON.parse(HTTParty.get("https://api.duckduckgo.com/?q=#{tv}&ia=tv&format=json&pretty=1").response.body)
      p rsp
      p rsp["AbstractText"]
      #["Text"]
      #event.respond(rsp.to_s)
    end
    command(:s, description:"Search for somethng", usage:".s blockchains") do |event, *search|
      #{search.join("+")}"
      page = Nokogiri::HTML.parse(open("https://duckduckgo.com/html/?q=#{search.join("+")}"))
      event.channel.send_embed("l") do |embed|
          embed.title = search.join(" ").to_s
          embed.colour = 0x5345b3
          embed.add_field(name: "Year",         value: page.xpath('//*[@id="zero_click_abstract"]').text.to_s.strip.to_s)
      end
      #zero_click_abstract
    end
    command([:date], description:"History is fun", usage: ".date") do |event|
      d = Time.new
      b = HTTParty.get("http://numbersapi.com/#{d.month}/#{d.day}/date").response.body
      event.channel.send_embed("") do |embed|
          embed.title = "Today In History"
          embed.colour = 0x5345b3
          embed.description = b
          embed.timestamp  = Time.now

      end
    end
    command([:wiki], description:"get wiki", usage:".wiki blockchain") do |event, *search|
      s   = search.join("+")
      if not s.empty?
        rsp = JSON.parse(HTTParty.get("https://api.duckduckgo.com/?q=#{s}&format=json&pretty=1&no_html=1&skip_disambig=1").response.body)
        p rsp["AbstractText"]
        if not rsp["AbstractText"].empty?
          puts ":::"
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
      p json
      event.channel.send_embed("l") do |embed|
          embed.title = json["Title"]
          embed.colour = 0x5345b3
          embed.url = "https://discordapp.com"
          embed.description = json['Plot']
          embed.timestamp = Time.at(1586462698)
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: json["Poster"])
          embed.add_field(name: "Year",         value: json['Year'])
          embed.add_field(name: "Run Time",     value: json['Runtime'])
          embed.add_field(name: "IMDB Rating",  value: json["imdbRating"].to_s)
          embed.add_field(name: "Rated",        value: json["Rated"])
          embed.add_field(name: "Released",     value: json["Released"])
          embed.add_field(name: "Production",   value: json["Production"])
          embed.add_field(name: "Box Office",   value: json["BoxOffice"])
          embed.add_field(name: "Genre",        value: json["Genre"])

      end
      #message = "**Movie:** #{json['Title']}\n **Year:** #{json['Year']}\n **RunTime:** #{json['Runtime']}\n **IMDB Rating:** #{json['imdbRating']}\n **Plot:** #{json['Plot']}\n **Genre:** #{json['Genre']}"
      #event.respond(message.to_s)
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
