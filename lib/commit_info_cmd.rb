require 'cmd'

class CommitInfoCmd < Cmd
  COMMAND = "git log --reverse --unified=0 %s^..%s -- %s"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    @bug_fix = false
    @deletions = ""
    default opts

    dirs = opts[:dirs].map{|d| ("'%s/*.c' '%s/*.h'" % [d, d]) + " "}.join.strip
    @cmd = COMMAND % [opts[:sha], opts[:sha], dirs]

    begin
      analyze_result
      {
        deletions:@deletions,
        bug_fix:@bug_fix
      }
    # See in git project: 0ca71b3737cbb26fbf037aa15b3f58735785e6e3
    rescue => e
      puts e.message  
      puts e.backtrace.inspect 
    end
  end

  private

    def analize line
      if @bug_fix == false && line.match(/(^|\W)(fix|issue|bug|bugfix)/i)
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
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
