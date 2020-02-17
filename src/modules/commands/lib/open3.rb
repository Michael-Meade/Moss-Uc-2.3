require 'open3'
class Commands
	def self.get_output(command)
		stdout, status = Open3.capture2(command)
	end
end