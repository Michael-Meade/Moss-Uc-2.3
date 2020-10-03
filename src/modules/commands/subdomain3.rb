require 'json'
require 'httparty'
require_relative 'lib/gpg'
require_relative 'utils'
module Bot::DiscordCommands
  module SubDomain
    extend Discordrb::Commands::CommandContainer
      command([:subdomain], description: "use subdomain3", usage:".stocl PEP") do |event, site, arg|
        p site
        p arg
        #site = site.join
      	system("cd #{__dir__}/sub_domain3_wrapper/subdomain3; rake sub S='#{site}' --trace")
        if arg.nil?
          puts "NIL"
          file_path = File.join(__dir__, 'sub_domain3_wrapper', 'subdomain3', 'result', site.gsub("https://", "").gsub("http://", ""), site.gsub("https://", "").gsub("http://", "") + '.csv')
          if File.read(file_path).length <= 2000
            puts " <= 2000"
            event.respond(File.read(file_path.to_s))
          else
             puts "SEND"
            event.send_file(File.open(file_path, 'r'))
          end
        elsif arg.to_s == "pgp"
          puts
          file_path = File.join(__dir__, 'sub_domain3_wrapper', 'subdomain3', 'result', site.gsub("https://", "").gsub("http://", ""), site.gsub("https://", "").gsub("http://", "") + '.csv')
          puts File.read(file_path.to_s)
          File.readlines(File.join("users", event.user.id.to_s, "publickey.txt")).each do |line|
          if line.match("User-ID:")
            content = GPG::encrypt(File.read(file_path.to_s), line.split("Comment: User-ID:")[1].strip.to_s).shift
            if content.length <= 2000
              event.respond(content.to_s)
            else
              f = File.open(File.join("users", event.user.id.to_s, "subdomain3.txt"), "w")
              f.write(content)
              f.close
              event.send_file(File.open("users/#{event.user.id.to_s}/subdomain3.txt", 'r'))
            end
          end
        end
      end
    end
  end
end