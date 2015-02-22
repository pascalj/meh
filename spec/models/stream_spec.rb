require 'spec_helper'

describe Stream do

  it "must have a name" do
    stream = Stream.new
    expect(stream).to be_invalid
  end

  it "must have a valid URL" do
    stream = Stream.new(name: 'My Stream', url: 'totally-no-url')
    expect(stream).to be_invalid
  end
end
