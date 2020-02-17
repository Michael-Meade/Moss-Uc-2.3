require_relative 'crypto/lib/ctf'
require_relative 'crypto/lib/utils'

module Bot::DiscordCommands
  module Ctf
    extend Discordrb::Commands::CommandContainer
    command(:ctf) do |event|
    	crypto = Main.pick_crypto(event.user.id.to_s)
    	event.respond(crypto.to_s)
    end
  end
end