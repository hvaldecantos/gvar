require 'cmd'
require 'find_gv_cmd'
require 'Global'

class GVStorer
  MongoMapper.database="gvar01"

  def run opts = {}
    fgv = FindGVCmd.new(CmdRunner.new(Dir.getwd + '/testrepo/curl'))
    gvs = fgv.run({:dirs => ['src'], :sha => '787c2ae91b1f172ce9fdd2b6613c6217c00a85b3'})

    gvs.each do |gv|
      Global.new(gv[:name], gv[:line_num]).save
    end
    "Variable names stored in db"
  end
end
