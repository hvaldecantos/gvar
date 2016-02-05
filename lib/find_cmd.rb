require 'cmd'

class FindCmd < Cmd
  COMMAND = "find %s -type f -name '*.c' -or -name '*.h'"
  def initialize cmd_runner
    super
    @dirs = {}
  end

  def run opts = {}
    @cmd = COMMAND % @cmd_runner.wd
    analyze_result
    @dirs
  end

  private
    def analize line
      @dirs[File.dirname(line)] = (@dirs[File.dirname(line)] || 0) + 1
    end
end
