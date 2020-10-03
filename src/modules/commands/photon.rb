require 'open3'
require 'fileutils'
module Bot::DiscordCommands
  module Github
    extend Discordrb::Commands::CommandContainer
    class Photon
        def initialize domain, user_id
            @domain  = domain
            @user_id = user_id

        end
        # @note the path where the tool is located 
        def tool_path
            "#{__dir__}/tools/Photon"
        end
        def domain
            @domain
        end
        def user_id
            @user_id
        end
        # @note Creates a directory in users/UID/photon/example.com
        # @note Uses File.join to create the user path to where the output will  be saved 
        def user_path
            FileUtils.mkdir_p File.join("users", user_id, "photon", domain)
            usr = File.join("users", user_id, "photon", domain)

        end
        # @note The method that will run the command
        def command
            output, status = Open3.capture2e(
                "python3 #{tool_path}/photon.py -u #{domain} -o #{user_path} -e json"
            )
            puts "python3 #{tool_path}/photon.py -u #{domain} -o #{user_path} -e json"
            puts output
        end
        def basic
            command
        end
    end
    command(:photon,  description:"https://github.com/s0md3v/Photon", usage:".photon [domain]") do |event, domain|
        b    = Photon.new(domain, event.user.id.to_s)
        b.basic
        event.send_file(File.open(File.join(b.user_path, "exported.json")))
    end
  end
end