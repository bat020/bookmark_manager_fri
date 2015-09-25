module BookmarkWrapper

  module Routes

    class Links < Base

      get '/' do
        redirect('/links')
      end

      get '/links' do
        @links = Link.all
        erb :'links/index'
      end

      get '/links/new' do
        erb :'links/new'
      end

      post '/links/new' do
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

    end

  end

end
