require 'json'
require_relative 'utils'
module Bot::DiscordCommands
  module SubDomain
    extend Discordrb::Commands::CommandContainer
    class DirSearch
        def initialize domain, user_id
            @domain  = domain
            @user_id = user_id
        end
        def tool_path
            "#{__dir__}/tools/dirsearch"
        end
        def domain
            @domain
        end
        def user_id
            @user_id
        end
        def user_path
            FileUtils.mkdir_p File.join("users", user_id, "dirsearch", domain)
            usr = File.join("users", user_id, "dirsearch", "#{domain.strip}.json")
            # File.join("users", user_id, domain + ".txt")
        end
        def command
          output, status = Open3.capture2e("python3 #{tool_path}/dirsearch.py -u #{domain} --plain-text-report=#{user_path} -w #{tool_path}/db/dicc.txt -E php, js, txt, php, html ")
          puts output
        end
        def basic
            command
        end
    end
    command(:dirsearch,  description:"dirsearch\n https://github.com/maurosoria/dirsearch", usage:".dirsearch [domain]") do |event, domain|
        b    = DirSearch.new(domain, event.user.id.to_s)
        file = b.command
        file = event.send_file(File.open(b.user_path))
    end
  end
end