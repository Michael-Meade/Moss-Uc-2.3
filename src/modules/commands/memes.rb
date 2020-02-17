require 'json'
require_relative 'utils'
require 'httparty'
module Bot::DiscordCommands
  module News
    extend Discordrb::Commands::CommandContainer
    command([:family], description:"Family guy Memes", usage:".family") do |event|
        event.respond(File.readlines("memes/fun/familyguy.txt").sample.to_s)
    end
    command([:community], description:"ommunity Memes", usage:".community") do |event|
        event.respond(File.readlines("memes/fun/community.txt").sample.to_s)
    end
    command([:dogs], description:"dogs", usage:".dogs") do |event|
        event.respond(File.readlines("memes/fun/dogs.txt").sample.to_s)
    end
    command([:goodnight, :gn], description:"Good Night", usage:".gn") do |event|
        event.respond(File.readlines("memes/fun/goodnight.txt").sample.to_s)
    end
    command([:itcrowd], description:"It crowd", usage:".itcrowd") do |event|
        event.respond(File.readlines("memes/fun/itcrowd.txt").sample.to_s)
    end
    command([:johncenta, :john], description:"john", usage:".john") do |event|
        event.respond(File.readlines("memes/fun/itcrowd.txt").sample.to_s)
    end
  end
end