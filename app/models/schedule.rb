class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :start_time, :end_time, presence: true, availability: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after the start date")
    end
 end

end
