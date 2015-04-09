require 'cmd'
require 'checkout_cmd'

class FindGVCmd < Cmd
  COMMAND = "ctags -x --c-kinds=v --file-scope=no %s/*.c %s/*.h"
  def initialize cmd_runner
    super
    @gvars = []
  end

  def run opts = {}
    opts = default(opts)

    co = CheckoutCmd.new(@cmd_runner)
    co.run(opts)

    opts[:dirs].each do |dir|
      @cmd = COMMAND % [ dir, dir]
      analyze_result
    end
    @gvars
  end

  private
    def analize line
      line_match = line.match(/^(.+?)\s+(.+?)\s+(.+?)\s+(.+?)\s+(.+?)$/)
      name, var, line_num, line_code = line_match.captures unless line_match.nil?
      h = {name: name, line_num: line_num, line_code: line_code, bug: 0}
      @gvars << h
    end

    def default opts = {}
      opts[:dirs] ||= [@cmd_runner.wd]
      opts[:sha] ||= "HEAD"
      opts
    end
end
