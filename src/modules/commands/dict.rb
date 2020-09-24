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
