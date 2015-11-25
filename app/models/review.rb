class Review < ActiveRecord::Base
  # NHO: feeling like you may want this model to have a polymorphic relationship with the other works, i.e. as reviewable
  # NHO: then again you could also break all the seperate works, to have seperate reviews, just would be consistent.
  belongs_to :user
  belongs_to :work
  has_many :comments
  # NHO belongs_to :moviework?
  ratyrate_rateable "Helpfulness"
end
