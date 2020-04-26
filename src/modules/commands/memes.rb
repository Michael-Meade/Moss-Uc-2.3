require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  module News
    extend Discordrb::Commands::CommandContainer
    command([:bugbounty, :bug], description: "Get bug bounty snipets", usage: ".bug") do |event|
        if event.message.attachments[0].nil?
            event.respond(File.readlines("memes/bugbounty/bugbounty.txt").sample.to_s)
        else
            f = File.open("memes/bugbounty/bugbounty.txt", "a")
            f.write(event.message.attachments[0].url.to_s + "\n")
            f.close
        end
    end
    command([:family], description:"Family guy Memes", usage:".family") do |event|
        event.respond(File.readlines("memes/fun/familyguy.txt").sample.to_s)
    end
    command([:community], description:"Community Memes", usage:".community") do |event|
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
        event.respond(File.readlines("memes/fun/johncenta.txt").sample.to_s)
    end
    command([:tpb], description:"Trailer Park Boys", usage:".tpb") do |event|
        event.respond(File.readlines("memes/fun/tpb.txt").sample.to_s)
    end
    command([:sunny], description:"Sunny In Philly", usage:".sunny") do |event|
        event.respond(File.readlines("memes/fun/sunny.txt").sample.to_s)
    end
    command([:office], description:"The Office", usage:".office") do |event|
        event.respond(File.readlines("memes/fun/office.txt").sample.to_s)
    end
  end
end