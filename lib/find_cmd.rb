class FindCmd
  COMMAND = "find %s -name *.c -or -name *.h"
  def initialize cmd_runner
    @cmd_runner = cmd_runner
    @dirs = {}
  end

  def dirs
    analyze_result
    @dirs
  end

  private
    def analyze_result
      cmd = COMMAND % @cmd_runner.wd
      @cmd_runner.run(cmd).each_line do |line|
        analize(line)
      end
    end

    def analize line
      @dirs[File.dirname(line)] = (@dirs[File.dirname(line)] || 0) + 1
    end

end