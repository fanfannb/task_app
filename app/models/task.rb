class Task < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { 未対応: 1, 対応中: 2, 完了: 3 }
  validates :title, :content, :deadline, :status, presence: true
end
