class Episode < ActiveRecord::Base
  belongs_to :podcast

  validates_presence_of :podcast
end
