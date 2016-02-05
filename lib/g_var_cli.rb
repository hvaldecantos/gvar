require 'optparse'
require 'cmd_runner'
require 'find_cmd'
require 'find_dirs_cmd'
require 'list_sha_cmd'
require 'checkout_cmd'
require 'find_gv_cmd'
require 'find_bugs_cmd'
require 'store_commits_cmd'
require 'commit_info_cmd'
require 'extract_msg_cmd'
require 'word_freq_cmd'
require 'count_all_bugs_cmd'
require 'project_inf_cmd'
require 'extract_macro_tokens_cmd'

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
    elsif gvar_opts.include? '--find-dirs-to-analyze'
      FindDirsCmd.new(cr)
    elsif gvar_opts.include? LIST_SHAS
      ListShaCmd.new(cr)
    elsif gvar_opts.include? '--checkout'
      CheckoutCmd.new(cr)
    elsif gvar_opts.include? '--find-gv'
      FindGVCmd.new(cr)
    elsif gvar_opts.include? '--store-commits'
      StoreCommitsCmd.new(cr)
    elsif gvar_opts.include? '--find-bugs'
      FindBugsCmd.new(cr)
    elsif gvar_opts.include? '--commit-info'
      CommitInfoCmd.new(cr)
    elsif gvar_opts.include? '--extract-msgs'
      ExtractMsgCmd.new(cr)
    elsif gvar_opts.include? '--extract-macro-tokens'
      ExtractMacroTokensCmd.new(cr)
    elsif gvar_opts.include? '--word-freqs'
      WordFreqCmd.new(cr)
    elsif gvar_opts.include? '--count-all-bugs'
      CountAllBugsCmd.new(cr)
    elsif gvar_opts.include? '--project-inf'
      ProjectInfCmd.new(cr)
    end
  end

  def self.parse argv
    gvar_opts = []
    cmd_opts = {}
    OptionParser.new do |opts|
      opts.banner = "\ngvar [\t--find-src-dirs |\n" +
                          "\t--find-dirs-to-analyze --dir=\"['src', 'lib']\" \n" +
                          "\t--list-shas <--rev-range=tag1..tag2> |\n"+
                          "\t--checkout <--sha=6419aee248d76> |\n" +
                          "\t--find-gv --dirs=\"['src','lib']\" <--sha=6419aee248d76> \n" +
                          "\t--store-commits --db=dbname --dirs=\"['src','lib']\" --rev-range=tag1..tag2 \n" +
                          "\t--find-bugs --db=dbname --dirs=\"['src','lib']\" --rev-range=tag1..tag2 \n" +
                          "\t--commit-info --dirs=\"['src','lib']\" --sha=6419aee248d76 \n" +
                          "\t--extract-msgs --dirs=\"['src','lib']\" --rev-range=tag1..tag2 \n" +
                          "\t--extract-macro-tokens --dirs=\"['src','lib']\" \n" +
                          "\t--word-freqs --msgs-file=filename.msgs \n" +
                          "\t--count-all-bugs --dirs=\"['src','lib']\" --rev-range=tag1..tag2\n " +
                          "\t--project-inf --dirs=\"['src','lib']\" --rev-range=tag1..tag2 ]\n\n"
      opts.separator "Command line that returns global variables related reports."
      opts.version = GVar::VERSION
      opts.on('--find-src-dirs', 'Return a hash with directories containing *.c or *.h files and the number of files.'){ gvar_opts << '--find-src-dirs' }
      opts.on('--find-dirs-to-analyze', 'Return a space separeted string with directories containing *.c or *.h files.'){ gvar_opts << '--find-dirs-to-analyze' }
      opts.separator("")
      opts.on('--checkout', 'Checkout')  { gvar_opts << '--checkout' }
      opts.on('--sha shaID', 'shar id of the revision')  { |o| cmd_opts[:sha] = o }
      opts.separator("")
      opts.on('--list-shas', 'Return an array of SHA-1 commit identifier')  { gvar_opts << '--list-shas' }
      opts.on('--rev-range tag1..tag2', 'Set the range of sha to take into consideration')  { |o| cmd_opts[:rev_range] = o }
      opts.separator("")
      opts.on('--find-gv', 'Find global vars')  { gvar_opts << '--find-gv' }
      opts.on('--dirs array_dirnames', 'array directory to analyse and find gvs') { |o| cmd_opts[:dirs] = eval(o) }
      opts.separator("")
      opts.on('--store-commits', 'Store commits to DB')  { gvar_opts << '--store-commits' }
      opts.on('--db ', 'Database to store commits')  { |o| cmd_opts[:db] = o }
      opts.on('--find-bugs', 'Find bugs related to stored global variables')  { gvar_opts << '--find-bugs' }
      opts.on('--commit-info', 'Gets data from the sha log')  { gvar_opts << '--commit-info' }
      opts.on('--extract-msgs', 'Gets a file with all commit messages')  { gvar_opts << '--extract-msgs' }
      opts.on('--extract-macro-tokens', 'Gets a file with all macro tokens')  { gvar_opts << '--extract-macro-tokens' }
      opts.on('--word-freqs', 'Gets a file with word frequencies from a commit.msgs file')  { gvar_opts << '--word-freqs' }
      opts.on('--msgs-file ', 'A commit.msgs file')  { |o| cmd_opts[:msgs_file] = o }
      opts.on('--count-all-bugs ', 'Count all bugs')  { gvar_opts << '--count-all-bugs' }
      opts.on('--project-inf', 'Get project info (days)')  { gvar_opts << '--project-inf' }
    end.parse!(argv)
    if (gvar_opts & GVAR_OPTS).size > 1
      raise OptionParser::ParseError.new("#{gvar_opts.join(', ')} are mutually exclusive options")
    end
    [gvar_opts, cmd_opts]
  end
end
