require_relative 'utils'
require 'base58'
require 'digest'
require 'securerandom'
require 'uri'
class String
  def ^(key)
      str1 = self.unpack("c*")
      str2 = key.unpack("c*")
      str2 *= str1.length/str2.length + 1
      str1.zip(str2).collect{|c1,c2| c1^c2}.pack("c*")
  end
end
module Bot::DiscordCommands
  module Encode
    extend Discordrb::Commands::CommandContainer
    command(:md5, min_args:1, description:"MD5 encode a string", usage:".md5 <string>") do |event, *value|
      event.respond(Digest::MD5.hexdigest(value.join(" ").to_s).to_s)
    end
    command(:sha1, description:"SHA1 encode a string", usage:".sha1 <string>") do |event, *value|
      event.respond(Digest::SHA1.hexdigest(value.join(" ").to_s).to_s)
    end
    command([:encodebase64, :encode64, :base64], description:"Base64 encode a string", usage:".base64 <string>") do |event, *value|
      event.respond(Base64.encode64(value.join(" ").to_s).to_s)
    end
    command([:decodebase64, :decode64, :unbase64], description:"Base64 decode a string", usage:".decode64 <string>") do |event, value|
      event.respond(Base64.decode64(value).to_s)
    end
    command([:hex, :encodehex], description:"Hex encode a string", usage:".hex <string>") do |event, *value|
      event.respond(value.join(" ").to_s.each_byte.map { |b| b.to_s(16) }.join.to_s)
    end
    command([:unhex, :decodehex], description:"Hex decode a string", usage:".unhex <string>") do |event, value|
      event.respond(value.scan(/../).map { |x| x.hex.chr }.join.to_s)
    end
    command([:binary], description:"Binary encode a string", usage:".binary <string>") do |event, *value|
      value = value.join(" ")
      event.respond(value.unpack("B*").shift.to_s)
    end

    command([:unbinary], description:"Binary decode a string", usage:".unbinary <string>") do |event, *value|
      event.respond([value.join(" ")].pack("B*").to_s)
    end
    command([:bacon], description:"Encode a string with bacon cipher", usage:".bacon <string>") do |event, *value|
      event.respond(value.join(" ").to_s.unpack("B*").first.tr("0", "A").tr("1", "B").to_s)
    end
    command([:unbacon, :debacon], description:"decode a string with bacon cipher", usage:".binary <string>") do |event, value|
      event.respond([value.tr("A", "0").tr("B", "1")].pack("B*").to_s)
    end
    command([:length], description:"Get a length of a string", usage:".length <string>") do |event, value|
      event.respond(value.length.to_s)
    end 
    command(:reverse, description:"Reverse a string", usage:".reverse <string>") do |event, value|
      event.respond(value.reverse!)
    end
    command(:urlencode, description:"URL encode a string", usage:".urlencode <string>") do |event, *value|
      event.respond(URI::parse(value.join(" ").to_s.value).to_s)
    end
    command(:xor,description:"XOR encode a string with key", usage:"xor <string> <key>") do |event, *msg, key|
      key   = key.join(" ").to_s
      msg   = msg.join(" ").to_s
      encrypt = msg ^ key
      puts encrypt ^ key
      event.respond(encrypt.unpack("B*").shift.to_s)
    end
  end
end