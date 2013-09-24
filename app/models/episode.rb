class Episode < ActiveRecord::Base
  belongs_to :program

  validates_presence_of :program
end
