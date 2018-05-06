require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

# Use `binding.pry` anywhere in this script for easy debugging
require "pry"

enable :sessions

configure :development do
    set :database, "sqlite3:app.db"
end
  
  # Following code will ensure that this will only be used on production
configure :production do
    # this environment variable is auto generated/set by heroku
    #   check Settings > Reveal Config Vars on your heroku app admin panel
    set :database, ENV["DATABASE_URL"]
end

get "/" do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :users
    else
      @posts = Post.all
      erb :signed_out_homepage
    end
end

get '/sign_up' do
    erb :sign_up
end

post "/sign_up" do
    @user = User.create(
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      username: params[:username],
      password: params[:password],
      birthday: params[:birthday]
    )
  
    # this line does the signing in
    session[:user_id] = @user.id
    # lets the user know they have signed up
    flash[:info] = "Thank you for signing up"
    
    # assuming this page exists
    redirect "/users"
end

get '/sign_in' do
    erb :sign_in
end

post "/sign_in" do
    @user = User.find_by(username: params[:username])
  
    # checks to see if the user exists
    #   and also if the user password matches the password in the db
    if @user && @user.password == params[:password]
      # this line signs a user in
      session[:user_id] = @user.id
  
      # lets the user know that something is wrong
      flash[:info] = "You have been signed in"
  
      # redirects to the home page
      redirect "/users"
    else
      # lets the user know that something is wrong
      flash[:warning] = "Your username or password is incorrect"
  
      # if user does not exist or password does not match then
      #   redirect the user to the sign in page
      redirect "/sign_in"
    end
end

get "/sign_out" do
    # this is the line that signs a user out
    session[:user_id] = nil
  
    # lets the user know they have signed out
    flash[:info] = "You have been signed out"
    
    redirect "/"
end

get "/post" do
    @user = User.find(session[:user_id])
    erb :post
end

post "/post" do
    @user = User.find(session[:user_id])
    @post = Post.create(
      user_id: @user.id,
      title: params[:title],
      post_content: params[:post_content],
      image: params[:image]
    )
  
    redirect "/users"
end

get "/users" do
    if session[:user_id]
        @user = User.find(session[:user_id])
        
        erb :users
    else
        puts "not logged in"
    end
end


get "/delete_user" do
    if session[:user_id]
        @posts = Post.all
        @posts.each do |post|
            if (post.user_id == session[:user_id] )
                post.destroy
            else
                next
            end  
        end      
        # @id = session[:user_id]
        @user = User.find(session[:user_id]).destroy
        # @posts = Post.find_by(user_id: @id).destroy
        
        session[:user_id] = nil
    end
	erb :signed_out_homepage
end

get "/delete_all_post" do
    if session[:user_id]
        @posts = Post.all
        @posts.each do |post|
            if (post.user_id == session[:user_id] )
                post.destroy
            else
                next
            end  
        end      
    end
	redirect "/users"
end

get "/delete_a_post/:id" do
    if session[:user_id]
        
        post = Post.find(params[:id])
        Post.destroy(post.id)
        
    end
	redirect "/users"
end

# Post.find_by(user_id: session[:user_id]).destroy()