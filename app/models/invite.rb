class Invite < ActiveRecord::Base
	belongs_to :person
	belongs_to :meeting
	validates :person, :presence => true
	validates :meeting, :presence => true
	
	validate :meeting_not_over

	private
		def meeting_not_over
			if self.meeting.end_time < Time.now
				errors.add(:base, "Meeting has already expired.")
			end
		end
end
