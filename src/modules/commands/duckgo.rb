require 'httparty'
require 'json'
require 'date'
 require 'uri'
require 'net/http'
require 'openssl'
require 'nokogiri'
module Bot::DiscordCommands
  module DuckSearch
    extend Discordrb::Commands::CommandContainer
    class DuckGo
        def initialize(search, index=nil)
            @index  = index
            @search = search.split
            @page   = Nokogiri::HTML.parse(HTTParty.get("https://duckduckgo.com/html/?q=#{@search.join("+")}").body)
            if @index.nil?
            end
        end
        def title
            @page.xpath('//*[@id="links"]/div[1]/div/h2/a').text.to_s
        end
        def url
            "https://" + @page.xpath('//*[@id="links"]/div[1]/div/div[1]/div/a').text.strip.to_s
        end
        def results
            [ title, url ]
        end
    end
    CROSS_MARK = "\u274c"
    command(:g, description:"Search for somethng", usage:".s blockchains") do |event, *search|
        duck_results = DuckGo.new(search, i).results
        msg = event.channel.send_embed("") do |embed|
            embed.title = duck_results[0]
            embed.url   = duck_results[1]
        end
        msg.react CROSS_MARK
        message = msg
        Bot::BOT.add_await(:"edit_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_MARK) do |reaction_event|
            next true unless reaction_event.message.id == message.id
            puts "YUP"
            puts index
            #message.edit(new_embed: new_emb)
            end
        end
    end
end

