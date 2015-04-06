gem 'mongo', '~> 1.8'

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

#The global class
###################
class Global
  include MongoMapper::Document

  key :name, String 
  key :first_commit, Integer
  key :bug_count, Integer
  key :classification, String
  
  def initialize (name, first_commit)
    @name         = name
    @first_commit = first_commit
  end    
end

#Query example
g = Global.where(:first_commit => 111).first
puts g[:first_commit]