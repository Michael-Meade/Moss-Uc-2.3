require_relative 'lib'
class BashBunny
	def self.two_template(uid, file_name, matchs=[], msg=[])
		i = 0 
		file_read = File.read(File.join("templates", file_name))
		if matchs.length.to_i >= 1
			msg.each do |m|
				file_read = file_read.gsub(matchs[i].to_s, m[i].to_s)
				i += 1
			end			
		end
		Utils.save_output(uid, file_read)
	end
	def self.template(uid, file_name, matchs, msg)
		final = ""
		File.readlines(file_name).each do |a|
			if a.include?(matchs)
				a = a.gsub(matchs, msg)
			end
			final += a
		end
		Utils.save_output(uid, final)
	end
	def self.uc_login(uid, email)
		template(uid, File.join("templates", "uc-login.txt"), "email@utica.edu", email)
	end
	def self.undercover_bunny(uid, msg)
		template(uid, File.join("templates", "undercover_bunny.txt"), "message", msg)
	end
	def self.wifi_pass(uid)
		read = File.read(File.join("templates", "wifi_pass.txt"))
		file = File.open(File.join("output", uid + ".txt"), "a")
		file.write(read)
		file.close
	end
	def self.mac_reverse_shell(uid, *msg)
		two_template(uid, "Mac_reverse_shell.txt", ["192.168.17.12", "4444"], msg )
	end
	def self.local_dns_poison(uid, *msg)
		two_template(uid, "Local_DNS_Poisoning.txt", ["10.1.1.0", "test.com"], msg )
	end
	def self.mac_info_grabber(uid)
		read = File.read(File.join("templates", "mac_info_grabber.txt"))
		file = File.open(File.join("output", uid, ".txt"), "a")
	    file.write(read)
	    file.close
	end
end


