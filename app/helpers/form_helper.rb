module FormHelper
  def setup_meeting(meeting, page_scoped_people=nil)
  	meeting.location ||= ""
    @invites = []
    ((page_scoped_people || Person.all) - meeting.people).each do |person|
      @invites << meeting.invites.build(:person => person)
    end
    meeting.invites.to_a.sort_by! {|x| x.person.full_name }
    meeting
  end
end