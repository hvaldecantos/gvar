require 'cmd'

class ExtractMacroTokensCmd < Cmd
  COMMAND = "cat %s | grep -i '^\s*#\s*define\s'"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts

    filename = @cmd_runner.cwd + "/macro.token_list"
    @file = File.open(filename, "w")
    @commits = 0

    dirs = opts[:dirs].map{|d| ("%s/*.c %s/**/*.c %s/*.h %s/**/*.h" % [d, d, d, d]) + " "}.join.strip
    @cmd = COMMAND % [dirs]
    analyze_result

    @file.close unless @file == nil
    "All macro definition tokens saved in file '#{filename}'."
  end

  private

    def analize line
      matched = line.match(/^\s*\#\s*define\s*(\w*)/)
      if matched
        token = matched.captures
        @file.write(token.first.strip + "+\n")
      end
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
