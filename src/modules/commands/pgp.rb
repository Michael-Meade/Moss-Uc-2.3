require_relative 'utils'
require 'openpgp'
require 'httparty'
module Bot::DiscordCommands
  module PGP
    extend Discordrb::Commands::CommandContainer
    command([:publickey],  description:"Upload your public key", usage:".publickey") do |event, public_key|
      pub = HTTParty.get(event.message.attachments[0].url).response.body
      Utils.user_directory(event.user.id.to_s, "publickey.txt", pub, "txt")
    end
    command(:encrypt) do |event|
      
      data = %w(this is some data that should be encrypted using pgp)
      IOStreams::Pgp::Writer.open(File.join("users", event.user.id.to_s, "publickey.txt")) do |output|
        data.each { |word| output.puts(word) }
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
