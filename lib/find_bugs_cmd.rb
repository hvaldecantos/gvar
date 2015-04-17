require 'cmd'

class FindBugsCmd < Cmd
  COMMAND = "git log %s -- %s/*.c %s/*.h"
  def initialize cmd_runner
    super
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
      @bugs << line if line.match(/fix/i)
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
