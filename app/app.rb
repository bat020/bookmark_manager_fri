require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  get '/' do
    redirect('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    "hello world"
    erb :'links/new_link'
  end

  post '/links/new' do

  end
run! if app_file == $PROGRAM_NAME

end
