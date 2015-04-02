require 'cmd_runner'
require 'find_cmd'

class GVarCLI
  def self.run opt
    cr = CmdRunner.new Dir.getwd
    FindCmd.new(cr).dirs if opt.include? "--find-src-dirs"
  end
end
