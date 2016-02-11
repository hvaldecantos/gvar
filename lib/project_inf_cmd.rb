require 'cmd'
require 'date'

class ProjectInfCmd < Cmd
  COMMAND_FIRST = "git log --reverse --date=short --format=%%cd %s -- %s | head -1"
  COMMAND_LAST = "git log -1 --date=short --format=%%cd %s -- %s | head -1"

  def initialize cmd_runner
    super
    @dates = []
  end

  def run opts = {}
    default opts
    dirs = FindDirsCmd.new(@cmd_runner).run(opts)
    @cmd = COMMAND_FIRST % [opts[:rev_range], dirs]
    analyze_result
    @cmd = COMMAND_LAST % [opts[:rev_range], dirs]
    analyze_result
    
    (@dates[1]-@dates[0]).to_i
  end

  private
    def analize line
      @dates << Date.parse(line.strip)
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
