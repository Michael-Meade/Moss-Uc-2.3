module Bot::DiscordCommands
  module List
    extend Discordrb::Commands::CommandContainer
    command(:uclinks) do |event|
    	event.channel.send_embed(" ") do |embed|
			embed.add_field(name: "ResNet",          value:  "https://www.utica.edu/academic/iits/compuserservices/network/info.cfm")
			embed.add_field(name: "Tickets",         value:  "https://uticatickets.universitytickets.com")
			embed.add_field(name: "Software",        value:  "https://software.utica.edu")
			embed.add_field(name: "Software download",  value:  "https://e5.onthehub.com/")
			embed.add_field(name: "Pioneerplace",    value:  "http://pioneerplace.utica.edu")
			embed.add_field(name: "Password",        value:  "https://password.utica.edu")
			embed.add_field(name: "Engage",          value:  "http://engage.utica.edu")
			embed.add_field(name: "BannerWeb",       value:  "http://bannerweb.utica.edu")
			embed.add_field(name: "WebMail",         value:  "https://mail.google.com/a/utica.edu")
		end
	end
  end
end