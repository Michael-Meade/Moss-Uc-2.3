require_relative 'utils'
require 'httparty'
require_relative 'bitcoins/btc'
require_relative 'lib/main'
require_relative 'lib/gpg'
require_relative 'utils'
require "open3"
module Bot::DiscordCommands
  module GPG2
    extend Discordrb::Commands::CommandContainer
        command(:encrypt, description:"encrypt message", usage: ".encrypt hi, im dave") do |event, msg|
            output, status = Open3.capture2e(
                "gpg",
                "--with-fingerprint", File.join("users", event.user.id.to_s, "publickey.txt"),
            )
            id = output.split("=")[1].split("\n")[0]
            output, status = Open3.capture2e(
                'echo '"#{msg}"' | gpg  --always-trust -ear  ' + "'#{id}'"
            )
            event.respond(output)
        end
        # @note updates the users publickey. assumes there is one on the user file
        command(:updategpg) do |event|
            dir_path = File.join("users", event.user.id.to_s, "publickey.txt")
            output, status = Open3.capture2e(
                "gpg --import #{dir_path}"
            )
        end
        command(:etest) do |event|
            # ENCRYPT TEST
            loo = Utils.gpg_encrypt(event.user.id.to_s, "OOOOOOOOOOOOOOO")
            event.respond("#{loo[0]}")
        end
    	command([:publickey],  description:"Upload your public key", usage:".publickey <upload public key>") do |event, public_key|
    		pub = HTTParty.get(event.message.attachments[0].url).response.body
    		Utils.user_directory(event.user.id.to_s, "publickey.txt", pub, "txt")
            GPG.import_publickey(File.join("users", event.user.id.to_s, "publickey.txt"))
    	end
    	command(:btcgen, description:"create bitcoin address", usage:".btcgen || .btcgen w") do |event, status|
            if !File.exist?(File.join("users", event.user.id.to_s, "publickey.txt"))
                event.respond(BitcoinAddress.discord.to_s)
            else
                File.readlines(File.join("users", event.user.id.to_s, "publickey.txt")).each do |line|
                    if status.nil?
                        count = 0
                        if line.match("User-ID:")
                            content = GPG::encrypt(BitcoinAddress.discord.to_s, line.split("Comment: User-ID:")[1].strip.to_s).shift
                            #File.open(File.join("users", event.user.id.to_s, "addy.txt"), "w") {|f| f.write(content) }
                            event.respond(content.to_s)
                            #event.send_file(File.open("users/#{event.user.id.to_s}/addy.txt", 'r'))
                        end
                        #event.respond("use .plublickey ( send your public key )  OR .btcgen w ( This will not be encryped with your public key. meaning it could be intercepted by a third party.).... \n Download: https://gnupg.org/download/index.html\n\n https://github.com/UticaCollegeCyberSecurityClub/LinuxGuide#gpg ( first bullet point ) \n ")
                    elsif status.to_i == "w"
                        event.respond(BitcoinAddress.discord.to_s)
                    else
                        event.user.pm(BitcoinAddress.discord.to_s)
                    end
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
