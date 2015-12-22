require 'rails_helper'

describe "Pages" do
  subject { page }
  describe "Home page" do
    before { visit root_path }
    it { should have_title("The Game of Life") }
    it { should_not have_title("| Home") }
  end
  describe "Help page" do
    before { visit help_path }
    it { should have_title("The Game of Life | Help") }
  end
  describe "About page" do
    before { visit about_path }
    it { should have_title("The Game of Life | About") }
  end
end
