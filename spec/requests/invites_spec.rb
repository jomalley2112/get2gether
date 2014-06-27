require 'spec_helper'

describe "Invites" do
	before(:each) do
		person = FactoryGirl.create(:person)
    sign_in_capybara(person)
	  @meeting = FactoryGirl.create(:meeting)
	end
	#let(:meeting) { FactoryGirl.create(:meeting, attributes) }
  describe "GET meeting/id/invites" do
  	describe "Lists all people and checks the ones currently invited" do
  	  before(:each) do
  			(1..15).each do |i|
  				person = FactoryGirl.create(:person)
  				FactoryGirl.create(:invite, :meeting => @meeting, :person => person) unless i.odd?
  			end
		  end
	    it "displays all people", :js =>  false do
	    	visit(meeting_invites_path(:meeting_id => @meeting.id))	
	    	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 17
	    end
	    it "checks off the people invited to the parent meeting" do
	    	visit(meeting_invites_path(:meeting_id => @meeting.id))
	    	#binding.pry
	    	page.first("table.outer-list").first("tbody").all("input[type='checkbox'][checked='checked']").length.should eq 7
	    end
  	end
  	
    describe "displays a paginated list of people" do
    	before(:each) do
  			(1..30).each do |i|
  				person = FactoryGirl.create(:person)
  				#FactoryGirl.create(:invite, :meeting => @meeting, :person => person) unless i.odd?
  			end
		  end
		  describe "items per page" do
		    it "defaults to 25 results per page", :js => false do
					visit meeting_invites_path(:meeting_id => @meeting.id)
					page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 25
	      end
	      it "allows items per page to be passed in" do
	      	visit meeting_invites_path(:meeting_id => @meeting.id, :per_page => 15)
	      	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 15
	      end
	      it "allows items per page to be chosen", :js => true do
	      	visit meeting_invites_path(:meeting_id => @meeting.id)
	      	select("20", :from => "People per page:")
	      	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 20
	      	page.first("select#per_page").value.should eq "20"
	      end
	      it "allows all items to be viewed on a single page", :js => true do
	      	visit meeting_invites_path(:meeting_id => @meeting.id)
	      	select("All", :from => "People per page:")
	      	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq Person.count
	      	page.first("select#per_page").value.should eq "All"
	      end
		  end
			describe "page navigation" do
			  it "displays a second page of items when 2 is clicked", :js => true do
			  	visit meeting_invites_path(:meeting_id => @meeting.id, :per_page => "10")
			  	cb1_id = page.first("table.outer-list").first("tbody").first("input[type='checkbox']")['id']
			  	click_link("2")
			  	sleep 1
			  	cb2_id = page.first("table.outer-list").first("tbody").first("input[type='checkbox']")['id']
			  	cb2_id.should_not eq cb1_id
			  end
			end
		end
		describe "Search" do
			before(:each) do
  			(1..10).each do |i|
  				person = FactoryGirl.create(:person)
  			end
  			FactoryGirl.create(:person, :first_name => "Arnold")
  			FactoryGirl.create(:person, :last_name => "Arnold")
		  end
		  it "displays only the people whose first or last names match the search criteria", :js => true do
		  	visit meeting_invites_path(:meeting_id => @meeting.id)
		  	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 14
		  	fill_in("search", :with => "Arnold")
		  	find('#search').native.send_keys(:return)
		  	sleep 1
		  	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 2
		  	page.first("i#clear-search").click
		  	sleep 1
		  	page.first("table.outer-list").first("tbody").all("input[type='checkbox']").length.should eq 14
		  end
		end
		
		describe "Invite people", :js => true do
			before(:each) do
	  	  (1..10).each do |i|
  				person = FactoryGirl.create(:person)
  			end
	  	end
		  
		  describe "Meeting that hasn't transpired yet" do
		  	it "creates and saves a new Invite" do
		    	visit meeting_invites_path(:meeting_id => @meeting.id, :per_page => "10") 
		    	expect {
		    		first("input[type='checkbox']").set(true)	
		    		sleep 1
		    	}.to change(Invite, :count).by(1)
		    end
		  end
		  
		  describe "Meeting that has already transpired" do
		    let(:meeting) { FactoryGirl.build(:meeting, in_start_time: (Time.now - 1.day).to_s, 
		    																		:duration => 15, :end_time => Time.now) }
		    before(:each) do
		      meeting.save(validate: false)
		    end
		    it "does not allow creation of a new Invite" do
		    	visit meeting_invites_path(:meeting_id => meeting.id, :per_page => "10")
		    	expect{
		    		first("input[type='checkbox']").set(true)	
		    	}.to change(Invite, :count).by(0)
		    end
		    it "unchecks the person's checkbox checked by the user" do
		    	visit meeting_invites_path(:meeting_id => meeting.id, :per_page => "10")
		    	first("input[type='checkbox']").set(true)	
		    	sleep 1
		    	first("input[type='checkbox']").checked?.should eq false
		    	#This next line is to click off the modal to close it
		    	# We should do something better like have a close buton on the modal itself
		    	page.execute_script('$(document.elementFromPoint(50, 350)).click();')
		    end
		  end
		
		end
  end
end
