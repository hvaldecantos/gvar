require 'cmd'

class ExtractMacroTokensCmd < Cmd
  COMMAND = "cat %s | grep -i '^\s*#\s*define\s'"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts

    @tokens = ["DUMMY_TOKEN"]

    @cmd = COMMAND % [opts[:filters]]
    analyze_result opts[:logpath] unless opts[:filters].strip.empty?

    @tokens.join(",")
  end

  private

    def analize line
      matched = line.match(/^\s*\#\s*define\s*(\w*)/)
      if matched
        token = matched.captures.first.strip
        @tokens |= [token] # unless token.start_with?("GTK_") or token.start_with?("GDK_")
      end
    end

    def default opts = {}
      opts[:filters] ||= "./*.c ./*.h"
      opts
    end
end
