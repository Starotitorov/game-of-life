require 'rails_helper'
require 'spec_helper'

describe "Browser game pages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  describe "Create new game page" do
    before { visit new_browser_game_path }
    describe "with invalid information" do
      before { fill_in "Name", with: "game" * 20 }
      it "should not create a browser_game" do
        expect { click_button "Create new game" }.not_to change(BrowserGame, :count)
      end
    end
    describe "with valid information" do
      it "should create a browser_game" do
        expect { click_button "Create new game" }.to change(BrowserGame, :count).by(1)
      end
    end
  end
  describe "Edit page" do
    let(:browser_game) { FactoryGirl.create(:browser_game, user: user) }
    before { visit edit_browser_game_path(browser_game) }
    it { should have_title(browser_game.name) }
  end
  describe "Delete browser game" do
    before { FactoryGirl.create(:browser_game, user: user) }
    describe "as correct user" do
      before do
        sign_in user
        visit user_path(user)
      end
      it "should delete the browser game" do
        expect { click_link "Delete" }.to change(BrowserGame, :count).by(-1)
      end
    end
  end
end
