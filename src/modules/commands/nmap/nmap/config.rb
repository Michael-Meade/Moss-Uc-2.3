require 'json'
class Config
	def self.read_config(config_file)
		JSON.parse(File.read(config_file))
	end
end

#a = Config.read_config("config.json")['1']
#puts a