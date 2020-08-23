task :sub do
	site = ENV['S'].to_s
	system("python3 brutedns.py -d #{site} -s high -l 5")
end