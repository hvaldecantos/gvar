require 'logger'

class Cmd
  def initialize cmd_runner
    @cmd_runner = cmd_runner
    @cmd = ""
  end

  private
    def analyze_result logpath
      logpath ||= '.'
      Logger.new("#{logpath}/command_execution.log").info(@cmd)
      @cmd_runner.run(@cmd).each_line do |line|
        analize(line)
      end
    end
end
