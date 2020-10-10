require 'httparty'
require 'json'
require 'fileutils'
require 'time'

module Bot::DiscordCommands
  module MovieList
  	extend Discordrb::Commands::CommandContainer
  	class Movie
  		VERSION = 2
			def initialize(uid, movie_name = nil, date = nil)
				@uid = uid
				@movie_name = movie_name
				user_profile_setup
				@date = date 
			end
			def uid
				@uid
			end
			def movie_name
				@movie_name
			end
			def user_movie_path
				File.join("users", uid, "movies_list.json")
			end
			def date
				@date
			end
			def user_profile_setup
				FileUtils.mkdir_p(File.join("users", uid))
				if not File.file?(user_movie_path)
					File.open(user_movie_path, "w") {|f| f.write("{}") }
				end
			end
			def add_movie
				if !movie_name.nil?
					# read the movie_list.json file
					read = File.read(user_movie_path)
					# Check to see if its empty
					if read.to_s == "{}"
						json = JSON.parse(read)
						# add the movie to the list
						json["0"] = [movie_name, "not_seen", "not_rated"]
					else
						json = JSON.parse(File.read(user_movie_path))
						# get last id
						last = json.keys.last.to_i
						# add one to the id
						last += 1
						json[last] = [movie_name, "not_seen", "not_rated"]
					end
					File.open(user_movie_path, "w") { |file| file.write(json.to_json) }
				end
			end
			def status_switch(status)
				if status.to_s == "not_seen"
					status = "seen"
				elsif status.to_s == "seen"
					status = "not_seen"
				end
			end
			def rating_switch(rate)
				case rate
				when "good"
					"rating_good"
				when "bad"
					"rating_bad"
				when "okay"
					"rating_okay"
				else 
					"rating_neutral"
				end
			end
			def date(movie_id, date = nil)
				# Add the watch date to the users movie_list.json.
				# if date == nil then it will get todays date.
				# Assumes that the third element in the array is the date
				t = Time.new
				if date.nil? 
					date = "#{t.month}/#{t.day}/#{t.year}"
				end
				read = JSON.parse(File.read(user_movie_path))
				read.each do |key, value|
					if key.to_i == movie_id.to_i
						read[movie_id][3] = date
					end
				end
			File.open(File.join("users", uid, "movies_list.json"), "w") { |file| file.write(read.to_json) }
			end
			def embed_movie
				# The final output  that is sent to the user. 
				h = []
				JSON.parse(File.read(user_movie_path)).each do |key ,value|
					h << { name:  key + "] " + value[0], value: pretty(value[1]).to_s + "  - " + pretty(value[2].to_s) + " - #{pretty(value[3])}"}
				end
			h
			end
			def pretty(status)
				status.to_s.gsub(/^seen$/, ":eye:  ").gsub(/^not_seen$/, ":x: ").gsub(/^rating_good$/, ":thumbsup: ").gsub(/^rating_bad$/, ":thumbsdown: ").gsub(/^not_rated$/, ":x:").gsub(/^rating_neutral$/, ":question: ")
			end
			def rating_changer(movie_id, rate)
				# Should only accept rate as:
				# - good
				# - bad
				# - okay
				# If it does not match any of those it wil set as neutral
				read = JSON.parse(File.read(user_movie_path))
				read.each do |key, value|
					if key.to_i == movie_id.to_i
						read[movie_id][2] = rating_switch(rate)
					end
				end
				File.open(File.join("users", uid, "movies_list.json"), "w") { |file| file.write(read.to_json) }
			end
			# @params movie id
			def status_changer(movie_id)
				read = JSON.parse(File.read(user_movie_path))
				read.each do |key, value|
					if key.to_i == movie_id.to_i
						read[movie_id][1] = status_switch(value[1])
					end
				end
				File.open(File.join("users", uid, "movies_list.json"), "w") { |file| file.write(read.to_json) }
			end
		end
		def self.send_embed(event:, title:, fields:, description: nil)
	        event.channel.send_embed do |embed|
	          embed.title       = title
	          embed.description = description
	          fields.each { |field| embed.add_field(name: field[:name], value: field[:value], inline: field[:inline]) }
	        end
	    end
	    command(:movie, description:"managae your movie list.\n**Status**: seen the movie or not\n **Rate**: rate it\n", usage:".movie ls\n.movie status 1 \n.movie rate 8 <good OR bad OR okay>\n. Date:  .movie date 1 OR .movie date 1 09/11/2020.\nNOTE: if not supploed a date (.movie date 1) it will use today's date. ") do |event, item, movie_name, rate|
	    	# ITEM => add, ls, status, rate, date
	    	CROSS_MARK = "\u274c"
	    	#FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
	    	#FileUtils.touch(File.join("users", event.user.id.to_s, "movies_list.json")) unless File.exists?(File.join("users", event.user.id.to_s, "movies_list.json"))
	    	#movie_name = event.message.content.to_s.gsub(".movie add ", "").to_s
	    	movie = Movie.new(event.user.id.to_s, movie_name)

	    	if item.to_s == "add"
	    		if !movie_name.nil?
	    			# adds movie to list if not nil.
	    			movie.add_movie
	    		end
	    	elsif item.to_s == "ls"
	    		fields  = movie.embed_movie
	    		message = send_embed(event: event, title: 'Movie List', fields: fields)
	    		message.react CROSS_MARK
	    		Bot::BOT.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_MARK) do |reaction_event|
	    			next true unless reaction_event.message.id == message.id
	    			message.delete
	    		end
	    		nil
	    	elsif item.to_s == "status"
	    		movie.status_changer(movie_name)
	    	elsif item.to_s == "rate"
	    		movie.rating_changer(movie_name, rate)
	    	elsif item.to_s == "date"
	    		# rating = date
	    		movie.date(movie_name, rate)
	    	end
	    end
	end
end