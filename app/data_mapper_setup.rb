require 'data_mapper'
require './app/models/tag'
require './app/models/link'


env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, ENV['DATA_BASE'], "postgres://localhost/bookmark_manager_#{env}")



DataMapper.finalize

DataMapper.auto_upgrade!
