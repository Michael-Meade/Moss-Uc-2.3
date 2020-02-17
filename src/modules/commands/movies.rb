module Bot::DiscordCommands
  module Movie
    extend Discordrb::Commands::CommandContainer
    MOD = "☑"
    	command([:movie],  description:"Add to movie list", usage:".movie <movie_name>") do |event, movie|
    		movie = event.message.content.gsub(".movie ", "")
    		user_id = event.user.id.to_s
    		f = File.open(File.join("users", user_id, "movies.txt"), "a")
    		f.write(["☐ ".to_s, movie].to_s + "\n")
    		f.close
    	end
    	command(:lsmovie, description:"list movies", usage:".lsmovie") do |event|
    		results = ""
    		user_id = event.user.id.to_s
    		File.readlines(File.join("users", user_id, "movies.txt")).each do |line|
    			results += line.gsub('"', "").gsub("[", "").gsub("]", "").gsub(",", "")
    		end
    		event.respond(results.to_s)
    	end
    end
end