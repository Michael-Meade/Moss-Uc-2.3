require 'fileutils'
require 'json'
class Points
	def self.save_flag(user_id, flag)
		file_name = File.join("./users", user_id + ".json")
		if not File.exists?(file_name)
			FileUtils.touch(file_name)
		end
		f = File.open(file_name, "a")
		f.write(flag)
		f.close
	end
	def self.check_flag(user_id, input)
		file_name = File.join("./users", user_id + ".json")
		file.readlines(file_name).each do |flags|
			if flag == input
				read = File.read(file_name).gsub(input, "")
				f = File.open(file_name, "w")
				f << read
				f.close
				return "Yo u got it."
			else
				return "Sorry. No cigar."
			end
		end
	end
end