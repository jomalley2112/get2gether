FactoryGirl.define do
  
	factory :meeting do
	  sequence(:descr) { |n| "Meeting ##{n}" } 
	  association :organizer, factory: :person
	  sequence(:location ) { |n| "Room ##{n}" }
	  # start_time "#{Time.now}"
	  # end_time "#{Time.now}"
	  # location "MyString"
	  factory :meeting_w_time do
	  	start_time (Time.now + 1.day)
	  end
	end

	factory :person do
		sequence(:email) { |n| "email_#{n}@mydomain.com" }
		password "password"
		password_confirmation "password"
		sequence(:last_name) { |n| "SMith ##{n}" } #Faker::Name.last_name
	end

	factory :invite do
		meeting
		person
	end
end