require 'json'
require 'rss'
require 'open-uri'
require 'rss'
require 'open-uri'
module Bot::DiscordCommands
  	module Events
  		extend Discordrb::Commands::CommandContainer
		command([:events, :event], description:"Get upcomming events at UC", usage:"events") do |event|
      		doc = Nokogiri::HTML(open("https://pioneerplace.utica.edu/events.rss"))
			aa = ""
			url = 'https://pioneerplace.utica.edu/events.rss'
			open(url) do |rss|
				feed = RSS::Parser.parse(rss)
				puts "Title: #{feed.channel.title}"
				feed.items.each do |item|
					document = Nokogiri::HTML(item.description)
					
					aa += "**#{item.title}**" + "\n" + document.at('time').text + "\n"
				end
			end
		event.respond(aa)
      	end
	end
end