require 'mongo'
require 'cmd_runner'
require 'list_sha_cmd'
require 'checkout_cmd'
require 'find_gv_cmd'
require 'globals_info'
require 'mongo'
require 'commit_info_cmd'

class StoreCommitsCmd < Cmd
  def initialize cmd_runner
    super
  end

  def run opts = {}
    opts = default(opts)

    list_sha_cmd = ListShaCmd.new(@cmd_runner)
    find_gv_cmd = FindGVCmd.new(@cmd_runner)
    checkout_cmd = CheckoutCmd.new(@cmd_runner)
    globals_info = GlobalsInfo.new
    commit_info_cmd = CommitInfoCmd.new(@cmd_runner)

    Mongo::Logger.logger.level = Logger::INFO
    mongo = Mongo::Client.new([ '127.0.0.1:27017' ], :database => opts[:db])

    shas = list_sha_cmd.run(opts)
    puts "gvar started at (#{Time.new})"

    count = shas.size
    n = 0

    mongo[:globals].insert_one({})
    
    @bug_found = 0

    prior_globals = {}
    shas.each do |sha|
      puts "--------> #{sha}"
      n += 1
      checkout_cmd.run(opts.merge({sha: sha}))
      # get git filter in the indicated directories
      opts[:filters] = FindGitFiltersCmd.new(@cmd_runner).run(opts)
      puts "--------> #{opts[:filters]}"
      globals = find_gv_cmd.run(opts)
      commit_info = commit_info_cmd.run(opts.merge({sha: sha}))
      commit = {}
      commit[:sha] = sha
      commit[:log] = commit_info[:log]
      commit[:globals] = find_bugs(sha, globals, prior_globals, commit_info)
      # mongo[:commits].insert_one(commit)
      prior_globals = globals
      globals_info.process_commit(commit)
      if n%100==0
        puts "Sha: #{sha} #{n}/#{count} done (#{Time.new})"
        mongo[:globals].find().replace_one(globals_info.info)
      end

    end
    mongo[:globals].find().replace_one(globals_info.info)
    puts "Bugs found #{@bug_found}"
    "Commits stored: #{n}/#{count} done (#{Time.new})"
  end

  private
    def find_bugs sha, globals, prior_globals, info
      found = false
      if info[:bug_fix]
        prior_globals.each do |var_name, v|
          if info[:deletions].match /(^|\W)#{var_name}($|\W)/
            if found == false 
              @bug_found += 1
              found = true
            end
            puts "Bug found (#{@bug_found}) related to #{var_name} in #{sha}"
            # A gv that is removed in a bugfix commit does not exist in the
            # actual globals hash, so I add it.
            if globals[var_name].nil?
              globals.merge!({var_name => prior_globals[var_name]})
              globals[var_name][:removed] = true
            end
            globals[var_name][:bug] = 1
          end
        end
      end
      globals
    end

    def analize line
      
    end

    def default opts = {}
      opts[:db] ||= File.basename(@cmd_runner.wd)
      opts[:dirs] ||= '.'
      opts[:filters] ||= FindGitFiltersCmd.new(@cmd_runner).run(opts)
      opts[:rev_range] ||= "HEAD^^^..HEAD"
      opts
    end
end
