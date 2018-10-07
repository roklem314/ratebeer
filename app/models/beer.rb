class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  include RatingAverage

  validates :name, presence: true
  validates :style, presence: true

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{name} #{brewery.name}"
  end
end
