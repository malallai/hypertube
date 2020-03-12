class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates_presence_of :comment
  validates_presence_of :user
  validates_presence_of :movie
end
