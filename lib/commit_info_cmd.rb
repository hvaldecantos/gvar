require 'cmd'

class CommitInfoCmd < Cmd
  COMMAND = "git log --reverse --first-parent --unified=0 %s^..%s -- %s"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    @bug_fix = false
    @deletions = ""
    @log = ""
    default opts

    @cmd = COMMAND % [opts[:sha], opts[:sha], opts[:filters]]

    begin
      analyze_result opts[:logpath]
      {
        deletions:@deletions,
        bug_fix:@bug_fix,
        log:@log
      }
    # See in git project: 0ca71b3737cbb26fbf037aa15b3f58735785e6e3 it has no parent sha^
    rescue => e
      puts e.message  
      puts e.backtrace.inspect 
      {
        deletions: "",
        bug_fix: false
      }
    end
  end

  private

    def analize line
      @log << line
      if @bug_fix == false && line.match(/(^|\W)(fix|issue|bug|bugfix)/i) && line.match(/^[^+-@]/) && !line.start_with?("diff --git")
        @bug_fix = true
      end
      # @TODO can a C code line start with a '-' ? If it can, the following regex
      # would not match some C code. From whar I know, C code can not start with a '-'
      if line.match(/^-(?!-)/)
        @deletions << line.strip + " "
      end
    end
    def default opts = {}
      opts[:sha] ||= "HEAD"
      opts[:filters] ||= "./*.c ./*.h"
      opts
    end
end
