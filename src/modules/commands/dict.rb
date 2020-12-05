require 'json'
require 'httparty'
module Bot::DiscordCommands
  	module Events
  		extend Discordrb::Commands::CommandContainer
		command([:u], description:"Search urbandict. Users can also change the result number.", usage:"urban muffins ") do |event, *u, value|
			if value.nil?
				value  = 0 
			end
			urban = HTTParty.get("http://api.urbandictionary.com/v0/define?term=" + event.message.content.to_s.gsub(".u", "").to_s.split("+").shift )
			r     = urban.parsed_response["list"][value.to_i]["definition"]
			event.channel.send_embed("") do |embed|
	          embed.title = event.message.content.to_s.gsub(".u", "").to_s
	          embed.colour = 0x5345b3
	          embed.add_field(name: "Definition",         value: r)
	        end
        end

        command([:ball, :qestion]) do |event|
        	event.respond([ "yes", "no", "maybe. ask again"].sample)
        end
        command([:cyber], description:"Look up an cyber word.", usage:".cyber ip") do |event, term|
        	uri        = URI.parse("https://cyberpolicy.com/api/v1/glossary_terms/" + term.to_s.split(" ").shift)
		    response   = Net::HTTP.get_response(uri)
		    data       =  JSON.parse(response.body)
		    definition =  data['results'][0]['definition'].to_s
	        term       =  data['results'][0]['term'].to_s
	        event.respond("**Definition:** #{definition}\n**Term:** #{term}")
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
        command(:yify, description:"Query Yify's site", usage:".yify Lock, Stock and Two Smoking Barrels") do |event, *s|
        	search = s.join(" ")
        	r = HTTParty.get("https://yts.am/api/v2/list_movies.json?query_term=#{search}").response.body
			a = JSON.parse(r)["data"]["movies"].shift
			t = a["torrents"].shift
			event.channel.send_embed("") do |embed|
	          embed.title = a['title']
	          embed.colour = 0x5345b3
	          embed.description = a['summary']
	          embed.image = Discordrb::Webhooks::EmbedImage.new(url: a['medium_cover_image'])
	          embed.add_field(name: "Year",         value: a['year'])
	          embed.add_field(name: "Run Time",     value: a['runtime'])
	          embed.add_field(name: "Rated",        value: a["rating"].to_s)
	          embed.add_field(name: "Genre",        value: a["genres"].to_s)
	          embed.add_field(name: "Torrent",      value: t["url"])
	          embed.add_field(name: "Quality",      value: t["quality"])
	          embed.add_field(name: "Seeds",        value: t["seeds"].to_s)
	          embed.add_field(name: "Peers",        value: t["peers"].to_s)
	          embed.add_field(name: "size",         value: t["size"].to_s)
	      	end
        end
	end
end
