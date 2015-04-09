require 'optparse'
require 'cmd_runner'
require 'find_cmd'
require 'list_sha_cmd'
require 'checkout_cmd'
require 'find_gv_cmd'
require 'g_var/version'

class GVarCLI
  
  FIND_SRC_DIRS = '--find-src-dirs'
  LIST_SHAS = '--list-shas'
  GVAR_OPTS = [FIND_SRC_DIRS, LIST_SHAS]

  def self.run argv
    gvar_opts, cmd_opts = parse argv
    cmd = instanciate_cmd_object gvar_opts
    cmd.run cmd_opts
  end

  def self.instanciate_cmd_object gvar_opts
    cr = CmdRunner.new Dir.getwd
    if gvar_opts.include? FIND_SRC_DIRS
      FindCmd.new(cr)
    elsif gvar_opts.include? LIST_SHAS
      ListShaCmd.new(cr)
    elsif gvar_opts.include? '--checkout'
      CheckoutCmd.new(cr)
    elsif gvar_opts.include? '--find-gv'
      FindGVCmd.new(cr)
    end
  end

  def self.parse argv
    gvar_opts = []
    cmd_opts = {}
    OptionParser.new do |opts|
      opts.banner = "\ngvar [\t--find-src-dirs |\n" +
                          "\t--list-shas <--rev-range=tag1..tag2> |\n"+
                          "\t--checkout <--sha=6419aee248d76> |\n" +
                          "\t--find-gv --dirs=\"['src','liv']\" <--sha=6419aee248d76> ]\n\n"
      opts.separator "Command line that returns global variables related reports."
      opts.version = GVar::VERSION
      opts.on('--find-src-dirs', 'Return a hash with directories containing *.c or *.h files and the number of files.'){ gvar_opts << '--find-src-dirs' }
      opts.separator("")
      opts.on('--checkout', 'Checkout')  { gvar_opts << '--checkout' }
      opts.on('--sha shaID', 'shar id of the revision')  { |o| cmd_opts[:sha] = o }
      opts.separator("")
      opts.on('--list-shas', 'Return an array of SHA-1 commit identifier')  { gvar_opts << '--list-shas' }
      opts.on('--rev-range tag1..tag2', 'Set the range of sha to take into consideration')  { |o| cmd_opts[:rev_range] = o }
      opts.separator("")
      opts.on('--find-gv', 'Find global vars')  { gvar_opts << '--find-gv' }
      opts.on('--dirs array_dirnames', 'array directory to analyse and find gvs') { |o| cmd_opts[:dirs] = eval(o) }
    end.parse!(argv)
    if (gvar_opts & GVAR_OPTS).size > 1
      raise OptionParser::ParseError.new("#{gvar_opts.join(', ')} are mutually exclusive options")
    end
    [gvar_opts, cmd_opts]
  end
end
