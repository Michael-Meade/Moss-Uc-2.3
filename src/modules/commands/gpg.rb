require_relative 'utils'
require 'httparty'
require_relative 'bitcoins/btc'
require_relative 'lib/main'
require_relative 'lib/gpg'
module Bot::DiscordCommands
  module GPG2
    extend Discordrb::Commands::CommandContainer
    	command([:publickey],  description:"Upload your public key", usage:".publickey") do |event, public_key|
    		pub = HTTParty.get(event.message.attachments[0].url).response.body
    		Utils.user_directory(event.user.id.to_s, "publickey.txt", pub, "txt")
            GPG.import_publickey(File.join("users", event.user.id.to_s, "publickey.txt"))
    	end
    	command(:btcgen, description:"create bitcoin address", usage:".btcgen") do |event|
            File.readlines(File.join("users", event.user.id.to_s, "publickey.txt")).each do |line|
                if line.match("User-ID:")

                    content = GPG::encrypt(BitcoinAddress.discord.to_s, line.split("Comment: User-ID:")[1].strip.to_s).shift
                    f = File.open(File.join("users", event.user.id.to_s, "addy.txt"), "w")
                    f.write(content)
                    f.close
                    puts "::::::::::"
                    event.send_file(File.open(File.join("users", event.user.id.to_s, "addy.txt"), 'r'))
                end
            end
    	end
      command([:findpgp], description:"Get a users key", usage:".findpgp <tag user>") do |event|
        tag = event.user.mention.to_s.gsub("<@", "").gsub(">", "")
        file_path = File.join("users", tag, "publickey.txt")
        if File.read(file_path).length <= 2000
          event.respond(File.read(file_path.to_s))
        else
          event.send_file(File.open(file_path, 'r'))
        end
      end
	end
end
