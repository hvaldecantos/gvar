require 'cmd'

class ListShaCmd < Cmd
  COMMAND = "git rev-list %s"
  def initialize cmd_runner
    super
    @shas = []
  end

  def run opts = {}
    @cmd = COMMAND % (opts[:rev_range] || "HEAD")
    analyze_result
    @shas
  end

  private
    def analize line
      @shas << line
    end
end
