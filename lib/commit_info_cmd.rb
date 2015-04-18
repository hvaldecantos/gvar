require 'cmd'

class CommitInfoCmd < Cmd
  COMMAND = "git log --reverse --unified=0 %s^..%s -- %s/*.c %s/*.h"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    @log = ""
    @bug_fix = false
    @deletions = ""
    default opts
    opts[:dirs].each do |dir|
      @cmd = COMMAND % [opts[:sha], opts[:sha], dir,dir]
      #puts @cmd
      analyze_result
    end
    
    {
      deletions:@deletions,
      bug_fix:@bug_fix
    }
  end

  private

    def analize line
      if @bug_fix == false && line.match(/(^|\s)(fix|issue|bug)/i)
        @bug_fix = true
      end
      if line.index("- ") == 0
        @deletions << line + "\n"
      end
      @log << line + "\n"
    end
    def default opts = {}
      opts[:sha] ||= "HEAD"
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
