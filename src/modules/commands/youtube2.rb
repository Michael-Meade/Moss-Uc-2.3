require_relative 'utils'
require 'httparty'
require 'json'
module Bot::DiscordCommands
  module Youtube
    extend Discordrb::Commands::CommandContainer
    def self.get_youtube_title(value)
      t = HTTParty.get("https://www.youtube.com/oembed?url=#{value}&format=json")["title"]
      #{t => value}.to_json
      t + " " + value
    end
    def self.create_list(file_name)
      output = ""
      JSON.parse(File.read(file_name)).each do |key, value|
        output += "**"+ key.to_s + "]** #{value.gsub("https://", "<https://")}>\n"
      end
      output
    end
    def self.create_list2(file_name)
      count = 0
      list  = ""
      File.readlines(file_name).each do |line|
        line =  line.gsub("https://", "<https://")
        list += "#{count.to_s}] " + "#{line.to_s}>"
        count += 1
      end
      list
    end
    command(:add, min_args:1, description:"add a link yo your playlist", usage:".add <song url>") do |event, *value|
      value = value.join(" ").to_s
      uid = event.user.id.to_s
      string = get_youtube_title(value)
       FileUtils.touch(File.join("users", uid, "playlist.json")) unless File.exists?(File.join("users", uid, "playlist.json"))
      if File.read(File.join("users", uid, "playlist.json")).empty?
        # creates the json value and saves it in the file
        File.open(File.join("users", uid, "playlist.json"), "a") { |file| file.write({"0" => string }.to_json) }
      else
        read = JSON.parse(File.read(File.join("users", uid, "playlist.json")))
        last = read.keys.last.to_i
        last += 1
        read[last] = string
        File.open(File.join("users", uid, "playlist.json"), "w") { |file| file.write(read.to_json) }
      end
    end
    command(:playlist, description:"List your playlist.", usage:".playlist") do |event|
      # create list
      playlist = create_list(File.join("users", "#{event.user.id}", "playlist.json"))
      event.respond(playlist.to_s)
    end
  end
end