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
	class GetPrice
		def add_json(name, value)
			json = {"name":"","value":""}
			json[:name]  = name
			json[:value] = "#{value}"
			return json
		end
		def get_total(number)
			total  = add_json("Total", number)
		total 
		end
		def convert_btc_usd(number)
	    	response = Net::HTTP.get_response(URI.parse("https://www.blockchain.com/frombtc?value=#{number.to_s.gsub(".", "")}&currency=USD")).response.body
		end
		def get_xmr(value)
			json = JSON.parse(HTTParty.get("https://min-api.cryptocompare.com/data/price?fsym=XMR&tsyms=BTC,USD,XMR").response.body)
			usd  = add_json("USD", value.to_f * json["USD"].to_f)
			xmr  = add_json("XMR", value.to_f * json["XMR"].to_f)
		[ usd, xmr ]
		end
		def get_btc(value)
			s = Satoshi.new(value)
			# convert value into USD
		    usd = add_json("USD", convert_btc_usd(s.to_i))
		    btc = add_json("BTC", value)
		[ usd, btc ]
		end
		def get_xlm(value)
	    	json = JSON.parse(HTTParty.get("https://min-api.cryptocompare.com/data/price?fsym=XLM&tsyms=BTC,USD,XLM").response.body)
	    	usd  = add_json("USD", value.to_f * json["USD"].to_f)
	    	xlm  = add_json("XLM", value.to_f * json["XLM"].to_f)
	    [ usd, xlm ]
	    end

	end

	class CryptoProfile
		Price = GetPrice.new
		def initialize(user_id)
			@user_id = user_id
		end
		def user_id
			@user_id
		end
		def crypto_path
			File.read(File.join("users", user_id.to_s, "crypto.json"))
		end
		def read_profile
			j = {}
			out = []
			JSON.parse(crypto_path).each do |key, value|
				if key.to_s == "xmr"
					out += Price.get_xmr(value)
				elsif key.to_s == "xlm"
					out += Price.get_xlm(value)
				elsif key.to_s == "btc"
					out += Price.get_btc(value)
				end
			end
			total = 0
			out.each do |key|
				if key[:name].to_s == "USD"
					total += key[:value].to_f
				end
		    end
		    j = out
		[ j, total.to_f ]
	    end
	end

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
	def self.send_embed(event:, title:, fields:, description: nil)
        event.channel.send_embed do |embed|
          embed.title       = title
          embed.description = description
          fields.each { |field| embed.add_field(name: field[:name], value: field[:value], inline: field[:inline]) }
        end
	end
	command([:crypto], description:"Get current crypto price.", usage:".crypto <name>\n.crypto p btc\n.crypto ls") do |event, name, coin, amount|
		FileUtils.mkdir_p(File.join("users", event.user.id.to_s))  unless File.exists?(File.join("users", event.user.id.to_s))
	    FileUtils.touch(File.join("users", event.user.id.to_s, "crypto.json")) unless File.exists?(File.join("users", event.user.id.to_s, "crypto.json"))
	    if ( name.to_s == "p" || name.to_s == "profile" )
	    	if (coin.nil? || name.nil?)
	    		event.respond("example: .crypto p btc .1997")
	    	else
	    		add_coin(event.user.id.to_s, coin, amount)
	    	end
	    elsif (name.to_s == "ls" || name.to_s == "l")
	    	usd_total = 0
	    	out = CryptoProfile.new(event.user.id.to_s).read_profile
	    	message = send_embed(event: event, title: 'Crypto Profile', fields: out[0])
	    	event.respond("***Total USD: $*** #{out[1]}")
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