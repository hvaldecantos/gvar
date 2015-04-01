class CmdRunner
  attr_reader :wd

  def initialize wd = Dir.getwd
    @wd = wd
  end
end
