s = ""
File.readlines("lyrics2.0.txt").each do |line|
	if (!line.include?("[") || !line.include?("]"))
		s += line
	end
end

File.open("lyrics2.1.txt", 'a') { |f| f.write(s) }