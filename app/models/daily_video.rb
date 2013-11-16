class DailyVideo < ActiveRecord::Base
  validate :title, presence: true, length: { in: 10..50 }, uniqueness: true
  validate :date, presence: true, uniqueness: true, on: :save
end
