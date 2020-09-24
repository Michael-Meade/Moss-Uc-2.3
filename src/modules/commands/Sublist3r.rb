require 'open3'
require 'fileutils'
module Bot::DiscordCommands
  module Github
    extend Discordrb::Commands::CommandContainer
    class SubLister
        def initialize domain, user_id
            @domain  = domain
            @user_id = user_id
        end
        def tool_path
            "#{__dir__}/tools/Sublist3r"
        end
        def domain
            @domain
        end
        def user_id
            @user_id
        end
        def user_path
            File.join("users", user_id, domain + ".txt")
        end
        def command
            output, status = Open3.capture2e(
                "#{tool_path}/sublist3r.py",
                "-d", domain,
                "-o", user_path
            )
            puts output
        end
        def basic
            command
        end
    end
    command(:sublister,  description:"sublister", usage:".sublister [domain]") do |event, domain|
        b    = SubLister.new(domain, event.user.id.to_s)
        file = b.command
        file = event.send_file(File.open(b.user_path))
    end
  end
end