require 'spec_helper'

describe PeopleController do
  let(:person) { FactoryGirl.create(:person)}
  before(:each) do
    sign_in person
  end
  describe "GET index" do
    before(:each) do
      (1..55).each do
        FactoryGirl.create(:person)
      end
    end
    describe "@people" do
      before { get :index }
      it "assigns the paginated people to @people" do
        assigns(:people).first.should be_a(Person)
        assigns(:people).length.should eq 25
      end
    end
  end
end