require 'cmd'

class FindBugsCmd < Cmd
  COMMAND = "git log --unified=0 %s -- %s/*.c %s/*.h"
  def initialize cmd_runner
    super
    @bug_fix = false
    @commit = ""
    @bugs = []
  end

  def run opts = {}
    default opts
    opts[:dirs].each do |dir|
      @cmd = COMMAND % [opts[:rev_range], dir, dir]
      analyze_result
    end
    @bugs
  end

  private
    def analize line
      commit_match = line.match(/^commit\s(\w*)$/)
      unless commit_match.nil?
        # Prints the commit sha1 only if there was a bugfix
        # puts "Bug fix was in: #{commit_match.captures[0]}" if @bug_fix

        @bugs << "<<<<<<<<<<<<<< #{@commit}" if @bug_fix
        @bug_fix = false
        @commit = commit_match.captures[0]
      end

      # avoid debug, prefixe
      if @bug_fix == false && line.match(/(^|\s)(fix|issue|bug)/i)
        @bug_fix = true
        @bugs << ">>>>>>>>>>>>>> #{line}"
      end

      if @bug_fix
        # it is related to a bug only if a global variable appears in a deleted line
        # A deleted line is also a changed line. A bug fix could never be in an line
        # that is only added.
        # puts line if line.match(/^-\s/)
        @bugs << line if line.match(/^-\s/)
      end
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
