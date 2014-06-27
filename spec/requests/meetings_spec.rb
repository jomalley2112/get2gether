require 'spec_helper'

describe "Meetings", :js => false do
	
	subject { page }
  
  describe "GET /meetings" do
  	before(:each) do
      person = FactoryGirl.create(:person)
      sign_in_capybara(person)
  	  (1..5).each do
  	  	FactoryGirl.create(:meeting)
  	  end
  	  visit meetings_path
  	end
	
	  it {should have_content("Meetings")}
    
  end

  describe "meetings/index" do

    describe "pagination" do
    	before(:each) do
    		person = FactoryGirl.create(:person)
    		sign_in_capybara(person)
    		(1..100).each do
    	  	FactoryGirl.create(:meeting, :organizer => person)
    	  end
    	end
      it "defaults to 25 results per page" do
      	visit root_path
        #page.first("table#top-level").first("tbody").all("tr[id!='pagination-row']").length.should eq 25
        page.all(:xpath, "//table[@id='top-level']/tbody/tr[not(@id = 'pagination-row')]")
          .length.should eq 25
        page.first("select#per_page").value.should eq "25"
      end
      it "allows items per page to be passed in" do
      	visit root_path(:per_page => 15)
      	#page.first("table#top-level").first("tbody").all("tr").length.should eq 15
        page.all(:xpath, "//table[@id='top-level']/tbody/tr[not(@id = 'pagination-row')]")
          .length.should eq 15
        page.first("select#per_page").value.should eq "15"
      end
      it "allows items per page to be chosen", :js => true do
        visit root_path
        select("50", :from => "Meetings per page:")
        #page.first("table#top-level").first("tbody").all("tr").length.should eq 50
        page.all(:xpath, "//table[@id='top-level']/tbody/tr[not(@id = 'pagination-row')]")
          .length.should eq 50
        page.first("select#per_page").value.should eq "50"
      end
      it "allows All items per page to be chosen", :js => true do
        visit root_path
        select("All", :from => "Meetings per page:")
        #page.first("table#top-level").first("tbody").all("tr").length.should eq Meeting.count
        page.all(:xpath, "//table[@id='top-level']/tbody/tr[not(@id = 'pagination-row')]")
          .length.should eq Meeting.count
        page.first("select#per_page").value.should eq "All"
      end
    end
  end

  describe "Create new Meeting" do
    before(:each) do
    	person = FactoryGirl.create(:person)
    	sign_in_capybara(person)
    	#binding.pry
    	visit new_meeting_path
		end
    #let(:person) { FactoryGirl.create(:person) }
    
    it { should have_selector("textarea#meeting_descr") }
    it { should have_selector("input#meeting_in_start_time") }
    it { should have_selector("input#meeting_duration") }
    it { should have_selector("input#meeting_location") }
    it { should have_selector("input#save_meeting_btn") }

    describe "Save button only enabled after required fields are populated" do
      it "is disabled when location hasn't been entered", :js => true do
      	#binding.pry
        fill_in("Location", :with => "")
        page.first("input[value='Save']").disabled?.should eq true
      end
      it "is not disabled when location has been entered", :js => true do
      	fill_in("Location", :with => "Any Location")
      	page.first("input[value='Save']").disabled?.should eq false
      end
    end

    describe "enter values and save" do
      let(:start_time) {Time.now + 1.day}
      before(:each) do
        fill_in("Description", :with => "My new meeting.")
        fill_in("Start Date/Time", :with => Meeting.get_pretty_date_time(start_time))
        fill_in("Duration", :with => "45")
        fill_in("Location", :with => "Conference Room")
        click_button("Save")
      end

      it "redirects to the edit page for the new Meeting", :js => true do
      	page.first("textarea#meeting_descr").value.should eq "My new meeting."
        page.first("input#meeting_in_start_time").value.should eq Meeting.get_pretty_date_time(start_time)
      	page.first("input#meeting_duration").value.should eq "45"
      	page.first("input#meeting_location").value.should eq "Conference Room"
        page.should have_content("Created meeting successfully.")
      end

    end
  end

  

  describe "assign invites to meeting" do
    pending
  	# before(:each) do
  	# 	@person = FactoryGirl.create(:person)
  	# 	sign_in_capybara(@person)
  	# 	(1..30).each do
  	#   	FactoryGirl.create(:person, :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
  	#   end
  	# end
  	# let(:meeting) { FactoryGirl.create(:meeting, :organizer => @person) }
  	# describe "shows the people so we can chose who to invite" do
  	# 	it "paginates them at 15 per page" do
	  # 	  visit edit_meeting_path(meeting)
	  #     page.first("table#people").first("tbody").all("tr").length.should eq 15
	  # 	end    
  	# end
  	
  end
end
