require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "saved with a name, style and a brewery" do
    brewery = Brewery.create name:"test", year:1942
    beer = Beer.create name:"testbeer", style:"Weizen", brewery:brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
    it "not saved without a name" do
    brewery = Brewery.create name:"test", year:1942
    beer = Beer.create style:"Weizen", brewery:brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "not saved without a style" do
    brewery = Brewery.create name:"testbrewery", year:1942
    beer = Beer.create name:"testbeer", brewery:brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
