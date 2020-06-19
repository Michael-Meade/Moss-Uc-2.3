class Utils
	def self.read_file(file_name)
		file_name = File.join(__dir__, "bashbunny", "templates", file_name)
		if File.exist?(file_name)
			File.open(file_name, "r")
		end
	end
	def self.save_output(uid, output)
		file_name = File.join(__dir__, "output", uid + ".txt")
		f = File.open(file_name, "w")
		f.write(output)
		f.close
		file_name
	end
end
