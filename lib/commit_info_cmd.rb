require 'cmd'

class CommitInfoCmd < Cmd
  COMMAND = "git log --reverse --unified=0 %s^..%s -- %s/*.c %s/*.h"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    @bug_fix = false
    @deletions = ""
    default opts
    opts[:dirs].each do |dir|
      @cmd = COMMAND % [opts[:sha], opts[:sha], dir,dir]
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
      # @TODO can a C code line start with a '-' ? If it can, the following regex
      # would not match some C code. From whar I know, C code can not start with a '-'
      if line.match(/^-(?!-)/)
        @deletions << line.strip
      end
    end
    def default opts = {}
      opts[:sha] ||= "HEAD"
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
