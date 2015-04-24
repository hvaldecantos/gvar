require 'cmd'

class ExtractMsgCmd < Cmd
  COMMAND = "git log %s -- '%s/*.c' '%s/*.h'"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts

    @file = File.open(@cmd_runner.cwd + "/commit.msgs", "w")
    @commits = 0
    opts[:dirs].each do |dir|
      @d = dir
      @commits = 0
      @cmd = COMMAND % [opts[:rev_range], dir, dir]
      analyze_result
    end

    @file.close unless @file == nil
    "Word frequencies file saved."
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
      opts[:rev_range] ||= "HEAD"
      opts[:dirs] ||= [@cmd_runner.wd]
      opts
    end
end
