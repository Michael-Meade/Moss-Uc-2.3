require_relative 'utils'
require 'httparty'
require 'json'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Youtube
    extend Discordrb::Commands::CommandContainer
    command(:afbi, description:"<classfied>", usage:"<classfied>") do |event, status|
      channel_id = event.channel.id
      if !File.read("afbi_bl.txt").include?(channel_id)
        if status.nil?
          r = HTTParty.get("http://theafbi.com/afbi/1").response.body
          results = JSON.parse(r)["afbi"]
          event.respond(results[0])
        elsif status == "add bl" || status == "add"
          if !File.read("afbi_bl.txt").include?(channel_id)
            puts "ssss"
            f = File.open("afbi_bl.txt", "a")
            f.write(channel_id)
            f.close
          end
        elsif status == "rm bl" ||  status == "rm"
          read = File.read("afbi_bl.txt")
          if File.read("afbi_bl.txt").include?(channel_id)
            puts "Y"
          end
        end
      end
    end
    command(:subcount, description: "get sub amount for afbi", usage:".subcount") do |event|
      r = HTTParty.get("http://theafbi.com").response.body
      results = JSON.parse(r)["sub_count"]
      event.respond("**Current Subcount: ** #{results}")
    end
  end
end