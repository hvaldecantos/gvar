require 'cmd'

class ExtractMsgCmd < Cmd
  COMMAND = "git log %s -- %s"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts

    filename = @cmd_runner.cwd + "/commit.msgs"
    @file = File.open(filename, "w")
    @commits = 0

    @cmd = COMMAND % [opts[:rev_range], opts[:filters]]
    analyze_result opts[:logpath]

    @file.close unless @file == nil
    "All commit messages file '#{filename}' saved."
  end

  private

    def analize line
      if line.match(/^commit\s\w{40}$/)
        @commits +=1
        @file.write("[Commit][#{@d}][#{@commits}]\n")
      elsif line.match(/^Author:\s(.*[^\s])\s+</)
      elsif line.match(/^Date:\s\s\s[A-Z][a-z]{2}\s[A-Z][a-z]{2}\s\d+\s\d+:\d+:\d+\s\d{4}\s(-|\+)\d{4}$/)
      elsif !line.strip.empty?
        @file.write(line)
      end
    end

    def default opts = {}
      opts[:filters] ||= "./*.c ./*.h"
      opts[:rev_range] ||= "HEAD"
      opts
    end
end
