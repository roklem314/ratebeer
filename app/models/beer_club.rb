class BeerClub < ApplicationRecord
  has_many :members, -> { distinct }, through: :membership, source: :user

  def to_s
    "#{name}"
  end
end
