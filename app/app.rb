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

  get '/new_link' do
    erb :'links/new_link'
  end

  post '/new_link' do
    Link.create(:title => params[:title], :url => params[:url])
    redirect('/links')
  end

run! if app_file == $PROGRAM_NAME

end
