class BrowserGame < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true 
  validates :name, presence: true, length: { maximum: 50 }
  validates :amount_of_steps, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, length: { is: 100 }
  validate :content_of_status
  def content_of_status
    if status == nil
      return
    end
    status.chars.each do |s|
      if s != '0' && s != '1' 
        errors.add(:status, "is invalid")
        return
      end
    end
  end
end
