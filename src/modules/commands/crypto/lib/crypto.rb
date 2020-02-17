require_relative 'utils'
require "base32"
class Crypto
	def self.bacon(user_id)
		# Get the two letters
		letters = Utils.pick_letter(2)
		# pick the flag
		flag    = Utils.pick_flag(user_id)
		flag.unpack("B*").first.tr("0", letters[0]).tr("1", letters[1])
	end
	def self.hex(user_id)
		# pick flag
		flag = Utils.pick_flag(user_id)
		flag.each_byte.map { |b| b.to_s(16) }.join
	end
	def self.xor_1(user_id)
		# generate key
		key = Utils.generate_key
		flag    = Utils.pick_flag(user_id)
		# base64 so discord wont mess up format
		Utils.base_64(flag.split(//).collect {|e| [e.unpack('C').first ^ (key.to_i & 0xFF)].pack('C') }.join.to_s)
	end
	def self.base32(user_id)
		flag = Utils.pick_flag(user_id)
		Base32.encode(flag)
	end
	def self.ceaser_cipher(user_id)
		# pick shift
		shift = rand(1..30)
		flag  = Utils.pick_flag(user_id)
		encrypter = ([*('a'..'z')].zip([*('a'..'z')].rotate(shift)) + [*('A'..'Z')].zip([*('A'..'Z')].rotate(shift))).to_h
		flag.chars.map { |c| encrypter.fetch(c, c) }.join
	end
end