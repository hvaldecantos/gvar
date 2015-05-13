require 'cmd'

class ListShaCmd < Cmd
  COMMAND = "git rev-list --no-merges %s -- %s"
  def initialize cmd_runner
    super
    @shas = []
  end

  def run opts = {}
    default opts
    dirs = opts[:dirs].map{|d| ("'%s/*.c' '%s/*.h'" % [d, d]) + " "}.join.strip
    @cmd = COMMAND % [opts[:rev_range], opts[:sha], dirs]
    analyze_result
    @shas
  end

  private
    def analize line
      @shas << line.strip
    end
    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
