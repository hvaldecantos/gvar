class ListShaCmd
  COMMAND = "git rev-list %s"
  def initialize cmd_runner
    @cmd_runner = cmd_runner
    @shas = []
  end

  def shas tag_range = nil
    analyze_result (tag_range || "HEAD")
    @shas
  end

  private
    def analyze_result tag_range = nil
      cmd = COMMAND % (tag_range || "HEAD")
      @cmd_runner.run(cmd).each_line do |line|
        analize(line.strip)
      end
    end

    def analize line
      @shas << line
    end
end
