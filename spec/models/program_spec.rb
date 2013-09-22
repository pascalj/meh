require 'spec_helper'

describe Program do

  it "requires a name" do
    program = Program.new
    program.valid?.should == false
  end

  it "requires a length > 0" do
    program = Program.new(name: 'my name')
    program.should be_invalid
    program.errors[:length].should_not be_empty
  end

  it "must have a stream" do
    program = Program.new(name: 'my name', length: 15)
    program.should be_invalid
    program.errors[:stream].should_not be_empty
  end
end
