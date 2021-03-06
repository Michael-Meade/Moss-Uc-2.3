require 'httparty'
require "json"
module Bot::DiscordCommands
  module King
    def self.read_api_key
      JSON.parse(File.read("config.json"))["api-key"]
    end
    extend Discordrb::Commands::CommandContainer
    def self.user_agent
      {"User-Agent" => Digest::SHA1.hexdigest(read_api_key)}
    end
    def self.koh_httparty(path)
      # todo: add domain config
       rsp = HTTParty.get("http://127.0.0.1/api/#{path}",
        {
          headers: user_agent,
          debug_output: STDOUT, 
        }).response.body
    end
    def self.pretty_status(rsp)
      if rsp.to_s == "true"
        "Sign up status: :white_check_mark: "
      elsif rsp.to_s == "false"
        "Sign up status: :x:"
      end
    end
    command(:cron) do |event, id|
      if id.to_s == "clean"
        koh_httparty("clean_cron")
      elsif id.to_s == "status"
        event.respond(koh_httparty("cron_status").to_s)
      elsif id.to_s == "stop"
        koh_httparty("cron_stop")
      elsif id.to_s == "start"
        koh_httparty("cron_start")
      end
    end
    command(:signup, description: "used to turn on and off the sign up page") do |event, id|
      rsp = koh_httparty("signup_status").body
      if (id.to_s == "status" || id.to_s == "s")
         event.respond(pretty_status(rsp).to_s)
      elsif (id.to_s == "enable" || id.to_s == "e")
        koh_httparty("enable_signup")
      elsif (id.to_s == "disable" || id.to_s == "d")
        koh_httparty("disable_signup")
      end
    end
    command(:king, description:"Get the current king") do |event|
      resp = HTTParty.get("http://159.65.216.57").response.body
      event.respond(resp)
    end
    command(:lb, description:"Get the leaderboard for king of the hill") do |event|
      output = ""
      resp = HTTParty.get("http://139.59.211.245/api/lb")
      parsed = JSON.parse(resp)
      space = "   " * 2 
      parsed.keys.each do |l|
        output += "#{l}] #{space} #{parsed[l][0]} #{space} #{parsed[l][1]}\n"
      end
    output
    end
  end
end
