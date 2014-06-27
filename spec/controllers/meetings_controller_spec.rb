require 'spec_helper'

describe MeetingsController do
  let(:valid_params) { {id: @meeting.id, meeting: {location: "Conf Room", duration: 60}} }
	let(:person) { FactoryGirl.create(:person)}
  before(:each) do
    sign_in person
  end

  describe "GET index" do
    before(:each) do
      (1..15).each do
        FactoryGirl.create(:meeting_w_time, in_start_time: ((Time.now + 1.day) + rand(1..50).days).to_s)
      end
    end
    it "should sort by start time by default" do
      get :index #, { :page => "1", :per_page => "100" }
      #binding.pry
      assigns(:meetings)
        .should eq assigns(:meetings).sort_by { |m| m.start_time }.reverse
    end
    
  end
	describe "protected #flash_alert in ApplicationController" do
		let(:invalid_params) { {:meeting => {:location => ""}} }
		it "sets a flash error when object passed in is not valid" do
			post :create, invalid_params
			flash[:error].should eq "Unable to create Meeting for the following 1 reason:"
			#TODO: The second part of the message is being generated via a partial
			# need to see how to test that
		end
	end

	describe "PUT update" do
    before(:each) do
      person = FactoryGirl.create(:person)
      sign_in_capybara(person)
      @meeting = FactoryGirl.create(:meeting)
    end
    describe "Valid Params" do
      
      it "redirects to the edit page with a success message" do
        put :update, valid_params
        response.should redirect_to(edit_meeting_url(@meeting))
        flash[:success].should eq "Updated meeting successfully"
      end
    end
    describe "Invalid Params" do
      let(:invalid_params) { {id: @meeting.id, meeting: {location: ""}} }
      it "re-renders the edit page with a flash alert" do
        put :update, invalid_params
        #response.should render_template(edit_meeting_url(@meeting))
        flash[:error].should eq "Unable to update Meeting for the following 1 reason:"
      end
    end
  end
end