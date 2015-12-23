require 'rails_helper'
require 'spec_helper'

describe "User pages" do
  subject { page }
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }
    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }
      it { should have_selector('div.pagination') }
        it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
    describe "delete users" do
      it { should_not have_link('delete') }
      describe "when the user is an admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
  describe "Signup page" do
    before { visit signup_path }
    let(:submit) { "Create account" }
    it { should have_title("The Game of Life | Sign up") }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }
        it { should have_title(user.name) }
        it { should have_link("Sign out") }
        it { should have_selector("div.alert.alert-success", text: "Welcome") }
      end
    end
  end

  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }
    let!(:browser_game1) { FactoryGirl.create(:browser_game, user: user, name: "game1") }
    let!(:browser_game2) { FactoryGirl.create(:browser_game, user: user, name: "game2") }
    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_title("The Game of Life | #{user.name}") }
    it { should have_content(user.name) }
    it { should have_link('Play') }
    it { should have_link('Delete') }
    it { should have_link('Create new game', href: new_browser_game_path) }
    describe "browser games" do
      it { should have_content(browser_game1.name) }
      it { should have_content(browser_game2.name) }
      it { should have_content(user.browser_games.count) }
    end
    describe "another user can not play and delete games" do
      before do 
        sign_in another_user
        visit user_path(user)
      end
      it { should_not have_link('Create new game', href: new_browser_game_path) }
      it { should_not have_link('Play') }
      it { should_not have_link('Delete') }
    end
  end
  describe "Edit page" do
    let(:user) { FactoryGirl.create :user }
    before do
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
      visit edit_user_path(user)
    end
    it { should have_title("Edit user") }
    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content("error") }
    end
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector("div.alert.alert-success") }
      it { should have_link("Sign out", href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end
