class Task < ApplicationRecord
  enum status: { todo: 0, doing: 1, done: 2 }
  validates :title, :content, :deadline, :user_id, :status, presence: true
end
