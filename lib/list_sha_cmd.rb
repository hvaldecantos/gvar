require 'cmd'

class ListShaCmd < Cmd
  COMMAND = "git rev-list %s"
  def initialize cmd_runner
    super
    @shas = []
  end

  def shas tag_range = nil
    @cmd = COMMAND % (tag_range || "HEAD")
    analyze_result
    @shas
  end

  private
    def analize line
      @shas << line
    end
end
