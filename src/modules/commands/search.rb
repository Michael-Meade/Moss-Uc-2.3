require 'httparty'
require 'json'
require 'date'
 require 'uri'
require 'net/http'
require 'openssl'
require 'nokogiri'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Search
    extend Discordrb::Commands::CommandContainer
    def self.send_embed(event:, title:, fields:, description: nil)
          event.channel.send_embed do |embed|
            embed.title       = title
            embed.description = description
            fields.each { |field| embed.add_field(name: field[:name], value: field[:value], inline: field[:inline]) }
          end
      end
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
    command(:dog) do |event|
      r = HTTParty.get("https://some-random-api.ml/facts/dog", { "headers": {"Accept": "text/plain"}}).body
      j = JSON.parse(r)["fact"]

    end
    command(:dogs) do |event|
    	rsp = HTTParty.get("https://dog.ceo/api/breeds/image/random").body
    	j   = JSON.parse(rsp)["message"]
    	event.respond(j.to_s)
    end
    command([:tv], description:"get tv show info", usage: ".tv white collar") do |event, *tv|
      tv = tv.join("+")
      rsp = JSON.parse(HTTParty.get("https://api.duckduckgo.com/?q=#{tv}&ia=tv&format=json&pretty=1").response.body)
      p rsp
      p rsp["AbstractText"]
    end
    command(:fucks) do |event|
      rsp = HTTParty.get("https://foaas.com/give/Tom/", { "headers": { "Accept": "text/plain" } } ).body
      event.respond(rsp)
    end
    command(:fuck) do |event|
      rsp = HTTParty.get("https://mashape-community-foaas.p.rapidapi.com/give/Tom", { "headers": { "x-rapidapi-host": "mashape-community-foaas.p.rapidapi.com",
      "x-rapidapi-key": "43df40edcbmshedcb486089d69d8p16f911jsnf55da72fd24c", "Accept": "text/plain" }} ).body
      puts rsp
    end
    command(:s, description:"Search for somethng", usage:".s blockchains") do |event,*search|
      page = Nokogiri::HTML.parse(open("https://duckduckgo.com/html/?q=#{search.join("+")}"))
      puts page.xpath('//*[@id="links"]/div[1]/div/div[1]/div/a').text.strip
      event.channel.send_embed("") do |embed|
        embed.title = page.xpath('//*[@id="links"]/div[1]/div/h2/a').text.to_s

        embed.url   =  "https://" + page.xpath('//*[@id="links"]/div[1]/div/div[1]/div/a').text.strip.to_s
        #page.xpath('//*[@id="links"]/div[1]/div/div[1]/div/a').text.strip.to_s
        embed.colour = 0x5345b3
        p page.xpath('//*[@id="links"]/div[1]/div/a').text
        embed.description = page.xpath('//*[@id="links"]/div[1]/div/a').text.to_s


          #page.xpath('//*[@id="links"]/div[1]/div/div[1]/div/a').text.to_s
          #embed.title = page.css('body > div:nth-child(3) > div.zci-wrapper > div > h1 > a')
          
          #//*[@id="links"]/div[1]/div

          #//*[@id="zero_click_abstract"]
          
            #page.xpath('//*[@id="links"]/div[1]/div').text.to_s.strip.to_s)
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
      rsp = HTTParty.get("https://api.duckduckgo.com/?q=#{search.join("+").strip}&format=json&pretty=1")
      j   = JSON.parse(rsp.response.body)
      p j 
      h = []
      if j["Infobox"].empty?
        rt = j["RelatedTopics"].shift
        require "uri"
        url = URI.extract(rt["Result"]).shift.to_s
        r2  = HTTParty.get("https://api.duckduckgo.com/?q=#{url.split("/")[-1].gsub("_", "+")}&format=json&pretty=1").response.body
        j = JSON.parse(r2)
        p ":::::::"
        p j
        j.to_hash["Infobox"]["content"].each do |key|
          h << { name: key["label"], value: key["value"]}
        end
        send_embed(event: event, title: search.join(" ").strip.to_s, description: j["AbstractText"].to_s, fields: h.first(h.size - 1))
      else
        j.to_hash["Infobox"]["content"].each do |key|
          h << { name: key["label"], value: key["value"]}
        end
        send_embed(event: event, title: search.join(" ").strip.to_s, description: j["AbstractText"].to_s, fields: h.first(h.size - 2))
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
      event.channel.send_embed("") do |embed|
          embed.title = json["Title"]
          embed.colour = 0x5345b3
          embed.url = "https://www.imdb.com/title/#{json["imdbID"]}"
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
    end
    command(:insult, description: "Insult someone", usage: ".insult") do |event|
      j = JSON.parse(HTTParty.get("https://evilinsult.com/generate_insult.php?lang=en&type=json").response.body)["insult"]
      event.respond(j.to_s)
    end
    command([:strains, :strain]) do |event, *s|
      j = HTTParty.get("http://strainapi.evanbusse.com/48veAlM/strains/search/name/#{s.join("%20")}", { headers: { "Accept-Encoding"   => "json"}} ).body
      j = JSON.parse(j).shift
      event.channel.send_embed("") do |embed|
          embed.title = j['name'].to_s
          embed.colour = 0x5345b3
          embed.description = j['desc'].to_s
          embed.add_field(name: 'Race',         value: j['race'].to_s)
      end
    end
    command(:pun, description: "get a pun", usage: ".pun") do |event|
      uri = URI.parse('https://getpuns.herokuapp.com/api/random')
      response = Net::HTTP.get_response(uri)
      data = JSON.parse(response.body)
      event.channel.send_embed("") do |embed|
          embed.title = "Pun Fun"
          embed.description = data['Pun']
      end
    end
    command(:joke) do |event|
      rsp = HTTParty.get("https://icanhazdadjoke.com", { headers: { "Accept": "text/plain"} }).response.body
      event.respond(rsp)
    end
    command(:geek) do |event|
      event.respond( HTTParty.get("https://geek-jokes.sameerkumar.website/api").body.to_s)
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
        event.channel.send_embed("") do |embed|
          embed.title  = id['weather'][0]['main']
          embed.colour = 0x5345b3
          embed.description = id['weather'][0]['description']
          embed.add_field(name: "Temp",         value: id['main']['temp'].to_s)
          embed.add_field(name: "Humidity",     value: id['main']['humidity'].to_s)
          embed.add_field(name: "Temp Min",     value: id['main']['temp_min'].to_s)
          embed.add_field(name: "Temp Max",      value: id['main']['temp_max'].to_s)
          #event.respond("***Main:*** #{id['weather'][0]['main']} \n ***Description:*** #{id['weather'][0]['description']} \n ***Temp:*** #{id['main']['temp']} \n ***Humidity:*** #{id['main']['humidity']} \n ***Temp Min:*** #{id['main']['temp_min']} \n ***Temp Max:*** #{id['main']['temp_max']}".to_s)
        end
      end
    end
  end
end
