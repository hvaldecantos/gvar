require 'spec_helper'

describe "FindCmd class" do
  it "returns a hash with the directory that contains .c and .h files" do
    cr = double(CmdRunner)
    finder = FindCmd.new(cr)
    expect(finder).to receive(:analyze_result).once
    finder.dirs
  end
end
