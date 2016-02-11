require 'cmd'

class ListShaCmd < Cmd
  COMMAND = "git rev-list %s"
  def initialize cmd_runner
    super
    @shas = []
  end

  def run opts = {}
    default opts
    @cmd = COMMAND % opts[:rev_range]
    analyze_result
    @shas
  end

  private
    def analize line
      @shas << line.strip
    end
    def default opts = {}
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
