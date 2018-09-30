require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  it "is not saved with a password consisting only of letters" do
    user = User.create username:"Pekka", password:"salasana", password_confirmation:"salasana"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that's too short" do
    user = User.create username:"Pekka", password:"salasana", password_confirmation:"salasana"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  it "is the one with highest rating if several rated" do
    beer1 = FactoryBot.create(:beer)
    beer2 = FactoryBot.create(:beer)
    beer3 = FactoryBot.create(:beer)
    rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
    rating2 = FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
    rating3 = FactoryBot.create(:rating, score: 9, beer: beer3, user: user)

    expect(user.favorite_beer).to eq(beer2)
  end

  describe "with a proper password" do
    let(:user){ User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1" }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "has method for determining the favorite_beer" do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:favorite_beer)
    end
    describe "favorite beer" do
      let(:user){ FactoryBot.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
        expect(user.favorite_beer).to eq(nil)
    end
    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end
    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
