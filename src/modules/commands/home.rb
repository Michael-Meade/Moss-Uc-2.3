require 'json'
require 'date'
require_relative 'home/test'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Home2
    extend Discordrb::Commands::CommandContainer
    command(:home, description:"whos home", usage:".home") do |event|
      Home.home
      r = File.read("#{__dir__}/home/targets.json")
      l = JSON.parse(r)
      list = ""
      i    = 0
      l.each do |key, value|
        if File.read("home/scan2.txt").include?(value)
          list += i.to_s + "] #{value}\n"
        end
      end
      p list
    end
  end
end
