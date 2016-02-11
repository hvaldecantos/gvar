require 'cmd'

class FindGitFiltersCmd < Cmd
  COMMAND = "find %s -type f -name '*.c' -or -name '*.h'"
  def initialize cmd_runner
    super
    @dirs = []
  end

  def run opts = {}
    opts = default(opts)
    @cmd = COMMAND % opts[:dirs].strip
    analyze_result
    @dirs.join(" ")
  end

  private
    def analize line
      @dirs |= [(File.dirname(line) + "/*" + File.extname(line)).strip] unless (line =~ /test|example/i)
    end

    def default opts = {}
      opts[:dirs] ||= '.'
      opts
    end
end
