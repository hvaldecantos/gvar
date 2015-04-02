require 'spec_helper'

describe "GVarCLI class" do
  it "prints directories where C src is found" do
    [['--find-src-dirs'], ['--find-src-dirs'], FindCmd, :dirs, 
     ['--list-shas'], ['--list-shas'], ListShaCmd, :shas].each_slice(4) do |argv, gvar_opts, cmd_class, method|
      expect(GVarCLI).to receive(:parse).once.with(argv).and_return(gvar_opts)
      expect_any_instance_of(cmd_class).to receive(method).once
      GVarCLI.run(argv)
    end
  end

  it "parses arguments given to gvar command" do
    argv = ['--find-src-dirs']
    argv = ['--list-shas']
    expect(GVarCLI.parse argv).to eq(['--list-shas'])
  end

  it "raises an exception when an option is not understood" do
    msg = /invalid option: --not-understandable/
    expect{ GVarCLI.parse ["--not-understandable"] }.to raise_error(OptionParser::InvalidOption, msg)
  end

  it "raises an exception if passing mutually exclusive params" do
    msg = /--find-src-dirs, --list-shas are mutually exclusive options/
    expect{ GVarCLI.parse ['--find-src-dirs', '--list-shas'] }.to raise_error(OptionParser::ParseError, msg)
  end
end
