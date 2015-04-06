require 'spec_helper'

describe "ListShaCmd class" do
  it "returns a list of sha-1 commits from a given option (tag1..tag2)" do
    cr = double(CmdRunner)
    list_sha = ListShaCmd.new(cr)
    expect(list_sha).to receive(:analyze_result).once
    list_sha.run
  end
end
