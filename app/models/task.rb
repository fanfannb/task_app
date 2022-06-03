class Task < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { todo: 0, doing: 1, done: 2 }
  validates :title, :content, :deadline, :status, presence: true
end
