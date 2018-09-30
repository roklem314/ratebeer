class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, length: { minimum: 1 }
  validates :style, presence: true

  def average
    if ratings.count.zero?
      return 0
    end

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{brewery.name}: #{name}"
  end
end
