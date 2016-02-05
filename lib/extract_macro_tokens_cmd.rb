require 'cmd'

class ExtractMacroTokensCmd < Cmd
  COMMAND = "cat %s | grep -i '^\s*#\s*define\s'"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts

    @tokens = []

    dirs_to_analyze_string = FindDirsCmd.new(@cmd_runner).run(opts)
    @cmd = COMMAND % [dirs_to_analyze_string]
    analyze_result

    @tokens.join(",")
  end

  private

    def analize line
      matched = line.match(/^\s*\#\s*define\s*(\w*)/)
      if matched
        token = matched.captures
        @tokens |= [token.first.strip + "+"]
      end
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
