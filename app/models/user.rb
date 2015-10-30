class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :name, presence: true
  validates :sex, presence: true
  validates :phone_number, uniqueness: true, presence: true
  validates :device_token, uniqueness: true, presence: true
end
