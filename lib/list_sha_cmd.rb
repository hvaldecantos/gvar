class ListShaCmd
  COMMAND = "git rev-list %s"
  def initialize cmd_runner
    @cmd_runner = cmd_runner
    @shas = []
    @cmd = ""
  end

  def shas tag_range = nil
    @cmd = COMMAND % (tag_range || "HEAD")
    analyze_result
    @shas
  end

  private
    def analyze_result
      @cmd_runner.run(@cmd).each_line do |line|
        analize(line.strip)
      end
    end

    def analize line
      @shas << line
    end
end
