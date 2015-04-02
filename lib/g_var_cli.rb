require 'optparse'
require 'cmd_runner'
require 'find_cmd'
require 'list_sha_cmd'

class GVarCLI
  
  FIND_SRC_DIRS = '--find-src-dirs'
  LIST_SHAS = '--list-shas'
  GVAR_OPTS = [FIND_SRC_DIRS, LIST_SHAS]

  def self.run argv
    gvar_opts = parse argv
    cr = CmdRunner.new Dir.getwd
    if gvar_opts.include? FIND_SRC_DIRS
      FindCmd.new(cr).dirs
    elsif gvar_opts.include? LIST_SHAS
      ListShaCmd.new(cr).shas
    end
  end

  def self.instanciate_cmd_object gvar_opts
    cr = CmdRunner.new Dir.getwd
    if gvar_opts.include? FIND_SRC_DIRS
      FindCmd.new(cr)
    elsif gvar_opts.include? LIST_SHAS
      ListShaCmd.new(cr)
    end
  end

  def self.parse argv
    gvar_opts = []
    OptionParser.new do |opts|
      opts.banner = "gvar [--find-src-dirs | --list-shas]"
      opts.separator "Command line that returns global variables related reports."
      opts.version = GVar::VERSION
      opts.on('--find-src-dirs', 'Return a hash with directories containing *.c or *.h files and the number of files.'){ gvar_opts << '--find-src-dirs' }
      opts.on('--list-shas', 'Return an array of SHA-1 commit identifier')  { gvar_opts << '--list-shas' }
    end.parse!(argv)
    if (gvar_opts & GVAR_OPTS).size > 1
      raise OptionParser::ParseError.new("#{gvar_opts.join(', ')} are mutually exclusive options")
    end
    gvar_opts
  end
end
