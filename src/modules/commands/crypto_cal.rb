require 'bigdecimal'
require 'bigdecimal'
require 'httparty'
require 'json'
module Bot::DiscordCommands
  module CryptoCalc
    extend Discordrb::Commands::CommandContainer
    class Crypto
        def initialize(current_amount, bought_price, amount)
            @current_amount = current_amount
            @bought_price   = bought_price
            @amount         = amount
        end
        
        def calc
            BigDecimal(@current_amount.to_i - @bought_price.to_i ) * @amount
        end
    end
    class GetPrice
        def initialize(coin_name)
            @coin_name = coin_name
        end
        def price
            r = HTTParty.get("https://min-api.cryptocompare.com/data/price?fsym=#{@coin_name}&tsyms=USD").body
        JSON.parse(r)["USD"]
        end
    end
      command([:calc], description:"lost / win calc\n profits = (sell / buy) * amount_invested\n\n profits - amount_invested", usage:".calc sell_amount buy_amount amount_invested ") do |event, buy, total, coin|
        
        if !coin.nil? 
          coin = coin.upcase 
        else
          coin = "XMR"
        end
        # profits = (sell / buy) * amount_invested
        price = GetPrice.new(coin).price
        out   = Crypto.new(buy.to_i, price.to_i, total.to_i ).calc.to_f
        puts out
        event.respond(out.to_s)
      end
    end
end
