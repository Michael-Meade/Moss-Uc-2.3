 require 'json'
require 'fileutils'
class Utils
	def self.read_list(file_name)
		list = File.read(file_name)
		JSON.parse(list)
	end
	def self.check_empty?(file_name)
		File.zero?(file_name)
	end
	def self.get_last_key(file)
		read  = File.read(file)
		read2 = JSON.parse(read)
		id = read2.keys.last.to_i
		id +=1
	end
	def self.add_commas(string)
		whole, decimal = string.to_s.split(".")
        whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
        [whole_with_commas, decimal].compact.join(".")
	end
	def self.read_file(file)
		File.open(file, 'r')
	end
	def self.user_directory(uid, file_name, content, arg=nil)
		FileUtils.mkdir_p(File.join("users", uid))  unless File.exists?(File.join("users", uid))
		if arg == nil
			create_file(File.join("users", uid), file_name, content)
		elsif arg.to_s == "png"
			f = File.open(File.join("users", uid, file_name), "w")
			f.write(content)
			f.close
		elsif arg.to_s == "txt"
			f = File.open(File.join("users", uid, file_name), "w")
			f.write(content)
			f.close
		elsif arg.to_s == "json"
			create_file(File.join("users", uid), file_name, content)
		end
	end
	def self.create_dir(dir_name, file_name=nil)
		FileUtils.mkdir_p(dir_name)  unless File.exists?(dir_name)
		if !file_name.nil?
			if  check_empty?(file_name)
				f = File.open(File.join(dir_name, file_name), "a")
				f << "{}"
				f.close
			end
			#FileUtils.touch(File.join(dir_name, file_name))
		end
	end
	def self.create_file(dir_name, file_name, string)
		# define the pathe we want
		dir_path = File.join(dir_name,  file_name)
		Utils.create_dir(dir_name)
    	if File.exists?(dir_path)
    		# get last id from file
			id = Utils.get_last_key(dir_path)
			# read & parse file
	    	current_file = read_list(dir_path)
	    	f = File.open(dir_path, "w")
	    	# add new idea to current file
	    	current_file[id] = string
	    	f.write(current_file.to_json)
	    	f.close
    	else
	    	f = File.open(File.join(dir_name, file_name), "w")
			f.write(JSON.pretty_generate({"0" => string}))
			f.close
	    end
	end
	def self.get_file(dir_name, pick)
		sorts = Dir.glob("#{dir_name}/*").sort
		count = 0
		sorts.each do |a|
			if pick.to_i == count.to_i
				return a
			end
			count += 1
		end
	end
	def self.list_dir(dir_name)
		sorts = Dir.glob("#{dir_name}/*").sort
		array = ""
		count = 0
		sorts.each do |b|
			array += count.to_s + "] " + b.to_s + "\n"
			count += 1
		end
		array
	end
	def self.create_list(file_name)
		i    = 0
		list = ""
		self.read_list(file_name).each do |key, values|
			puts key
			puts values
			list += "#{key}] #{values}\n"
		end
		return list
	end
end