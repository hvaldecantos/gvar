require 'cmd'

class ListShaCmd < Cmd
  COMMAND = "git rev-list --no-merges %s -- %s"
  def initialize cmd_runner
    super
    @shas = []
  end

  def run opts = {}
    default opts
    @cmd = COMMAND % [opts[:rev_range], opts[:filters]]
    analyze_result opts[:logpath]
    @shas
  end

  private
    def analize line
      @shas << line.strip
    end
    def default opts = {}
      opts[:filters] ||= "./*.c ./*.h"
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
