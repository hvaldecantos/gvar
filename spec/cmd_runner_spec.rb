require 'spec_helper'

describe "CmdRunner class" do
  it "has a wd as the current working directory" do
    cwd = Dir.getwd
    expect(CmdRunner.new.wd).to eq(cwd)
  end

  it "receives a directory when creating an object" do
    directory = Dir.getwd + '/testrepo/curl'
    cr = CmdRunner.new(directory)
    expect(cr).to have_attributes(wd: directory)
  end
end
