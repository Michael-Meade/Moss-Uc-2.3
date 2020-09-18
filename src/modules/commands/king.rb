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
       rsp = HTTParty.get("http://localhost:4567/api/#{path}",
        {
          headers: user_agent,
          debug_output: STDOUT, 
        })
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
        koh_httparty("cron_status")
      elsif id.to_s == "stop"
        koh_httparty("cron_stop")
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
      resp = HTTParty.get("http://localhost:4567/birds_are_not_real.html").response.body
      event.respond(resp)
    end
    command(:lb, description:"Get the leaderboard for king of the hill") do |event|
      output = ""
      resp = HTTParty.get("http://localhost:4567/api/lb")
      parsed = JSON.parse(resp)
      space = "   " * 2 
      parsed.keys.each do |l|
        output += "#{l}] #{space} #{parsed[l][0]} #{space} #{parsed[l][1]}\n"
      end
    output
    end
    command(:weed, description:"classfied", usage:".weed word") do |event, strain, num|
      if num.nil?
        num = 0
      end
      strain = strain.to_s.split(" ")
      g = HTTParty.get("https://cannasos.com/api/search?page=1&search=#{strain}&type=strain")
      strain_id = g.parsed_response[num]
      event.respond("https://render.cannasos.com/api/strain/#{strain_id['_id'].to_s}/#{strain.shift}.jpeg?format=jpeg")
      event.respond("https://render.cannasos.com/api/strain/#{strain_id.to_s}/#{strain.shift}.jpeg?format=jpeg")
    end
    command([:w, :weather], description:"Get Current news.", usage:".news <idea>") do |event, zip|
      response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?zip=" + zip + ",us&appid=3e029d9d2895ddf14349dbaf24cc0851&units=imperial")
      id =  response.parsed_response
      if id["cod"] == "404"
        "Zip code doesnt exist"
      else
          event.respond("***Main:*** #{id['weather'][0]['main']} \n ***Description:*** #{id['weather'][0]['description']} \n ***Temp:*** #{id['main']['temp']} \n ***Humidity:*** #{id['main']['humidity']} \n ***Temp Min:*** #{id['main']['temp_min']} \n ***Temp Max:*** #{id['main']['temp_max']}".to_s)
      end
    end
  end
end
