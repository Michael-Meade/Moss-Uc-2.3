class Utils
	def self.read_file(file_name)
		file_name = File.join("bashbunny", "templates", file_name)
		if File.exist?(file_name)
			File.open(file_name, "r")
		end
	end
	def self.save_output(uid, output)
		file_name = File.join("output", uid + ".txt")
		f = File.open(file_name, "w")
		f.write(output)
		f.close
		file_name
	end
end
