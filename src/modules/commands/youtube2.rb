require_relative 'utils'
require 'httparty'
require 'json'
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Youtube
    extend Discordrb::Commands::CommandContainer
    def self.get_youtube_title(value)
      t = HTTParty.get("https://www.youtube.com/oembed?url=#{value}&format=json")["title"]
      #{t => value}.to_json
      t + " " + value
    end
    def self.create_list(file_name)
      list  = ""
      count = 0
      Utils.read_list(file_name).each do |key, value|
        puts key
        puts value
        list += "#{count.to_s}] #{key} <#{value}>\n"
        count +=1
      end
      return list
    end
    def self.create_list2(file_name)
      count = 0
      list  = ""
      File.readlines(file_name).each do |line|
        line =  line.gsub("https://", "<https://")
        list += "#{count.to_s}] " + "#{line.to_s}>"
        #.gsub('"', "").gsub("]", "").gsub("[", "")
        count += 1
      end
      list
    end
    command(:add, min_args:1, description:"add a link yo your playlist", usage:".add <song url>") do |event, *value|
      value = value.join(" ").to_s
      # create dir if doesnt exist
      string = get_youtube_title(value)
      Utils.user_directory(event.user.id.to_s, "playlist.txt", string, "txt")
      #Utils.create_file("playlist", "#{event.user.id}.json", string)
    end
    command(:playlist, description:"List your playlist.", usage:".playlist") do |event|
      # create list
      playlist = create_list2(File.join("users", "#{event.user.id}", "playlist.txt"))
      #.shift

      event.respond(playlist.to_s)
    end
  end
end