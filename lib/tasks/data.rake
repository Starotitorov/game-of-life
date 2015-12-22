namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Artem",
                email: "starotitorov1997@gmail.com",
                avatar: File.new(Rails.root + 'spec/fixtures/3.png'),
                password: "artem",
                password_confirmation: "artem",
                admin: true)
    array_of_files_with_avatars = ["1.jpg", "2.jpg", "3.png", "4.jpg", "5.jpg"]
    4.times do |n|
      name  = Faker::Name.name
      email = "user#{n+1}@example.org"
      password  = "password"
      path_to_file_with_avatar = Rails.root + "spec/fixtures/#{array_of_files_with_avatars.sample}"
      User.create!(name: name, email: email,
                  avatar: File.new(path_to_file_with_avatar),
                  password: password,
                  password_confirmation: password)
    end
    users = User.all
    40.times do |n|
      name = "game#{n+1}"
      status = ""
      100.times do
        status += ['0', '1'].sample
      end
      users.each { |user| user.browser_games.create!(name: name, status: status) }
    end
  end
end
