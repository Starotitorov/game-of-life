FactoryGirl.define do  
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "password"
    password_confirmation "password"
    factory :admin do
      admin true
    end
  end
  factory :browser_game do
    name "game"
    status '1' * 100
    amount_of_steps 0
    user
  end
end
