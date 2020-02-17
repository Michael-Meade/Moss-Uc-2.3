module Bot::DiscordEvents
  # This event is processed each time the bot succesfully connects to discord.
  module Ready
    extend Discordrb::EventContainer
    message(starting_with: not!(".")) do |event|
    	puts
    end
  end
end
