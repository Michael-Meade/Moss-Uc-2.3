module Bot::DiscordCommands
  module LMGTFY
    extend Discordrb::Commands::CommandContainer
    
    command(:lmgtfy) do |event, *args|
    	event.respond("https://lmgtfy.app/?q=#{args.join("+")}")
    end
  end
end