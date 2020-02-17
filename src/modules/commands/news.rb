require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  module News
    extend Discordrb::Commands::CommandContainer
    command([:securelist, :sl], description:"Secure List", usage:".sl>") do |event|
    	dispay = ""
    	rss = open("https://securelist.com/feed/")
    	feed = RSS::Parser.parse(rss)
    	feed.items.each do |item|
    		dispay  += item.link + "\n"
    	end
    	event.respond(dispay)
    end
    command([:threatpost, :tp], description:"Threat Point", usage:".tp") do |event|
    	dispay = ""
    	rss = open("https://threatpost.com/feed/")
    	feed = RSS::Parser.parse(rss)
    	feed.items.each do |item|
    		dispay  += item.link + "\n"
    	end
    	event.respond(dispay)
    end
    command([:checkpoint, :cp], description:"Check Point", usage: ".cp") do |event|
    	dispay = ""
    	rss = open("https://research.checkpoint.com/feed/")
    	feed = RSS::Parser.parse(rss)
    	feed.items.each do |item|
    		dispay  += item.link + "\n"
    	end
    	event.respond(dispay)
    end
  end
end