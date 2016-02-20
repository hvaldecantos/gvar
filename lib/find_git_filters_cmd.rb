require 'cmd'

class FindGitFiltersCmd < Cmd
  COMMAND = "find %s -type f -name '*.c' -or -name '*.h'"
  def initialize cmd_runner
    super
    @filters = []
  end

  def run opts = {}
    opts = default(opts)

    directories = opts[:dirs].split(" ").select{|dir| File.directory?(dir) }.join(" ").strip

    @cmd = COMMAND % directories
    analyze_result opts[:logpath]

    @filters.join(" ")
  end

  private
    def analize line
      @filters |= [(File.dirname(line) + "/*" + File.extname(line)).strip] unless (line =~ /test|example|sample|demo/i)
    end

    def default opts = {}
      opts[:dirs] ||= '.'
      opts
    end
end
