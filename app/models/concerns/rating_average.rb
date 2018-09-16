module RatingAverage
    extend ActiveSupport::Concern

    def average_rating
        return ratings.average(:score).to_s
    end
end
