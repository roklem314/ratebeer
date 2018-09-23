class User < ApplicationRecord
  include RatingAverage
  
  has_many :ratings
  has_many :beers, through: :ratings

  def to_s
    "#{username}"
end
end
