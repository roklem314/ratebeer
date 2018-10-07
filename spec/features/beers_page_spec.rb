require 'rails_helper'

include Helpers

describe "Beer page" do
  before :each do
    FactoryBot.create(:brewery)
    FactoryBot.create(:user)
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "a beer can be saved with valid input" do
      visit new_beer_path
      fill_in('beer[name]', with:'Keppana')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)
  end

  it "if name invalid, beer is not saved and a errormessage is given" do
      visit new_beer_path

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)

      expect(page).to have_content "Name can't be blank"
  end
end
