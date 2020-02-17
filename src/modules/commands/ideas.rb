require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  module Idea
    extend Discordrb::Commands::CommandContainer
    command([:projects, :project], description:"Add project ideas", usage:".projects <idea>") do |event, *i|
    	idea = i.join(" ").to_json
    	Utils.create_file("projects", "projects.json", idea)
    end
    command([:lsprojects, :listprojects, :lsproject], description: "List projects", usage:".lsprojects") do |event|
    	Utils.create_list(File.join("projects", "projects.json"))
      event.respond(Utils.create_list(File.join("projects", "projects.json")).to_s)
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