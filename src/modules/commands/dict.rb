require 'json'
require 'httparty'
module Bot::DiscordCommands
  	module Events
  		extend Discordrb::Commands::CommandContainer
		command([:u], description:"Search urbandict. Users can also change the result number.", usage:"urban muffins ") do |event, *u, value|
			if value.nil?
				value  = 0 
			end
			urban = HTTParty.get("http://api.urbandictionary.com/v0/define?term=" + event.message.content.to_s.gsub(".u", "").to_s.split(" ").to_s )
			r     = urban.parsed_response["list"][value.to_i]["definition"]
			event.respond(r.to_s)
        end
        command([:cyber], description:"Look up an cyber word.", usage:".cyber ip") do |event, term|
        	uri        = URI.parse("https://cyberpolicy.com/api/v1/glossary_terms/" + term.to_s.split(" ").shift)
		    response   = Net::HTTP.get_response(uri)
		    data       =  JSON.parse(response.body)
		    definition =  data['results'][0]['definition'].to_s
	        term       =  data['results'][0]['term'].to_s
	        event.respond("**Definition:** #{definition}\n**Term:** #{term}")
        end
        command(:yify, description:"Query Yify's site", usage:".yify Lock, Stock and Two Smoking Barrels") do |event, search|
        	search = search.to_s.split(" ").shift
        	r = HTTParty.get("https://yts.am/api/v2/list_movies.json?query_term=#{search}").response.body
			a = JSON.parse(r)["data"]["movies"].shift
			t = a["torrents"].shift
			event.respond("**Title:** #{a['title']}\n**Year:** #{a['year']}\n**Rating:** #{a['rating']}\n**Run Time:** #{a['runtime']}\n**Genre:** #{a['genres']}\n**Summary:** #{a['summary']}\n**Picture:** #{a['large_cover_image']}\n**Torrent:** #{t['url']}\n**Quality:** #{t['quality']}\n**Seeds:** #{t['seeds']}\n**Peers:** #{t['peers']}\n**Size:** #{t['size']}")
        end
	end
end
