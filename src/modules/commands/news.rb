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
    def self.json
        {
          "content": "Zdnet",
          "embed": {
            "title": "",
            "description": "this supports [named links](https://discordapp.com) on top of the previously shown subset of markdown. ```\nyes, even code blocks```",
            "url": "https://discordapp.com",
            "color": 13632027,
            "timestamp": "2020-08-16T00:28:11.899Z",
            "author": {
              "name": "author name"
            }
          }
        }
    end
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
    command(:cyber) do |event|
        mechanize = Mechanize.new
        page   = mechanize.get('https://www.zdnet.com/meet-the-team/us/catalin.cimpanu/')
        event.channel.send_embed("Zdnet") do |embed|
          embed.title = page.at('//*[@id="articles-loadMore"]/article[1]/div/div[2]/h3/a').text
          embed.colour = 0x750132
          embed.url = "https://www.zdnet.com" +  page.at('//*[@id="articles-loadMore"]/article[1]/div/div[2]/h3/a').values.first
          embed.description = page.at('//*[@id="articles-loadMore"]/article[1]/div/div[2]/p[1]').text
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: page.at('//*[@id="articles-loadMore"]/article[1]/div/div[2]/p[2]/a').text.to_s)
        end
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