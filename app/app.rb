require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require_relative 'data_mapper_setup'

require './app/controllers/base'
require './app/controllers/links'
require './app/controllers/users'
require './app/controllers/sessions'

module BookmarkWrapper

  class BookmarkManager < Sinatra::Base

  use Routes::Links
  use Routes::Users
  use Routes::Sessions

  run! if app_file == $PROGRAM_NAME

  end

end
