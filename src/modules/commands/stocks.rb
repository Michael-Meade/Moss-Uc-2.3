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
    command([:test]) do |event|
        event.channel.send_embed("this `supports` __a__ **subset** *of* ~~markdown~~ 😃 ```js\nfunction foo(bar) {\n  console.log(bar);\n}\n\nfoo(1);```") do |embed|
          embed.title = "title ~~(did you know you can have markdown here too?)~~"
          embed.colour = 0x5345b3
          embed.url = "https://discordapp.com"
          embed.description = "this supports [named links](https://discordapp.com) on top of the previously shown subset of markdown. ```\nyes, even code blocks```"
          embed.timestamp = Time.at(1586462698)

          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://cdn.discordapp.com/embed/avatars/0.png")
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/embed/avatars/0.png")
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "author name", url: "https://discordapp.com", icon_url: "https://cdn.discordapp.com/embed/avatars/0.png")
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "footer text", icon_url: "https://cdn.discordapp.com/embed/avatars/0.png")

          embed.add_field(name: "🤔", value: "some of these properties have certain limits...")
          embed.add_field(name: "😱", value: "try exceeding some of them!")
          embed.add_field(name: "🙄", value: "an informative error should show up, and this view will remain as-is until all issues are fixed")
          embed.add_field(name: "<:thonkang:219069250692841473>", value: "these last two", inline: true)
          embed.add_field(name: "<:thonkang:219069250692841473>", value: "are inline fields", inline: true)
      end
    end
  end
end
=begin
Utils.create_dir("projects", file_name="projects.json")
    	if File.exists?(File.join("projects", "projects.json"))
			id = Utils.get_last_key(File.join("projects", "projects.json"))
	    	file_read = File.read(File.join("projects", "projects.json"))
	    	a = JSON.parse(file_read)
	    	f = File.open(File.join("projects", "projects.json"), "w")
	    	puts a[id] = idea
	    	f.write(JSON.pretty_generate(a))
	    	f.close
    	else
	    	f = File.open(File.join("projects", "projects.json"), "w")
			f.write(JSON.pretty_generate(JSON.pretty_generate({"0" => idea})) )
			f.close
	    end
=end