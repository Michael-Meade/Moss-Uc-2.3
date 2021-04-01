require 'sinatra'
require "sqlite3"
get '/' do 
    n = params[:name]
    db = SQLite3::Database.open "#{__dir__}/test2.db"
    puts n
    db.execute( "select * FROM Accounts WHERE email = #{n}" )
end