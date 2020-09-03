require "sqlite3"
class SqlInjection
	def self.challenge_1(input)
		puts __dir__
		db = SQLite3::Database.open "#{__dir__}/test2.db"
		puts "select * FROM Accounts WHERE email = #{input}"
	db.execute( "select * FROM Accounts WHERE email = #{input}" )
	end
end

