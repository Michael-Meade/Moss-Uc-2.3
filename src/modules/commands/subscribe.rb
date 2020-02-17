require_relative 'utils'
require 'httparty'
module Bot::DiscordCommands
  module Subscribe
    extend Discordrb::Commands::CommandContainer
    command([:lssub],  description:"List your subscripton", usage:".lssub") do |event|
      list  = ""
      count = 0
      File.readlines(File.join("users", event.user.id.to_s, "subs.txt")).each do |line|
        list << "#{count.to_s}] #{line}"
        count += 1
      end
      event.respond(list.to_s)
    end
    list = ""
    command([:addsub], description:"Add to subscripton", usage:".addsub <https://link.com link link>") do |event, *subs|
      subs.each do |s|
        list << s + "\n"
      end
      Utils.user_directory(event.user.id.to_s, "subs.txt", list, "txt")
    end
  end
end
