require 'cmd'
require 'mongo'

class FindBugsCmd < Cmd
  COMMAND = "git log --reverse --unified=0 %s -- %s"
  def initialize cmd_runner
    super
    @bug_fix = false
    @prior_commit = ""
    @current_commit = ""
    @retrieved_commit = ""
    @bugs = []
    @mongo
    @gvs_in_prior_commit = []
  end

  def run opts = {}
    default opts
    
    Mongo::Logger.logger.level = Logger::INFO
    @mongo = Mongo::Client.new([ '127.0.0.1:27017' ], :database => opts[:db])

    @cmd = COMMAND % [opts[:rev_range], opts[:filters]]
    analyze_result opts[:logpath]

    @bugs
  end

  private
    def analize line
      commit_match = line.match(/^commit\s(\w*)$/)
      unless commit_match.nil?
        # Prints the commit sha1 only if there was a bugfix
        # puts "Bug fix was in: #{commit_match.captures[0]}" if @bug_fix

        # @bugs << "<<<<<<<<<<<<<< #{@current_commit}" if @bug_fix
        @bug_fix = false
        @prior_commit = @current_commit
        @current_commit = commit_match.captures[0]
        # puts "prior: #{@prior_commit} current: #{@current_commit}"
      end

      # avoid debug, prefixe
      if @bug_fix == false && line.match(/(^|\s)(fix|issue|bug)/i)
        @bug_fix = true
        # @bugs << ">>>>>>>>>>>>>> #{line}"
      end

      if @bug_fix
        # it is related to a bug only if a global variable appears in a deleted line
        # A deleted line is also a changed line. A bug fix could never be in an line
        # that is only added.
        if line.match(/^-\s/)
          # @bugs << line
          count_bug_in_db(@prior_commit, @current_commit, line)
        end
      end
    end

    def count_bug_in_db prior_commit, commit, line
      # puts "---->: #{@prior_commit} ---->: #{@current_commit}"
      all_vars_in_prior_commit = get_all_gvs_declared_in(prior_commit)
      # p all_vars_in_prior_commit
      all_vars_in_prior_commit.each do |var_name|
        if line.match(/var_name/)
          @bugs << "#{line} --> #{var_name}"
          # check_as_bug_related(commit, var_name)
        end
      end
    end

    def get_all_gvs_declared_in commit
      # get from mongo all declared global variables in the prior commit of commit arg
      # p "prior: #{commit}"
      # gvs_in_prior_commit = []
      # It won't retrieve from db if it already has retrieved this variables
      unless commit.empty? || @retrieved_commit == commit
        @gvs_in_prior_commit = @mongo[:commits].find({sha: commit}).first[:globals].map{|var| var[:name]}
      end
      @retrieved_commit = commit
      #
      @gvs_in_prior_commit
    end

    def check_as_bug_related commit, var_name
      # set in mongo commits.update{ :sha => commmit, globals => var_name}[bug: 1]
    end

    def default opts = {}
      opts[:filters] ||= "./*.c ./*.h"
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
