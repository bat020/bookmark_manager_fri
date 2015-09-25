module BookmarkWrapper

  module Routes

    class Users < Base

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
          redirect to('/links')
        else
          flash.now[:errors] = @user.errors.full_messages.uniq
          erb :'users/new'
        end
      end

      get '/password_reset' do
        erb :'password_reset/index'
      end

      post '/password_reset' do
        user = User.first(email: params[:email])
        user.password_token = [*0..9].map {|_| [*'A'..'Z'].sample}.join
        user.save
        flash.now[:notice] = ['Check your emails']
        erb :'password_reset/index'
      end

      get '/password_reset/:token' do
        erb :'password_reset/new'
      end

      post '/password_reset/:token' do
        @user = current_user
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]
        if @user.save
          @user.password_token = nil
          @user.save
          flash.now[:notice] = ['Your password has been updated']
          @links = Link.all
          erb :'links/index'
        else
          flash.now[:errors] = @user.errors.full_messages.uniq
          erb :'password_reset/index'
        end
      end

    end

  end

end
