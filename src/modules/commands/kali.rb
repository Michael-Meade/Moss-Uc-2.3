require 'mechanize'
module Bot::DiscordCommands
  module Kali
    extend Discordrb::Commands::CommandContainer
    def self.get_response(url)
		mechanize = Mechanize.new
		mechanize.get(url)
	end
	def self.kali
		msg = ""
		lol = get_response("https://www.kali.org/downloads")
		msg += "Link: #{lol.at(get_link_32)[:href].to_s}\n"
		msg += "Hash: #{lol.at(get_hash_32).text.strip.to_s}\n"
		msg += "Link: #{lol.at(get_link_64)[:href].to_s}\n"
		msg += "Hash: #{lol.at(get_hash_64).text.strip.to_s}\n"
		msg
	end
	def self.get_hash_32
		"#page-content > section.l-section.height_auto.for_sidebar.at_right > div > div > div.vc_col-sm-9.vc_column_container.l-content > div > div > section > div > div > div > div > div > div:nth-child(5) > div > div > div > div > div > table > tbody > tr:nth-child(2) > td:nth-child(5)"
	end
	def self.get_link_32
		'//*[@id="page-content"]/section[2]/div/div/div[1]/div/div/section/div/div/div/div/div/div[5]/div/div/div/div/div/table/tbody/tr[2]/td[1]/a'
	end
	def self.get_hash_64
		"#page-content > section.l-section.height_auto.for_sidebar.at_right > div > div > div.vc_col-sm-9.vc_column_container.l-content > div > div > section > div > div > div > div > div > div:nth-child(5) > div > div > div > div > div > table > tbody > tr:nth-child(3) > td:nth-child(5)"
	end
	def self.get_link_64
		'#page-content > section.l-section.height_auto.for_sidebar.at_right > div > div > div.vc_col-sm-9.vc_column_container.l-content > div > div > section > div > div > div > div > div > div:nth-child(5) > div > div > div > div > div > table > tbody > tr:nth-child(3) > td:nth-child(1) > a'
	end
    command(:kali,  description:"Get kali iso download link", usage:".kali") do |event|
		event.respond(kali.to_s)
    end
  end
end