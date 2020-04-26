require 'httparty'
module Bot::DiscordCommands
  module Inforgraphic
    extend Discordrb::Commands::CommandContainer
    command([:lsinfo, :lsinforgraphics, :lsinforgraphic], description:"List the Inforgraphics", usage:".lsinfo") do |event|
    	event.respond(Utils.list_dir("infographics").to_s)
    end
    command([:info, :inforgraphics, :inforgraphic, description:"Pick a Inforgraphic", usage:".info"]) do |event, pick|
    	event.send_file(File.open(Utils.get_file("infographics", pick).to_s, 'r'))
    end 
   end
end
