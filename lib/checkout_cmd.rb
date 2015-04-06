require 'cmd'

class CheckoutCmd < Cmd
  COMMAND = "git checkout %s"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    @cmd = COMMAND % (opts[:sha] || "HEAD")
    analyze_result
  end

  private
    def analize line
    end
end
