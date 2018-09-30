class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true,
                       length: { minimum: 3 }
  validates :password, format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{4,}\z/ }

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :clubs, through: :membership

  def to_s
    "#{username}"
  end
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
end
