class RecordWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(episode_id)
    episode = Episode.find(episode_id)
    current_path = start_record(episode) + '.mp3'
    destination = File.join(Settings[:recording][:target_directory], episode.filename)
    FileUtils.mkdir_p(Settings[:recording][:target_directory])
    FileUtils.mv(current_path, destination)
  end

  def start_record(episode)
    raise Exception.new('Streamripper is not callable.') unless system("which streamripper > /dev/null 2>&1")
    Dir::Tmpname.create 'meh' do |tmp|
      duration = episode.podcast.length * 60
      command = "`which streamripper` \"#{episode.podcast.stream.url}\" -s -A -a \"#{tmp}\" -l #{duration} --quiet"
      success = system(command)
      raise Exception('Streamripper could not be executed successful: ' + command) unless success
    end
  end
end