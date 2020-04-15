require 'json'
require 'httparty'
require_relative 'utils'
module Bot::DiscordCommands
  module SubDomain
    extend Discordrb::Commands::CommandContainer
    puts "YAYYY"
    command([:subdomain], description: "use subdomain3", usage:".stocl PEP") do |event, *site|
    site = site.join

    	system("cd #{__dir__}/sub_domain3_wrapper/subdomain3; rake sub S='#{site}' --trace")
      #sub_domain3_wrapper\subdomain3\result\facebook.com
      file_path = File.join(__dir__, 'sub_domain3_wrapper', 'subdomain3', 'result', site.gsub("https://", "").gsub("http://", ""), site.gsub("https://", "").gsub("http://", "") + '.csv')
        if File.read(file_path).length <= 2000
          event.respond(File.read(file_path.to_s))
        else
          event.send_file(File.open(file_path, 'r'))
        end
    end
  end
end