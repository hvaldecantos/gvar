require 'cmd'

class CheckoutCmd < Cmd
  COMMAND = "git checkout %s"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts
    @cmd = COMMAND % opts[:sha]
    analyze_result opts[:logpath]
  end

  private
    def analize line
    end
    def default opts = {}
      opts[:sha] ||= "HEAD"
      opts
    end
end
