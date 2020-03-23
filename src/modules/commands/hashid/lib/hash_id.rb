require_relative 'configs'
module HashId
	class Check
		def self.detect(hash)
			results = []
			HashId::Config.read_config.each do |key, value|
				if  hash.match(key)
					results << value
				end
			end
		puts results
		end
	end
end

HashId::Check.detect("76e987a1848bfc2419bf97045acd856ba2bdd7d80ddd5e6ebf549ad8e44e0028")