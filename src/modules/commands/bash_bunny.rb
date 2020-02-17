# ¯\_(ツ)_/¯
require_relative 'bash_bunny/lib/bash'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module BashBunnyz
    extend Discordrb::Commands::CommandContainer
    
    command(:bash,  description:"Bash Bunny Fun", usage:".bash") do |event, option, *args|
      puts option
		case option.to_s
  		when "uc"
        puts "!!!!"
        if args.length.to_i == 1
          puts ">>>"
          BashBunny.uc_login(args.to_s, event.user.id)
          event.send_file(File.open(File.join("bashbunny", "lib", "output", "test.txt"), 'r'))
        end
		  end
    end
  end
end
