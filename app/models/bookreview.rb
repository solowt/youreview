class Bookreview < ActiveRecord::Base
  belongs_to :user
  belongs_to :bookwork
  has_many :comments
  ratyrate_rateable "Helpfulness"
end
