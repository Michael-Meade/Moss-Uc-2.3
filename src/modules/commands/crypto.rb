# :markup: TomDoc
require_relative 'utils'
require 'json'
require 'httparty'
require 'uri'
require 'net/http'
require 'json'
require 'colorize'
require 'satoshi-unit'
module Bot::DiscordCommands
  module Crypto
    extend Discordrb::Commands::CommandContainer
    JJ = {"embeds":[{"title":"Crypto Profile",
		"fields":[{"name":"BTC","value":"\n60.62009960747016"},
			{"name":"USD","value":"30.93\n---------------------------------------------\n\n\n"},
			{"name":"XLM","value":"303.6059025"},
			{"name":"USD","value":"21.1765116993750\n\n---------------------------------------------"},
			{"name":"USD","value":"60.62009960747016"},
			{"name":"XMR","value":"0.6621529176130001\n\n---------------------------------------------"}]}]}.to_json
    # @return [numbeer] / 100000000.0
    def self.convert_satoshi(number)
    	
    	return number.to_f / 100000000.0
    	# @return [optional, types, ...] description
    end
    def self.get_xmr_price
    	JSON.parse(HTTParty.get("https://min-api.cryptocompare.com/data/price?fsym=XMR&tsyms=BTC,USD,XMR").response.body)
    end
    def self.get_xlm_price
    	JSON.parse(HTTParty.get("https://min-api.cryptocompare.com/data/price?fsym=XLM&tsyms=BTC,USD").response.body)
    end
	def self.convert_btc_usd(number)
    	response = Net::HTTP.get_response(URI.parse("https://www.blockchain.com/frombtc?value=#{number.to_s.gsub(".", "")}&currency=USD")).response.body
	end
	def self.bitcoin_address_usd(address)
		response = Net::HTTP.get_response(URI.parse("https://blockchain.info/rawaddr/#{address}"))
    	btc      = JSON.parse(response.body)
	end
	def self.bitcoin_address_btc(address)
	# @param address [String] the BTC Address that will be searched
		response = Net::HTTP.get_response(URI.parse("https://blockchain.info/rawaddr/#{address}"))
    	btc      = JSON.parse(response.body)
	end

	def self.crypto_price(crypto)
		c = crypto.upcase
		response = HTTParty.get("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", params: {'start':'1','limit':'1','convert':'USD,BTC'}, headers: {
			'Accepts': 'application/json',
			'X-CMC_PRO_API_KEY': Utils.read_list("config.json")["X-CMC_PRO_API_KEY"].to_s
		})
		out = response.parsed_response["data"]
		out.each do |keys, value|
			if keys["symbol"].to_s == c
				return keys
				# @return [String]
			end
		end
	end
	def self.crypto_price2(crypto)
		begin
			uri = URI.parse("https://api.coinmarketcap.com/v1/ticker/#{crypto}/")
	        response = Net::HTTP.get_response(uri)
	        data = JSON.parse(response.body)

	        "
	        **Price USD:** #{data[0]['price_usd']}
	        **Price BTC:** #{data[0]['price_btc']}
	        **Percent Change 1 hour:  ** #{data[0]['percent_change_1h']}
	        **Precent Change 24 hours:** #{data[0]['percent_change_24h']}
	        ".gsub("\t        ", "").lstrip
	    rescue => e
	    	"Invaid crytpo currency. Try again."
	    end
	end
	def self.add_coin(uid, coin, amount)
		if File.read(File.join("users", uid, "crypto.json")).empty?
			# creates the json value and saves it in the file
			File.open(File.join("users", uid, "crypto.json"), "a") { |file| file.write({"#{coin}" => amount}.to_json) }
		else
			read = JSON.parse(File.read(File.join("users", uid, "crypto.json")))
			if read.key?(coin)
			    read[coin] +=  amount.to_f
				File.open(File.join("users", uid, "crypto.json"), "w") { |file| file.write(read.to_json ) }
			else 
				read = JSON.parse(File.read(File.join("users", uid, "crypto.json")))
				read[coin] = amount.to_f
				File.open(File.join("users", uid, "crypto.json"), "w") { |file| file.write(read.to_json ) }
			end
		end
	end
	command([:crypto], description:"Get current crypto price.", usage:".crypto <name>\n.crypto p btc\n.crypto ls") do |event, name, coin, amount|
		FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
	    FileUtils.touch(File.join("users", event.user.id.to_s, "crypto.json")) unless File.exists?(File.join("users", event.user.id.to_s, "crypto.json"))
	    if name.to_s == "p" || name.to_s == "profile"
	    	if coin.nil? || name.nil?
	    		event.respond("example: .crypto p btc .1997")
	    	else
	    		add_coin(event.user.id.to_s, coin, amount)
	    	end
	    elsif (name.to_s == "ls" || name.to_s == "l")
	    	usd_total = 0
	    	JSON.parse(File.read(File.join("users", event.user.id.to_s, "crypto.json"))).each do |key, value|
	    		json_out = J
	    		if key.to_s == "btc"
	    			s = Satoshi.new(value)
	    			btc = convert_btc_usd(s.to_i)
	    			event.channel.send_embed do |embed|
	    				embed.title = "BTC Profile" 
	    				embed.colour = 0xdad7e1
	    				embed.add_field(name: "BTC", value: value.to_s, inline: true)
	    				embed.add_field(name: "USD", value: btc.to_s)
	    				usd_total += btc.to_f
	    			end
	    		nil
	    	    elsif key.to_s == "xmr"
	    	    	usd = value.to_f * get_xmr_price["USD"].to_f
	    	    	xmr = value.to_f * get_xmr_price["XMR"].to_f
	    	    	event.channel.send_embed do |embed|
	    				embed.title = "XMR Profile" 
	    				embed.colour = 0xdad7e1
	    				embed.add_field(name: "XMR", value: value.to_s, inline: true)
	    				embed.add_field(name: "USD", value: usd.to_s)
	    				usd_total += usd.to_f
	    			nil
	    			end
	    		elsif key.to_s == "xlm"
	    			usd = value.to_f * get_xlm_price["USD"].to_f
	    	    	xmr = value.to_f * get_xlm_price["XLM"].to_f
	    	    	event.channel.send_embed do |embed|
	    				embed.title = "XLM Profile" 
	    				embed.colour = 0xdad7e1
	    				embed.add_field(name: "XLM", value: value.to_s, inline: true)
	    				embed.add_field(name: "USD", value: usd.to_s)
	    				usd_total += usd.to_f
	    			nil
	    		    end
	    		end
	    	end
	    	if usd_total != 0
	    		event.respond("***Total USD: $*** #{usd_total}")
	    	end
		else
			coin = crypto_price(name)
			event.channel.send_embed("") do |embed|
	          embed.title = coin["name"].to_s
	          embed.colour = 0x5345b3
	          embed.add_field(name: "Price USD",          		value: coin["quote"]["USD"]["price"].to_f.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
	          embed.add_field(name: "Volume 24h",        		value: coin["quote"]["USD"]["volume_24h"].to_f.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
	          embed.add_field(name: "Price Change 1 hour",  	value: coin["quote"]["USD"]["percent_change_1h"].to_s)
	          embed.add_field(name: "Price Change 24 hour",     value: coin["quote"]["USD"]["percent_change_24h"].to_s)
	          embed.add_field(name: "Price Change 7 days",      value: coin["quote"]["USD"]["percent_change_7d"].to_s)
	          embed.add_field(name: "Market Cap",               value: coin["quote"]["USD"]["market_cap"].to_s)
	        end
		end
	nil
	end
	command(:as) do |event|
	    p JJ.class
		event.channel.send_message("", embed:  JJ)
	end
	command([:btcaddy], description:"Get bitcoin address info", usage:".btcaddy <address> <btc | usd>") do |event, address, type|
		if type.nil?

			# (defaults to `:USD`)
			btc = bitcoin_address_usd(address)
			event.channel.send_embed("l") do |embed|
	          embed.title = "Bitcoin"
	          embed.colour = 0x5345b3
	          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png")
	          embed.add_field(name: "Received",         value: convert_btc_usd(btc["total_received"]).to_s)
	          embed.add_field(name: "Sent",             value: convert_btc_usd(btc["total_sent"]).to_s)
	          embed.add_field(name: "Hash",             value: btc["hash160"].to_s)
	          embed.add_field(name: "Tx",               value: btc["n_tx"].to_s)
	          embed.add_field(name: "Final Balance",    value: convert_btc_usd(btc["final_balance"]).to_s)
	      	end
		elsif type.downcase.to_s == "btc" || type.downcase.to_s == "bitcoin"
			btc = bitcoin_address_usd(address)
			event.channel.send_embed("l") do |embed|
	          embed.title = "Bitcoin - BTC"
	          embed.colour = 0x5345b3
	          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png")
	          embed.add_field(name: "Received",         value: convert_satoshi(btc["total_received"]).to_s)
	          embed.add_field(name: "Sent",             value: convert_satoshi(btc["total_sent"]).to_s)
	          embed.add_field(name: "Hash",             value: btc["hash160"].to_s)
	          embed.add_field(name: "Tx",               value: btc["n_tx"].to_s)
	          embed.add_field(name: "Final Balance",    value: convert_satoshi(btc["final_balance"]).to_s)
	      	end
		elsif type.downcase == "usd"
			btc = bitcoin_address_usd(address)
			event.channel.send_embed("l") do |embed|
	          embed.title = "Bitcoin - USD"
	          embed.colour = 0x5345b3
	          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png")
	          embed.add_field(name: "Received",         value: convert_satoshi(btc["total_received"]).to_s)
	          embed.add_field(name: "Sent",             value: convert_satoshi(btc["total_sent"]).to_s)
	          embed.add_field(name: "Hash",             value: btc["hash160"].to_s)
	          embed.add_field(name: "Tx",               value: btc["n_tx"].to_s)
	          embed.add_field(name: "Final Balance",    value: convert_satoshi(btc["final_balance"]).to_s)
	      	end
		else 
			btc = bitcoin_address_usd(address)
			event.channel.send_embed("l") do |embed|
	          embed.title = "Bitcoin"
	          embed.colour = 0x5345b3
	          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png")
	          embed.add_field(name: "Received",         value: convert_satoshi(btc["total_received"]).to_s)
	          embed.add_field(name: "Sent",             value: convert_satoshi(btc["total_sent"]))
	          embed.add_field(name: "Hash",             value: btc["hash160"].to_s)
	          embed.add_field(name: "Tx",               value: btc["n_tx"].to_s)
	          embed.add_field(name: "Final Balance",    value: convert_satoshi(btc["final_balance"]).to_s)
	      	end
		end
	end
  end
end