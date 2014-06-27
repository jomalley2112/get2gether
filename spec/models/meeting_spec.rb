require 'spec_helper'

describe Meeting do

	let(:meeting) { FactoryGirl.build(:meeting)} #This is not valid at this point (needs a good organizer_id)

  describe "Associations" do
    it { should respond_to(:invites) }
    it { should respond_to(:people) }
  end
  
  describe "Attributes" do
  	it { should respond_to(:descr) }
  	it { should respond_to(:location) }
  	it { should respond_to(:in_start_time) }
    it { should respond_to(:start_time) }
    it { should respond_to(:duration) }
  end
  
  describe "Validations" do
    it "is invalid when organizer_id doesn't exist" do
    	meeting.organizer_id = 69696969
    	meeting.should_not be_valid
    	meeting.errors[:organizer].should_not be_blank
    end
    it "is invalid when start time is prior to current" do
    	meeting.in_start_time = (1.day.ago).to_s
    	meeting.should_not be_valid
    	meeting.errors[:start_time].should_not be_blank
    end
    it "is not valid when location is blank" do
    	meeting.location = ""
    	meeting.should_not be_valid
    	meeting.errors[:location].should_not be_blank
    end
  end

  describe "Filters" do
    describe "Before Validation" do
      pending 
    end
  end
  
  describe "Methods" do
    describe "respond" do
      it { should respond_to(:invite_people) }
      it { should respond_to(:pretty_start_time) }
      it { should respond_to(:pretty_end_time) }
    end
    describe "behave as expected" do
    	
      describe "#invite_people" do
      	before(:each) do
      		@people = []
      		(1..5).each do
      	  	@people << FactoryGirl.create(:person)
      	  end
      	end
        it "generates invites to itself for each person in the array passed to it" do
        	meeting.people.should eq []
        	meeting.invite_people(@people.map(&:id))
        	meeting.people.should eq(@people)
        end
        it "quietly handles any Person that doesn't yet exist and continues" do
        	meeting.invite_people([696969].push(@people.map(&:id)).push([6969696]).flatten)
        	meeting.people.should eq(@people)
        end
      end
      describe "pretty_start_time & pretty_end_time" do
      	it "returns the start time in an easy to read format" do
      		meeting.save
      		meeting.pretty_start_time.should eq meeting.start_time.strftime('%m/%d/%Y %I:%M:%S %p')
      	end
        it "returns the end time in an easy to read format" do
          meeting.save
          meeting.pretty_end_time.should eq meeting.end_time.strftime('%m/%d/%Y %I:%M:%S %p')
        end
      end
    end
  end

end
