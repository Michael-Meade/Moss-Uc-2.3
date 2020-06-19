require 'json'
require 'open-uri'
require 'rss'
require 'nokogiri'
require_relative 'utils'
require 'httparty'
require 'rss'
class Reader
    def info(site)
        i = 0
        array = []
        rss = HTTParty.get(site, {headers: {"User-Agent" => "Httparty"}}).body
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
            if i.to_i <=  2
                array += [[item.title, item.link]]
                i += 1
            end
        end
    array
    end
end
class Finder
    def self.for(site_id)
        case site_id.to_s
        when "1"
            "https://www.bleepingcomputer.com/feed/"
        when "2"
            "https://www.hackread.com/feed/"
        when "3"
            "http://feeds.feedburner.com/feedburner/Talos"
        when "4"
            "https://threatpost.com/feed/"
        when "6"
            "http://feeds.feedburner.com/PaloAltoNetworks"
        else
            "error"
        end
    end
end
class Scraper
    def self.rss(site_id)
        site = Finder.for(site_id)
        Reader.new.info(site)
    end
end
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
    command(:news) do |event, id|
        r = Scraper.rss(id.to_s)
        if r != "error"
            out = ""
            r.each do |l|
                out += "**" + l[0].to_s + "**"
                out += "\n"
                out += "<" + l[1].to_s + ">"
                out += "\n"
            end
        end
    out if !out.blank?
    end
  end
end