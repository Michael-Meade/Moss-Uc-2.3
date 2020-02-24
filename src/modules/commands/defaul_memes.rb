require_relative 'utils'
require 'httparty'
require "open-uri"
module Bot::DiscordCommands
  # Responds with "Pong!".
  # This used to check if bot is alive
  module Memes
    extend Discordrb::Commands::CommandContainer
    Utils.create_dir("memes", file_name="memes.json")
    command([:dab, :dabs],  description:"Dab like a champ", usage:".dab") do |event|
        if File.exist?(File.join("users", event.user.id.to_s, "dab", "dab.gif"))
            event.send_file(File.open(File.join("users", event.user.id.to_s, "dab", "dab.gif"), 'r'))
        else
    	   event.send_file(File.open('images/dab.gif', 'r'))
        end
    end
    command([:plead], description: "plead the fifth", usage:".5") do |event|
        event.send_file(File.open("images/plead.png"))
    end
    command([:great, :scott, :greatscott],  description:"Great Scott", usage:".great") do |event|
        event.send_file(File.open('images/BitcoinBackToTheFuture.png', 'r'))
    end 
    command([:false],  description:"thats false", usage:".false
        ") do |event|
        event.send_file(File.open('images/false.gif', 'r'))
    end
    command([:ok, :okay],  description:"Okay", usage:".ok") do |event|
    	event.send_file(File.open('images/ok.gif', 'r'))
    end
    command([:sad, :sadboys],  description:"sad", usage:".sad") do |event|
    	event.send_file(File.open('images/sad.gif', 'r'))
    end
    command([:dead],  description:"Dead", usage:".dead") do |event|
    	event.send_file(File.open('images/dead.gif', 'r'))
    end
    command([:help],  description:"Oh", usage:".help") do |event|
        event.send_file(File.open('images/commands_lists.png', 'r'))
    end
    command([:boom], description: "boom", usage:".boom") do |event|
        event.send_file(File.open('images/boom-boom.gif', 'r'))
    end
    command([:dawg], description: "dawg", usage:".dawg") do |event|
        event.send_file(File.open('images/dawg.gif', 'r'))
    end
    command([:meanie],  description:"meanie", usage:".meanie") do |event|
        event.send_file(File.open('images/MEANIE.png', 'r'))
    end
    command([:firewall]) do |event|
        event.send_file(File.open("images/firewall.png", 'r'))
    end
    command([:fo],  description:"fo", usage:".fo") do |event|
        event.send_file(File.open('images/fo.png', 'r'))
    end
    command([:yup],  description:"Yup", usage:".yup") do |event|
    	event.send_file(File.open('images/yup.gif', 'r'))
    end
    command([:crazy],  description:"crazy", usage:".crazy") do |event|
        event.send_file(File.open('images/crazy.png', 'r'))
    end
    command([:friday],  description:"friday", usage:".friday") do |event|
        event.send_file(File.open('images/friday.png', 'r'))
    end
    command([:dope],  description:"dope", usage:".dope") do |event|
        event.send_file(File.open('images/dope.png', 'r'))
    end
    command([:beerme],  description:"beerme", usage:".beerme") do |event|
        event.send_file(File.open('images/beer.gif', 'r'))
    end
    command([:phat],  description:"phat", usage:".phat") do |event|
        event.send_file(File.open('images/phat.png', 'r'))
    end
    command([:no, :nou],  description:"nou", usage:".nou") do |event|
        event.send_file(File.open('images/nou.png', 'r'))
    end
    command([:dew],  description:"dew", usage:".dew") do |event|
        event.send_file(File.open('images/dew.png', 'r'))
    end
    command([:smart],  description:"Show that a statement is smart", usage:".smart") do |event|
    	event.send_file(File.open('images/smart.gif', 'r'))
    end
    command([:chicken, :butt, :chickenbutt],  description:"Guess what?", usage:".chicken") do |event|
    	event.send_file(File.open('images/chicken_butt.jpg', 'r'))
    end
    command([:burnutica, :utica, :burn],  description:"Burn Utica to the ground", usage:".burn") do |event|
        event.send_file(File.open('images/burn_utica.gif', 'r'))
    end
  end
end
