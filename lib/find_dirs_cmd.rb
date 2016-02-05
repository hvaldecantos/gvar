require 'cmd'

class FindDirsCmd < Cmd
  COMMAND = "find %s -type f -name '*.c' -or -name '*.h'"
  def initialize cmd_runner
    super
    @dirs = []
  end

  def run opts = {}
    opts = default(opts)
    @cmd = COMMAND % opts[:dirs].map{|d| ("%s" % [d]) + " "}.join.strip
    analyze_result
    @dirs.join(" ")
  end

  private
    def analize line
      @dirs |= [(File.dirname(line) + "/*" + File.extname(line)).strip]
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
