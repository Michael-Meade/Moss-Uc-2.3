require 'open3'
require_relative 'config'
class Nmap
	def self.get_output(ip, command, uid)
		stdout, status = Open3.capture2("nmap #{ip}  #{command} -oN #{uid}")
	end
	def self.get_commands(ip, input, uid)
		command = Config.read_config("config.json")["#{input}"][0]
		self.get_output(ip, command, uid)
	end
	def self.list_commands
		list  = ""
		count = 1
		Config.read_config("config.json").each do |c|
			list += "#{count}] #{c[1][1]}\n"
			count +=1
		end
	list
	end
end

#Nmap.tcp_syn("utica.edu", "lol2.txt")
#Nmap.get_commands("utica.edu", "5", "mike666666666.txt")
#puts 