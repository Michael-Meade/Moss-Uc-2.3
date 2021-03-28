module Bot::DiscordCommands
  module Decide
    extend Discordrb::Commands::CommandContainer
    command(:decide, description:"decide", usage:".decide should I eat MacDonalds") do |event, *value|
      r = ["yes", "no"]
      event.respond(r.sample)
    end
  end
end