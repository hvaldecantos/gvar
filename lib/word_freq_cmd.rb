require 'cmd'

class WordFreqCmd < Cmd
  COMMAND = "tr -c '[:alnum:]' '[\n*]' < %s | sort | uniq -c | sort -nr"
  def initialize cmd_runner
    super
  end

  def run opts = {}
    default opts
    filename = @cmd_runner.cwd + "/word.frqs"
    @file = File.open(filename, "w")
    @cmd = COMMAND % opts[:msgs_file]
    analyze_result

    @file.close unless @file == nil
    "Word frequencies file '#{filename}' saved."
  end

  private

    def analize line
      @file.write(line)
    end

    def default opts = {}
      opts[:msgs_file] ||= ""
      opts
    end
end
