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
    erb :'users/new'
  end

  post 'users' do
    User.create(email: params[:email],
                password: params[:password])
    redirect to('/links')
  end


run! if app_file == $PROGRAM_NAME

end
