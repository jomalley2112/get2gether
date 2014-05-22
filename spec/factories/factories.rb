FactoryGirl.define do
  
	factory :meeting do
	  sequence(:descr) { |n| "Meeting ##{n}" } 
	  association :organizer, factory: :person
	  sequence(:location ) { |n| "Room ##{n}" }
	  # start_time "#{Time.now}"
	  # end_time "#{Time.now}"
	  # location "MyString"

	end

	factory :person do
		sequence(:email) { |n| "email_#{n}@mydomain.com" }
		password "password"
		password_confirmation "password"
		last_name Faker::Name.last_name
	end

end