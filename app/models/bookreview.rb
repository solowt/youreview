class Bookreview < ActiveRecord::Base
  belongs_to :user
  belongs_to :work
  has_many :comments
  ratyrate_rateable "Helpfulness"
end
