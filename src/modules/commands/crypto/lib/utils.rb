require "base64"
require_relative 'crypto'
class Utils
	def self.pick_letter(count)
		(0...50).map { ('a'..'z').to_a[rand(26)] }.sample(count.to_i)
	end
	def self.pick_flag(user_id)
		flag = File.readlines("flags/lildickyAll.txt").sample
		# Save the flag
		Points.save_flag(user_id, flag)
		flag
	end
	def self.generate_key
		rand(0000..9999)
	end
	def self.base_64(string)
		Base64.encode64(string)
	end
end