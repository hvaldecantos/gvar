require 'bson'
require 'mongo'
require 'mongo_mapper'

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
