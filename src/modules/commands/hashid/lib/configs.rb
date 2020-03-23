require 'json'
module HashId
	class Config
		def self.read_config
			JSON.parse(File.read("hashes.json"))
		end
	end
end