require 'httparty'
require 'json'
require 'fileutils'

module Bot::DiscordCommands
  module MovieList
  	extend Discordrb::Commands::CommandContainer
		def self.add_movie(uid, movie_name, status=nil)
			if status.nil?
				status = "x"
			end
			# Creates file if does not exist
			if File.read(File.join("users", uid, "movies_list.json")).empty?
				# creates the json value and saves it in the file
				File.open(File.join("users", uid, "movies_list.json"), "a") { |file| file.write({"0" => [movie_name, status, ":|"]}.to_json) }
			else
				read = JSON.parse(File.read(File.join("users", uid, "movies_list.json")))
				last = read.keys.last.to_i
				last += 1
				read[last] = [movie_name, status, ":|".to_s]
				p read
				File.open(File.join("users", uid, "movies_list.json"), "w") { |file| file.write(read.to_json) }
			end
		end
		def self.list_movies(uid)
			output = ""
			read = JSON.parse(File.read(File.join("users", uid, "movies_list.json")))
			read.each do |key, value|
				output += "#{key} ]\s#{value[0]}\s" + self.status_pretty(value[1]) + "\s" + self.status_pretty(value[2]) + "\n"
			end
		 output
		end
		def self.status_switch(status)
			if status.to_s == "x"
				status = "o"
			elsif status.to_s == "o"
				status = "x"
			end
		end
		def self.rating_switch(status)
			if status.to_s == ":)"
				status = ":("
			elsif status.to_s == ":|"
				status = ":("
			elsif status.to_s == ":("
				status = ":)"
			end
		end
		def self.send_embed(event:, title:, fields:, description: nil)
	        event.channel.send_embed do |embed|
	          embed.title       = title
	          embed.description = description
	          fields.each { |field| embed.add_field(name: field[:name], value: field[:value], inline: field[:inline]) }
	        end
	    end
		def self.status_changer(uid, movie_id)
			read = JSON.parse(File.read("users/#{uid}/movies_list.json"))
			read.each do |key, value|
				if key.to_i == movie_id.to_i
					read[movie_id][1] = status_switch(value[1])
				end
			end
		File.open(File.join("users", uid, "movies_list.json"), "w") { |file| file.write(read.to_json) }
		end
		def self.embed_movie(uid)
			h = []
			JSON.parse(File.read("users/#{uid}/movies_list.json")).each do |key ,value|
				h << { name:  key + "] " + value[0], value: status_pretty(value[1]).to_s + "  - " + status_pretty(value[2].to_s)}
			end
		h
		end
		def self.status_pretty(status)
			# x => no 
			# o => yes
			# !! => thumbs up
			# !!! => thumbs down
			status.to_s.gsub("o", ":white_check_mark: ").gsub("x",":x:").gsub("G", ":thumbsup: ").to_s.gsub("B", ":thumbsdown: ").gsub(":|", ":question: ")
		end
	    
	    command(:movie, description:"managae your movie list", usage:".movie ls || .movie status 1 || .movie rate g || b") do |event, item, movie_name, rate|
	    	FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
	    	FileUtils.touch(File.join("users", event.user.id.to_s, "movies_list.json")) unless File.exists?(File.join("users", event.user.id.to_s, "movies_list.json"))
	    	if item.to_s == "add"
	    		if !movie_name.nil?
	    			self.add_movie(event.user.id.to_s, event.message.content.to_s.gsub(".movie add ", "").to_s)
	    		end
	    	elsif item.to_s == "ls"
	    		output = self.list_movies(event.user.id.to_s)
	    		delay = "#{((Time.now - event.timestamp) * 1000).to_i}ms"
	    		fields = embed_movie(event.user.id.to_s)
	    		send_embed(event: event, title: 'Movie List', fields: fields)
	    	elsif item.to_s == "status"
	    		status_changer(event.user.id.to_s, movie_name)
	    	elsif item.to_s == "rate"
	    		if rate == "g" || rate == "b"
	    			read = JSON.parse(File.read("users/#{event.user.id.to_s}/movies_list.json"))
	    			read.each do |key, value|
	    				if key.to_i == movie_name.to_i
	    					if rate.to_s == "g"
	    						read[movie_name][2] = "G"
	    					elsif rate.to_s == "b"
	    						read[movie_name][2] = "B"
	    					end
	    				end
	    			end
	    			File.open(File.join("users", event.user.id.to_s, "movies_list.json"), "w") { |file| file.write(read.to_json) }
	    		end
	    	end
	    end
	end
end