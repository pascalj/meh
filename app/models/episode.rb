class Episode < ActiveRecord::Base
  belongs_to :podcast

  validates_presence_of :podcast

  scope :scheduled, -> { where("scheduled_at > ?", Time.now) }
  scope :finished, -> { where("finished_at IS NOT NULL") }
  scope :unfinished, -> { where("finished_at IS NULL") }


  def schedule
    scheduled_at = Time.zone.now
    # next day_of_week
    scheduled_at += ((self.podcast.day_of_week - scheduled_at.wday) % 7).days
    scheduled_at = scheduled_at.change(hour: self.podcast.start_at.hour, min: self.podcast.start_at.min, second: 0)
    if scheduled_at < Time.zone.now
      scheduled_at += 7.days
    end
    self.scheduled_at = scheduled_at
    self.save
    RecordWorker.perform_at(self.scheduled_at.utc, self.id)
  end

  def self.schedule_for_podcasts(podcasts)
    podcasts.each do |podcast|
      unless self.scheduled.unfinished.where(podcast: podcast).first
        episode = self.new(podcast: podcast)
        episode.schedule
      end
    end
  end

  def filename
    "#{self.podcast.save_name}-#{self.scheduled_at.strftime('%Y-%m-%d')}.mp3"
  end

  def path_and_filename
    File.join(Settings[:recording][:target_directory], self.filename)
  end
end
