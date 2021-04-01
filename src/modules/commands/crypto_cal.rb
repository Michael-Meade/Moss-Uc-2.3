require 'bigdecimal'
module Bot::DiscordCommands
  module CryptoCalc
    extend Discordrb::Commands::CommandContainer
      command([:calc], description:"lost / win calc\n profits = (sell / buy) * amount_invested\n\n profits - amount_invested", usage:".calc sell_amount buy_amount amount_invested ") do |event, sell, buy, total|
        # profits = (sell / buy) * amount_invested
        p sell, buy
        profits =  ( BigDecimal(sell) /  BigDecimal(buy) ) * total.to_i
        m       =  profits.to_i - 100
        event.respond(m.to_s)
      end
    end
end
