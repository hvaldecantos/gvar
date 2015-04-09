require 'rubygems'
require 'mongo'
require 'mongo_mapper'

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
