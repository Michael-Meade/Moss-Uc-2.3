require_relative 'utils'
require 'httparty'
require	'json'
require "open-uri"
module Bot::DiscordCommands
	module Facts
		extend Discordrb::Commands::CommandContainer
		command([:fact],  description:"Random Fact", usage:".fact") do |event|
			Utils.create_dir("troll", file_name="troll")
			troll_status = Utils.read_list(File.join("config", "config.json"))["troll"].to_s
			if  troll_status == true || troll_status == true
				read = File.read("fake/fake_fact.json")
				fact = JSON.parse(read)
				event.respond(fact[rand(0..fact.keys.last.to_i).to_s].to_s)
			else
				results = HTTParty.get("https://uselessfacts.jsph.pl/random.json?language=en").response.body
				event.respond(JSON.parse(results)["text"].to_s)
			end
		end
		command([:kanye, :west], description: "Kanye west") do |event|
			r = JSON.parse(HTTParty.get("https://api.kanye.rest/").response.body)
			event.channel.send_embed("") do |embed|
	          embed.title = "Kanye West Quotes"
	          embed.description = r["quote"]
	      	end
		end
		command([:trump], description: "What does trump think?", usage: ".trump") do |event|
			rsp = HTTParty.get("https://api.tronalddump.io/random/quote").response.body
			j   = JSON.parse(rsp)
			event.channel.send_embed("") do |embed|
	          embed.title = "What does Donald Trump Think?"
	          embed.description = j["value"]
	      	end
		end
		command([:catfact, :cat], description: "Get a cat fact", usage: ".catfact") do |event|
			r = HTTParty.get("https://catfact.ninja/fact").response.body
			j = JSON.parse(r)
			event.channel.send_embed("") do |embed|
	          embed.title = "Cat Fact"
	          embed.description = j["fact"]
	      	end
		end
	end
end