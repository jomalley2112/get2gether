require 'spec_helper'

describe InvitesController do
	let(:person) { FactoryGirl.create(:person)}
  before(:each) do
    sign_in person
  end
  describe "Only used with AJAX" do
  	let(:meeting) { FactoryGirl.create(:meeting)}
  	describe "POST create" do
		  it "silently creates a new one" do
		  	expect {
		  		post :create, {meeting_id: meeting.id, person_id: person.id}	
		  	}.to change(Invite, :count).by(1)
		  end
		end

		describe "DELETE destroy" do
		  # let(:invite) { FactoryGirl.create(:invite, meeting: meeting)}
		  # it "silently deletes existing one" do
		  # 	puts "Invites #{Invite.count}"
		  # 	sleep 1
		  # 	expect {
		  # 		delete :destroy, { id: invite.id, meeting_id: meeting.id }	
		  # 	}.to change(Invite, :count).by(-1)
		  # 	puts "Invites #{Invite.count}"
		  # end
		  pending "InviteController will not delete an invite for some reason"
		end
  end
	

end