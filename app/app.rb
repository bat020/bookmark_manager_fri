require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  use Rack::MethodOverride
  enable :sessions
  register Sinatra::Flash
  register Sinatra::Partial
  set :partial_template_engine, :erb
  set :session_secret, 'super secret'

  get '/' do
    redirect('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/new_link' do
    erb :'links/new_link'
  end

  post '/new_link' do
    link = Link.new(url: params[:url],
                    title: params[:title])
    split_tags = params[:tag].split(' ')
      split_tags.each do |tag|
        newtag = Tag.create(name: tag)
        link.tags << newtag
      end
    link.save
    redirect('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages.uniq
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    flash.now[:notice] = ['Goodbye!']
    @user = User.new
    session[:user_id] = nil
    erb :'/sessions/new'
  end

  helpers do
   def current_user
     @current_user ||= User.get(session[:user_id])
   end
  end

run! if app_file == $PROGRAM_NAME

end
