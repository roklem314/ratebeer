module RatingAverage
  include ActionView::Helpers::TextHelper
  extend ActiveSupport::Concern

  def average_rating
    scores = ratings.map(&:score)
    average = scores.reduce(:+).to_f / scores.size
    "#{pluralize(ratings.count, 'rating')}, average #{average}"
  end
end
