require_relative 'open3'
class Keys
	def self.list_keys
		Commands.get_output("gpg --list-public-keys")
	end
end