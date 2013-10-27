class Podcast < ActiveRecord::Base
  extend FriendlyId

  belongs_to :stream
  has_many :episodes

  image_accessor :image

  friendly_id :name, use: :slugged

  validates_presence_of :name, :stream
  validates :length, numericality: { greater_than: 0 }

  scope :record_next, -> { where("day_of_week = ? OR day_of_week = ?", Time.now.wday, Time.now.tomorrow.wday) }

  def self.schedule_recording
    Episode.schedule_for_podcasts(Podcast.all)
  end

  def save_name
    self.name.tr('^A-Za-z', '').downcase
  end
end
