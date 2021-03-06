require 'cmd'
require 'checkout_cmd'

class FindGVCmd < Cmd
  COMMAND = "ctags -x --c-kinds=v --file-scope=no --language-force=c -I %s %s"
  def initialize cmd_runner
    super
    @gvars = {}
  end

  def run opts = {}
    opts = default(opts)
    @gvars = {}

    CheckoutCmd.new(@cmd_runner).run(opts) unless opts[:sha] = "HEAD"

    if !opts[:filters].empty?
      macro_tokens_string = ExtractMacroTokensCmd.new(@cmd_runner).run(opts)
      @cmd = COMMAND % [macro_tokens_string, opts[:filters]]

      analyze_result opts[:logpath]
    end

    @gvars
  end

  private
    def analize line
      line_match = line.match(/^((?!\$).+?)\s+(.+?)\s+(.+?)\s+(.+?)\s+(.+?)$/)
      name, var, line_num, filename, line_code = line_match.captures unless line_match.nil?
      if name
        @gvars.merge!({name => {line_num: line_num, filename: filename, line_code: line_code, removed: false, bug: 0}})
      end
    end

    def default opts = {}
      opts[:dirs] ||= '.'
      opts[:filters] ||= FindGitFiltersCmd.new(@cmd_runner).run(opts)
      opts[:sha] ||= "HEAD"
      opts
    end
end
