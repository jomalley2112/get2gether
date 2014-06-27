require 'spec_helper'

describe "People" do
	
	subject { page }
	describe "GET /people" do
		before(:each) do
		  (1..55).each do
		  	FactoryGirl.create(:person)
		  end
		  sign_in_capybara(Person.create(last_name: "O'Malley", email: "myemail@mydomain.com", password: "password", password_confirmation: "password"))
		end
		describe "displays a paginated list of people" do
			it "defaults to 25 results per page" do
				visit people_path
      	page.first("table#top-level").first("tbody").all("tr.person").length.should eq 25
      end
      it "allows items per page to be passed in" do
      	visit people_path(:per_page => 15)
      	page.first("table#top-level").first("tbody").all("tr.person").length.should eq 15
      end
      it "allows items per page to be chosen", :js => true do
      	visit people_path
      	select("50", :from => "People per page:")
      	page.first("table#top-level").first("tbody").all("tr.person").length.should eq 50
      	page.first("select#per_page").value.should eq "50"
      end
      it "allows all items to be viewed on a single page", :js => true do
      	visit people_path
      	select("All", :from => "People per page:")
      	#binding.pry
      	page.first("table#top-level").first("tbody").all("tr.person").length.should eq Person.count
      	page.first("select#per_page").value.should eq "All"
      end
		end
		describe "Search" do
		  pending
		end
	end

	describe "Authentication" do
		describe "Not signed in" do
		  it "redirects to the sign-in page with message when not signed in" do
				visit(root_path)
				page.should have_content("You need to sign in")
				page.current_path.should eq new_person_session_path
			end
		end
		describe "sign Up" do
			it "directs to the root with success message" do
				#binding.pry
				visit(new_person_registration_path)
				fill_in("First name", with: Faker::Name.first_name)
				fill_in("Last name", with: Faker::Name.last_name)
				fill_in("Email", with: Faker::Internet.email)
				fill_in("Password", with: "password")
				fill_in("Confirm Password", with: "password")
				click_button("Sign up")
				page.current_path.should eq root_path
				page.should have_content("You have signed up")
			end
		end
		describe "sign in" do
			it "directs to the root with a success message" do
				visit root_path
				sign_in_capybara(Person.create(last_name: "O'Malley", email: "myemail@mydomain.com", password: "password", password_confirmation: "password"))	
				page.should have_content("Signed in successfully")
			end
			
		end
		describe "sign out" do
			it "directs to the sign-in page and displays link to sign up" do
				sign_in_capybara(Person.create(last_name: "O'Malley", email: "myemail@mydomain.com", password: "password", password_confirmation: "password"))
				click_link("Sign out")
				page.current_path.should eq new_person_session_path
				page.should have_link("Sign Up!", href: new_person_registration_path)
			end
		end	  
	end	

end
