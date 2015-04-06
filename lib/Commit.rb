gem 'mongo', '~> 1.8'
gem 'bson', '~>1.8'
gem 'bson_ext', '~>1.8'

require 'bson'
require 'rubygems'
require 'mongo'
require 'mongo_mapper'

#README
#This class requires mongo version 1.8, mongo_mapper, bson and bson_exit using:
#gem install mongo -v 1.8
#gem install mongo_mapper
#gem install bson -v 1.8
#gem install bson_ext -v 1.8

MongoMapper.database="gvar"

#The commit class
##################
class Commit
  include MongoMapper::Document
  
  key :globals, Array 
  key :sha, String
  key :message, String
  key :date, Time
  
  def initialize(sha,message,date,globals)
    @sha      = sha
    @message  = message
    @date     = date
    @globals  = globals
  end
end