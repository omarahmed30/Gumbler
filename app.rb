require "sinatra"
require "sinatra/reloader"
require "sqlite3"
require "active_record"
require "csv"

# Use `binding.pry` anywhere in this script for easy debugging
require "pry"


enable :sessions

set :database, "sqlite3:app.db"


get '/' do
    erb :index
end

get '/sign_up' do
    erb :sign_up
end

get '/sign_in' do
    erb :sign_in
end
