class User < ActiveRecord::Base
  validates :name, presence: true
  validates :sex, presence: true
  validates :phone_number, uniqueness: true
  validates :device_token, uniqueness: true
end
