require 'json'
require 'httparty'
require_relative 'utils'

module Bot::DiscordCommands
  module Stocks
    extend Discordrb::Commands::CommandContainer
    command([:stocl], description: "Stock prices", usage:".stocl PEP") do |event, symbol|
     resp =  HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=PEPZ&apikey=XLZJ1BYAORGE28UE").response.parsed_response
     puts resp["Global Quote"]
    end
  end
end
=begin
Utils.create_dir("projects", file_name="projects.json")
    	if File.exists?(File.join("projects", "projects.json"))
			id = Utils.get_last_key(File.join("projects", "projects.json"))
	    	file_read = File.read(File.join("projects", "projects.json"))
	    	a = JSON.parse(file_read)
	    	f = File.open(File.join("projects", "projects.json"), "w")
	    	puts a[id] = idea
	    	f.write(JSON.pretty_generate(a))
	    	f.close
    	else
	    	f = File.open(File.join("projects", "projects.json"), "w")
			f.write(JSON.pretty_generate(JSON.pretty_generate({"0" => idea})) )
			f.close
	    end
=end