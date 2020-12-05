require 'open3'
require 'fileutils'
module Bot::DiscordCommands
  module Github
    extend Discordrb::Commands::CommandContainer
    class Discord
        def initialize domain, user_id
            @domain  = domain
            @user_id = user_id
            @cmd     = "knockpy "
        end
        def cmd
            @cmd
        end
        def domain
            @domain
        end
        def user_id
            @user_id
        end
        def export
            FileUtils.mkdir_p(File.join("users", user_id, "knock"))  unless File.exists?(File.join("users", user_id, "knock"))
            dest_path = File.join("users", user_id, "knock")
            Dir["#{__dir__}/*"].each do |file|
                if file.split(".")[-1].to_s == "json"
                    FileUtils.mv(file, dest_path)
                return file
                end
            end

        end
        def create_commands
            "#{cmd} -j #{domain} "
        end
        def run_command(command)
            %x( #{command} )
        end
    end
    class Knock < Discord
        def basic
            run_command(create_commands)
            export
        end
    end
    command(:knockpy,  description:"knockpy", usage:".knock [domain]") do |event|
        b    = Knock.new("hulu.com", event.user.id.to_s)
        file = b.basic
        event.send_file(File.open(File.join("users", user_id, "knock", file)))
    end
  end
end