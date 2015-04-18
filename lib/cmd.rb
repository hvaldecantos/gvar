class Cmd
  def initialize cmd_runner
    @cmd_runner = cmd_runner
    @cmd = ""
  end

  private
    def analyze_result
      @cmd_runner.run(@cmd).each_line do |line|
        analize(line)
      end
    end
end
