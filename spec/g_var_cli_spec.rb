require 'spec_helper'

describe "GVarCLI class" do
  it "prints directories where C src is found" do
    gvar_opts = ["--find-src-dirs"]
    expect_any_instance_of(FindCmd).to receive(:dirs).once
    GVarCLI.run(gvar_opts)
  end
end
