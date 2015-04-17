require 'open3'

class CmdRunner
  attr_reader :wd

  def initialize wd = Dir.getwd
    @wd = wd
  end

  def run cmd
    cwd = Dir.getwd
    Dir.chdir @wd
    begin
      Open3.popen3(cmd) do |i, o, e, t|
        result = o.read
        error = e.read
        raise StandardError, error unless (t.value.success? or error.empty?)
        result
      end
    rescue Errno::ENOENT
      raise StandardError, "No command '#{cmd}' found\n"
    ensure
      Dir.chdir cwd
    end
  end
end
