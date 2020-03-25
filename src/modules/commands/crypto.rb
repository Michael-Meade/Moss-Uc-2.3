require_relative 'utils'
require 'json'
require 'httparty'
require 'uri'
require 'net/http'
require 'colorize'
module Bot::DiscordCommands
  module Crypto
    extend Discordrb::Commands::CommandContainer
    def self.convert_satoshi(number)
    	puts number / 100000000.0
    	return number.to_f / 100000000.0
    end
	def self.convert_btc_usd(number)
		btc = convert_satoshi(number.to_f).to_s.gsub(".", "")
		puts btc
    	response = Net::HTTP.get_response(URI.parse("https://www.blockchain.com/frombtc?value=#{btc}&currency=USD")).response.body
	end
	def self.bitcoin_address_usd(address)
		response = Net::HTTP.get_response(URI.parse("https://blockchain.info/rawaddr/#{address}"))
    	btc      = JSON.parse(response.body)
    	"
    	**Received:** $#{convert_btc_usd(btc["total_received"]).to_s}
    	**Sent:** $#{convert_btc_usd(btc["total_sent"].to_i).to_s}
    	**Hash:** #{btc["hash160"]}
    	**TX:** #{btc["n_tx"]}
    	**Final Balance:** $#{convert_btc_usd(btc["final_balance"].to_i).to_s}
    	".gsub("\t        ", "").gsub("\t", "").gsub("  ", "").lstrip
	end
	def self.bitcoin_address_btc(address)
		response = Net::HTTP.get_response(URI.parse("https://blockchain.info/rawaddr/#{address}"))
    	btc      = JSON.parse(response.body)
    	"
    	**Received:** #{convert_satoshi(btc["total_received"])}
    	**Sent:** #{convert_satoshi(btc["total_sent"])}
    	**Hash:** #{btc["hash160"]}
    	**TX:** #{btc["n_tx"]}
    	**Final Balance:** #{convert_satoshi(btc["final_balance"])}
    	".gsub("\t        ", "").gsub("\t", "").gsub("  ", "").lstrip
	end
	def self.crypto_price(crypto)
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
				read[coin] += amount.to_f
				File.open(File.join("users", uid, "crypto.json"), "w") { |file| file.write(read.to_json ) }
			else 
				read = JSON.parse(File.read(File.join("users", uid, "crypto.json")))
				read[coin] = amount
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
	    elsif name.to_s == "ls" || name.to_s == "l"
	    	JSON.parse(File.read(File.join("users", event.user.id.to_s, "crypto.json"))).each do |key, value|
	    		if key.to_s == "btc"
	    			btc = convert_btc_usd(value)
	    			event.respond("BTC: #{value}\nUSD: #{btc}")
	    		end
	    	end
		else
			event.respond(crypto_price(name).strip)
		end
	end
	command([:btcaddy], description:"Get bitcoin address info", usage:".btcaddy <address> <btc | usd>") do |event, address, type|
		if type.nil?
			event.respond(bitcoin_address_usd(address).to_s)
		elsif type.downcase.to_s == "btc" || type.downcase.to_s == "bitcoin"
			event.respond(bitcoin_address_btc(address).to_s)
		elsif type.downcase == "usd"
			event.respond(bitcoin_address_usd(address).to_s)
		else 
			event.respond(bitcoin_address_usd(address).to_s)
		end
	end
	#convert_btc_usd(2965880500000)
  end
end