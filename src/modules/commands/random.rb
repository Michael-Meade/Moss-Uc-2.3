require 'json'
require 'digest'
require_relative 'utils'
module Bot::DiscordCommands
  module RandomApi
    extend Discordrb::Commands::CommandContainer
    class Random
        def initialize(url = nil)
            @url = url
            FileUtils.mkdir_p(File.join("users", uid))  unless File.exists?(File.join("users", uid))
        end
        def url
            @url
        end
        def add_image

        end
    end
  end
end