# $ bundle exec rake db:reset
# $ bundle exec rake db:populate
# $ bundle exec rake test:prepare

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_meetings
    make_people
  end
end    

def make_meetings
  admin = Person.create!(
           last_name: "O'Malley",
           email: "example_9@example.com",
           password: "password",
           password_confirmation: "password")
  100.times do |n|
    descr  = Faker::Company.catch_phrase
    location = "Meeting Room ##{n+1}"
    start_time = Faker::Business.credit_card_expiry_date 
    duration = "#{5 * n}"
    Meeting.create!(descr: descr, location: location, start_time: start_time, duration: duration, organizer: admin)
  end
end

def make_people
  200.times do |n|
    last_name = Faker::Name.last_name
    first_name = Faker::Name.first_name
    email = Faker::Internet.email
    password = "password"
    Person.create!(last_name: last_name, first_name: first_name, password: password, password_confirmation: password, email: email)
  end
end