require 'spec_helper'

describe "GVarCLI class" do
  it "prints directories where C src is found" do
    argv = ['--find-src-dirs']
    gvar_opts = ['--find-src-dirs']
    cmd_opts = {}

    expect(GVarCLI).to receive(:parse).once.with(argv).and_return([gvar_opts, cmd_opts])
    GVarCLI.run(argv)
  end

  it "instanciates the right command object base on gvar_opts" do
    [['--find-src-dirs'], FindCmd, ['--list-shas'], ListShaCmd].each_slice(2) do |gvar_opts, cmd_class|
      expect(GVarCLI.instanciate_cmd_object gvar_opts).to be_a(cmd_class)
    end
  end

  it "parses arguments given to gvar command" do
    [['--list-shas'], [['--list-shas'], {}],
     ['--find-src-dirs'], [['--find-src-dirs'], {}]].each_slice(2) do |argv, result|
      expect(GVarCLI.parse argv).to eq(result)
    end
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
