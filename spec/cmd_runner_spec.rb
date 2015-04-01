require 'spec_helper'
require 'open3'

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

  it "raises an exception when the working directory is not valid" do
    directory = 'an_invalid_directory'
    cr = CmdRunner.new(directory)
    expect{cr.run('ls')}.to raise_error(Errno::ENOENT, /No such file or directory/)
  end

  it "has the same working directory before and after invoking run method" do
    cwd = Dir.getwd
    directory = Dir.getwd + '/testrepo/curl'
    CmdRunner.new(directory).run('invalid_command') rescue
    expect(cwd).to eq(Dir.getwd)
  end

  it "runs the command with open3" do
    directory = Dir.getwd + '/testrepo/curl'
    cr = CmdRunner.new(directory)
    cmd = 'ls'
    expect(Open3).to receive(:popen3).with(cmd).once
    cr.run(cmd)
  end

  it "raises an exception when the command passed is not valid" do
    directory = Dir.getwd + '/testrepo/curl'
    cmd = 'invalid_command'
    cr = CmdRunner.new(directory)
    expect{cr.run(cmd)}.to raise_error(StandardError, "No command '#{cmd}' found\n")
  end

  it "runs a command and return the stdout" do
    directory = Dir.getwd + '/testrepo/curl'
    cr = CmdRunner.new(directory)
    expect(cr.run 'pwd').to eq(directory + "\n")
  end
end
