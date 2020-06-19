require 'open3'
module Home
	def self.home
		
		stdout, stderr, status = Open3.capture3("nmap -sn 192.168.1.0/24 ")
		puts stdout
	end
end