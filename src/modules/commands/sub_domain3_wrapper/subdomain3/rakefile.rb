task :sub do
	site = ENV['S'].to_s
	p site
	puts site.class
	system("python brutedns.py -d #{site} -s high -l 5")
end