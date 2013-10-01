class Episode < ActiveRecord::Base
  extend FriendlyId

  belongs_to :podcast

  validates_presence_of :podcast

  scope :scheduled, -> { where("scheduled_at > ?", Time.now) }
  scope :finished, -> { where("finished_at IS NOT NULL") }
  scope :unfinished, -> { where("finished_at IS NULL") }

  friendly_id :date_slug, use: :slugged


  def schedule
    return if Sidekiq::Status.queued?(self.job_id)
    scheduled_at = Time.zone.now
    # next day_of_week
    scheduled_at += ((self.podcast.day_of_week - scheduled_at.wday) % 7).days
    scheduled_at = scheduled_at.change(hour: self.podcast.start_at.hour, min: self.podcast.start_at.min, second: 0)
    if scheduled_at < Time.zone.now
      scheduled_at += 7.days
    end
    self.scheduled_at = scheduled_at
    self.job_id = RecordWorker.perform_at(self.scheduled_at.utc, self.id)
    self.save
  end

  def self.schedule_for_podcasts(podcasts)
    podcasts.each do |podcast|
      unless self.scheduled.unfinished.where(podcast: podcast).first
        episode = self.create(podcast: podcast)
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

  def date_slug
    if self.scheduled_at
      "#{self.scheduled_at.strftime('%Y-%m-%d')}-#{self.podcast.name}"
    else
      nil
    end
  end
end
