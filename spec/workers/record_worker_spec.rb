require 'spec_helper'

describe RecordWorker do
  describe "#perform" do
    it "copies the file to the destination" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      expect(worker).to receive(:start_record).and_return(tmp)
      destination = File.join(Settings[:recording][:target_directory], episode.filename)
      expect(FileUtils).to receive(:mv).with(tmp + '.mp3', destination)
      worker.perform(episode.id)
    end

    it "creates the destination directory if not exists" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      allow(worker).to receive(:start_record).and_return(tmp)
      destination = File.join(Settings[:recording][:target_directory], episode.filename)
      expect(FileUtils).to receive(:mkdir_p).with(Settings[:recording][:target_directory])
      expect(FileUtils).to receive(:mv).with(tmp + '.mp3', destination)
      worker.perform(episode.id)
    end

    it "sets the finshed_at" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      allow(worker).to receive(:start_record).and_return("")
      allow(worker).to receive(:system)
      allow(FileUtils).to receive(:mkdir_p)
      allow(FileUtils).to receive(:mv)
      worker.perform(episode.id)
      episode.reload
      expect(episode.finished_at).to_not be_nil
    end
  end

  describe "#start_record" do
    it "throws an error if streamripper is not installed" do
      episode = FactoryGirl.create(:episode, :scheduled)
      worker = RecordWorker.new
      expect(worker).to receive(:system).with('which streamripper > /dev/null 2>&1').and_return(false)
      expect{
        worker.start_record(episode)
      }.to raise_error
    end

    it "returns the output path" do
      episode = FactoryGirl.create(:episode, :scheduled)
      worker = RecordWorker.new
      allow(worker).to receive(:system).and_return(true)
      expect(worker.start_record(episode)).to_not eq("")
    end
  end
end