class Task < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { todo: 1, doing: 2, done: 3 }
  validates :title, :content, :deadline, :status, presence: true
end
