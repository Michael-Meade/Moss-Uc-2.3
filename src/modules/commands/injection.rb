require_relative 'utils'
require 'httparty'
require	'json'
require "open-uri"
module Bot::DiscordCommands
	module Injection
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
	end
end