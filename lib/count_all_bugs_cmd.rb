require 'cmd'

class CountAllBugsCmd < Cmd
  COMMAND = "git log --reverse --unified=0 %s -- %s"
  def initialize cmd_runner
    super
    @bug_fix = false
    @bugs = 0
  end

  def run opts = {}
    default opts
    dirs = opts[:dirs].map{|d| ("'%s/*.c' '%s/*.h'" % [d, d]) + " "}.join.strip
    @cmd = COMMAND % [opts[:rev_range], dirs]
    analyze_result
    @bugs
  end

  private
    def analize line
      commit_match = line.match(/^commit\s(\w*)$/)
      unless commit_match.nil?
        @bug_fix = false
      end

      if @bug_fix == false && line.match(/(^|\s)(fix|issue|bug|bugfix)/i)
        @bugs += 1
        @bug_fix = true
      end
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
