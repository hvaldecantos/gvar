require 'cmd'

class FindGVCmd < Cmd
  COMMAND = "ctags -x --c-kinds=v --file-scope=no %s/*.c %s/*.h"
  def initialize cmd_runner
    super
    @gvars = []
  end

  def run opts = {}
    opts = default(opts)
    opts[:dirs].each do |dir|
      @cmd = COMMAND % [ dir, dir]
      analyze_result
    end
    @gvars
  end

  def default opts = {}
    opts[:dirs] ||= [@cmd_runner.wd]
    opts
  end

  private
    def analize line
      # line.start_with "error:" raise StandardError.new("")
      # @dirs[File.dirname(line)] = (@dirs[File.dirname(line)] || 0) + 1
      line_match = line.match(/^(.+?)\s+(.+?)\s+(.+?)\s+(.+?)\s+(.+?)$/)
      name, var, line_num, code = line_match.captures unless line_match.nil?
      @gvars << "#{line_num} - #{name} - #{code} "
    end
end
