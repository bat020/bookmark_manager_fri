require 'data_mapper'
require './app/data_mapper_setup'

class Link
  include DataMapper::Resource

  property :id,    Serial
  property :title, String
  property :url,   String

  has n, :tags, through: Resource

end
