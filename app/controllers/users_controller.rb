class UsersController < ApplicationController
  use Rack::Flash


  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
     erb :'/users/show'
  end

  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
    redirect '/tweets'
  end
end


  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      flash[:message] = "Missing Information- Please Try Again"
      redirect '/signup'
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
        @user.save

        session[:user_id] = @user.id
        redirect '/tweets'
    end
  end


  get '/login' do
    if !logged_in?
    erb :'users/login'
  else
    redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      flash[:message] = "Login Failed, Please Try Again (You May Need to Register)"
      redirect '/login'
    end
  end


  get '/logout' do
    if logged_in?
    session.destroy
    redirect '/login'
    else
    redirect '/'
    end
  end

end
