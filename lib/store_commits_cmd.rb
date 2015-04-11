require 'mongo'
require 'cmd_runner'
require 'list_sha_cmd'
require 'checkout_cmd'
require 'find_gv_cmd'

class StoreCommitsCmd < Cmd
  def initialize cmd_runner
    super
  end

  def run opts = {}
    opts = default(opts)

    list_sha_cmd = ListShaCmd.new(@cmd_runner)
    find_gv_cmd = FindGVCmd.new(@cmd_runner)
    checkout_cmd = CheckoutCmd.new(@cmd_runner)

    Mongo::Logger.logger.level = Logger::INFO
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => opts[:db])

    shas = list_sha_cmd.run(opts)
    
    shas.each do |sha|
      checkout_cmd.run(:sha=>sha)

      globals = find_gv_cmd.run(:dirs=>['src','lib'])

      commit = {}
      commit[:sha] = sha
      commit[:globals] = globals
      
      client[:commits].insert_one(commit)
    end

    "Commits stored."
  end

  private
    def analize line
      
    end

    def default opts = {}
      opts[:db] ||= File.basename(@cmd_runner.wd)
      opts[:rev_range] ||= "HEAD^^^..HEAD"
      opts
    end
end
