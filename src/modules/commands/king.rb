require 'httparty'
require "json"
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module King
    def self.read_api_key
      # this key is used to validatite that the server ( legit server ) is issuing the command. Should be changed
      # every time
      # 
      JSON.parse(File.read("config.json"))["api-key"]
    end
    extend Discordrb::Commands::CommandContainer
    command(:cron) do |event|
      rsp = HTTParty.get("http://139.59.211.245:4567/clean_cron",
      {
        headers: {"User-Agent" => Digest::SHA1.hexdigest(read_api_key)},
        debug_output: STDOUT, # To show that User-Agent is Httparty
      })
    end
    command(:king, description:"Get the current king") do |event|
      resp = HTTParty.get("http://159.65.216.57/birds_are_not_real.html").response.body
      event.respond(resp)
    end
    command(:lb, description:"Get the leaderboard for king of the hill") do |event|
      output = ""
      resp = HTTParty.get("http://139.59.211.245:4567/api/lb")
      parsed = JSON.parse(resp)
      parsed.keys.each do |l|
        output += "#{l}]---#{parsed[l][0]}---#{parsed[l][1]}\n"
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
