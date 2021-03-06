require 'pry'
class TweetsController < ApplicationController
  use Rack::Flash


  get '/tweets' do
      if logged_in?
        @tweets = Tweet.all
      erb :'tweets/tweets'
      else
      redirect '/login'
      end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if logged_in?
      if params[:content] == ""
        flash[:message] = "Missing Data - Try Again"
        redirect '/tweets/new'
      else
      @tweet = current_user.tweets.build(content: params[:content])
      @tweet.save

      redirect "/tweets/#{@tweet.id}"
    end
  end
end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb  :'/tweets/show_tweet'
    else
      redirect '/login'
    end
  end


  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == current_user.id
        erb :'/tweets/edit_tweet'
        end
      else
    redirect '/login'
    end
  end

    patch '/tweets/:id' do
      if logged_in?
      if params[:content] == ""
      redirect "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by_id(params[:id])
          if @tweet.user_id == current_user.id
          if @tweet.update(content: params[:content])
          redirect "/tweets/#{@tweet.id}"
          else
          redirect "/tweets/#{@tweet.id}/edit"
          end
          else
          redirect '/tweets'
          end
          end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == current_user.id
        @tweet.delete
        flash[:message] = "Tweet Deleted"
        redirect '/users/show'
      else
    redirect '/login'
    end
  end
end

end
