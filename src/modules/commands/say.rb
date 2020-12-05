module Bot::DiscordCommands
  module  Say
    extend Discordrb::Commands::CommandContainer
    command :say do |event|
      msg = event.message.content.gsub(".say ", "")
      event.respond(msg)
    end
  end
end
