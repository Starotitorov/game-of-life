require 'rails_helper'
require 'spec_helper'

describe BrowserGame do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @browser_game = user.browser_games.build(name: "game", status: "1" * 100, amount_of_steps: 0)
  end
  subject { @browser_game }
  it { should respond_to(:name) }
  it { should respond_to(:status) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  specify { expect(@browser_game.user).to eq user}
  it { should be_valid }
  describe "when user_id is not present" do
    before { @browser_game.user_id = nil }
    it { should_not be_valid }
  end
  describe "when name is too long" do
    before {@browser_game.name = "game" * 20}
    it { should_not be_valid }
  end
  describe "when status is too long" do
    before { @browser_game.status = "1" * 101 }
    it { should_not be_valid }
  end
  describe "when status is invalid" do
    before { @browser_game.status = "s" * 100 }
    it { should_not be_valid }
  end
  describe "when amount_of_steps is invalid" do
    before { @browser_game.amount_of_steps = -1 }
    it { should_not be_valid }
  end
  describe "when amount_of_steps is valid" do
    before { @browser_game.amount_of_steps = 2 }
    it { should be_valid }
  end
end
