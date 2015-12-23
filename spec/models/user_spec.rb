require 'rails_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "password",
    password_confirmation: "password") }
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:browser_games) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should be_valid }
  it { should_not be_admin}

  describe "with admin attribute set to true" do
    before do
      @user.save
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "Example User" * 10 }
    it { should_not be_valid }
  end

  describe "when email format is not valid" do
    it "should not be valid" do
      addresses = ["user@foo,com", "user_at_foo.org",
                  "example.user@foo.", "foo@bar_baz.com", "foo@bar+baz.com", "foo@bar..com"]
      addresses.each do |invalid_addr|
        @user.email = invalid_addr
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = ["user@foo.COM",  "A_US-ER@f.b.org", "frst.lst@foo.jp",
                  "a+b@baz.cn"]
      addresses.each do |valid_addr|
        @user.email = valid_addr
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is in database" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                      password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify "should be false" do
        expect(user_for_invalid_password).to eq false
      end
    end
  end
  
  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end
  describe "browser_game associations" do
    before { @user.save }
    let!(:older_browser_game) do
      FactoryGirl.create(:browser_game, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_browser_game) do
      FactoryGirl.create(:browser_game, user: @user, created_at: 1.hour.ago)
    end
    it "should have right order of browser_games" do
      expect(@user.browser_games.to_a).to eq [newer_browser_game, older_browser_game]
    end
    it "should destroy associated browser_games" do
      browser_games = @user.browser_games.to_a
      @user.destroy
      expect(browser_games).not_to be_empty
      browser_games.each do |game|
        expect(BrowserGame.where(id: game.id)).to be_empty
      end
    end
  end
end
