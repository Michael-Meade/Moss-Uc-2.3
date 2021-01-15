require 'httparty'
require 'json'
require 'fileutils'
require 'core_extensions'
require_relative  'utils'
module Bot::DiscordCommands
  module ShopList
  	extend Discordrb::Commands::CommandContainer
  	CROSS_MARK = "\u274c"
  		# @param uid [String] the users UID
  		# @param item [String] the item to addd to the todo list
  		# @param [optional, types, ...] status = nil
		def self.add_item(uid, item, status=nil)
			if status.nil?
				status = "x"
			end
			# Creates file if does not exist
			if File.read(File.join("users", uid, "shopping_list.json")).empty?
				# creates the json value and saves it in the file
				File.open(File.join("users", uid, "shopping_list.json"), "a") { |file| file.write({"0" => [item, status]}.to_json) }
			else
				read = JSON.parse(File.read(File.join("users", uid, "shopping_list.json")))
				last = read.keys.last.to_i
				last += 1
				read[last] = [item, status]
				File.open(File.join("users", uid, "shopping_list.json"), "w") { |file| file.write(read.to_json) }
			end
		end
		# @param uid [String] the users UID
		def self.list_shop(uid)
			output = ""
			read = JSON.parse(File.read(File.join("users", uid, "shopping_list.json")))
			read.each do |key, value|
				output += "#{key} ]\s#{value[0]}\s-" + self.status_pretty(value[1]) + "\n"
			end
		 output
		end
		# @param item_delete [String] the item to delete
		# @note Deletes item from todo list
		def self.delete_item(item_delete, user_id)
			r = File.read(File.join("users", user_id, "shopping_list.json"))
			json = JSON.parse(r)
			j.delete("subject_id")
		end
		def self.recount(array, uid)
			i = 0
			array.to_a.each do |l|
	    		l[0] = i.to_s
	    		i += 1
	    	end
	    	File.open(File.join("users", uid, "shopping_list.json"), "w") { |file| file.write(array.to_h.to_json) }
		end
		# @note changes the status.
		def self.status_switch(status)
			if status.to_s == "x"
				status = "o"
			elsif status.to_s == "o"
				status = "x"
			end
		end
		# @param uid [String] the users UID
		# @param item_num [Intger] item number
		def self.status_changer(uid, item_num)
			read = JSON.parse(File.read("users/#{uid}/shopping_list.json"))
			read.each do |key, value|
				if key.to_i == item_num.to_i

					read[item_num][1] = status_switch(value[1])
				end
			end
		File.open(File.join("users", uid, "shopping_list.json"), "w") { |file| file.write(read.to_json) }
		end
		# @note Changes the status to a check mark. 
		def self.status_pretty(status)
			# x => no 
			# o => yes
			status.gsub("o", ":white_check_mark: ").gsub("x",":x:")
		end
	    
	    command(:shop, description:"managae shop list", usage:".shop add item\n.shop ls") do |event, item, item_num|
	    	FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
	    	FileUtils.touch(File.join("users", event.user.id.to_s, "shopping_list.json")) unless File.exists?(File.join("users", event.user.id.to_s, "shopping_list.json"))
	    	if item.to_s == "add"
	    		if !item.nil?
	    			self.add_item(event.user.id.to_s, event.message.content.to_s.gsub(".shop add ", "").to_s)
	    		end
	    	elsif item.to_s == "ls"
	    		output = list_shop(event.user.id.to_s).to_s
	    		p output
	    		message = event.respond(output.to_s)
	    		message.react CROSS_MARK
	    		Bot::BOT.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_MARK) do |reaction_event|
	    			next true unless reaction_event.message.id == message.id
	    			message.delete
	    			nil
	    		end
	    		nil
	    	elsif (item.to_s == "e" || item.to_s == "export")
	    		if item_num.nil?
	    			event.send_file(File.open(File.join("users", event.user.id.to_s, "shopping_list.json")))
	    		elsif item_num == "e"
	    			out = Utils.gpg_encrypt(event.user.id.to_s, File.join("users", event.user.id.to_s, "shopping_list.json"))
	    			event.respond("#{out[0]}")
	    		end
	    	elsif item.to_s == "status"
	    		status_changer(event.user.id.to_s, item_num)
	    	elsif item.to_s == "dl"
	    		 event.send_file(File.open(File.join("users", event.user.id.to_s, "shopping_list.json")))
	    	elsif item.to_s == "rm"
	    		i = 0
	    		if item_num.include?(",")
	    			file = JSON.parse(File.read("users/#{event.user.id.to_s}/shopping_list.json"))
	    			item_num.split(",").each do |line|
	    				file.delete(line)
	    			end
	    			file.to_a.each do |l|
	    				l[0] = i.to_s
	    				i+=1
	    			end
	    			recount(file, event.user.id.to_s)
	    			#File.open(File.join("users", event.user.id.to_s, "shopping_list.json"), "w") { |file| file.write(file.to_h.to_json) }
	    		end
	    		i = 0
	    		msg =  event.message.content
	    		file = JSON.parse(File.read("users/#{event.user.id.to_s}/shopping_list.json"))
	    		file.delete(item_num)
	    		array = file.to_a
	    		array.each do |l|
	    			l[0] = i.to_s
	    			i += 1
	    		end	    
	    		recount(array, event.user.id.to_s)
	    		#File.open(File.join("users", event.user.id.to_s, "shopping_list.json"), "w") { |file| file.write(array.to_h.to_json) }
	    	end
	    end
	end
end