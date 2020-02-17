


require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  module News
    extend Discordrb::Commands::CommandContainer
    command([:resource], description:"Bunch of resources", usage:".resources") do |event, id|
    	commands = ["crypto\n",
    		"tor\n",
    		"threat\n",
    		"osint\n",
    		"encryption\n",
    		"phish\n",
    		"malware\n",
    		"hardware\n",
    		"blockchain\n",
    		"scanners\n",
    		"web\n",
    		"news\n",
    		"xss\n",
    		"sqltool\n",
    		"sqlinjection\n",
    		"dorks\n",
    		"python\n", 
    		"ruby\n",
    		"honey\n",
    		"ctftools\n",
    		"ctf\n",
    		"csrf\n",
    		"sample\n"]
    	main_link = "https://github.com/UticaCollegeCyberSecurityClub/Resources/blob/master/README.md"
    	if id.nil?
    		event.respond(main_link)
    	elsif id.to_s == "crypto"
    		event.respond("#{main_link}#cryptocurrency--blockchains")
    	elsif id.to_s == "tor"
    		event.respond("#{main_link}#tor")
    	elsif id.to_s == "threat"
    		event.respond("#{main_link}#threat-maps")
    	elsif id.to_s == "osint"
    		event.respond("#{main_link}#osint")
    	elsif id.to_s == "encryption"
    		event.respond("#{main_link}#encryption")
    	elsif id.to_s == "phish"
    		event.respond("#{main_link}#phishing-tools")
    	elsif id.to_s == "malware"
    		event.respond("#{main_link}#malware")
    	elsif id.to_s == "hardware"
    		event.respond("#{main_link}#hardware")
    	elsif id.to_s == "blockchain"
    		event.respond("#{main_link}#blockchain-analysis")
    	elsif id.to_s == "scanners"
    		event.respond("#{main_link}#scanners")
    	elsif id.to_s == "web"
    		event.respond("#{main_link}#web")
    	elsif id.to_s == "news"
    		event.respond("#{main_link}#news-sites")
    	elsif id.to_s == "xss"
    		event.respond("#{main_link}#xss")
    	elsif id.to_s == "sqltool"
    		event.respond("#{main_link}#sql-injection-tools")
    	elsif id.to_s == "sqlinjection"
    		event.respond("#{main_link}#sql-injection")
    	elsif id.to_s == "dorks" || id.to_s == "dork"
    		event.respond("#{main_link}#google-hacking")
    	elsif id.to_s == "python"
    		event.respond("#{main_link}#python")
    	elsif id.to_s == "ruby"
    		event.respond("#{main_link}#ruby")
    	elsif id.to_s == "honey"
    		event.respond("#{main_link}#honey-pots")
    	elsif id.to_s == "ctftools"
    		event.respond("#{main_link}#ctf-tools")
    	elsif id.to_s == "ctf"
    		event.respond("#{main_link}#ctf")
    	elsif id.to_s == "csrf"
    		event.respond("#{main_url}#csrf")
    	elsif id.to_s == "sample" || id.to_s == "samples"
    		event.respond("#{main_url}#malware-samples")
    	else id.to_s == "ls"
    		r = "Use all the following commands with **.resource.**\n Ex: .resource ctf\n"
    		event.respond(r + commands.join)
    	end
    end
  end
end