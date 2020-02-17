require_relative 'crypto'
class Main
	def self.id(id, user_id)
		case id
		when 1
			Crypto.bacon(user_id)
		when 2
			Crypto.hex(user_id)
		when 3
			Crypto.xor_1(user_id)
		when 4
			Crypto.ceaser_cipher(user_id)
		when 5
			Crypto.base32(user_id)
		end
	end
	def self.pick_crypto(user_id)
		# pick random 
		Main.id(rand(1..5), user_id)
	end
end