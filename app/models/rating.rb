class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user, dependent: :destroy

  def to_s
    "#{beer.name}, #{score}"
  end
end
