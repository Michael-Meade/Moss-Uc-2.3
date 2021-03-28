require 'json'
require 'httparty'
require_relative 'utils'

module Bot::DiscordCommands
  module Stocks
    extend Discordrb::Commands::CommandContainer
    command([:stock], description: "Stock prices", usage:".stocl PEP") do |event, symbol|
     resp =  HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{symbol.strip}&apikey=XLZJ1BYAORGE28UE").response.body
     r  = JSON.parse(resp)
     output = ""
     r["Global Quote"].each do |keys, values|
     	output += "***" + keys.split(".")[1] + "***" + ": " + values.to_s + "\n"
     end
     event.respond(output.to_s)
    end
  end
end
