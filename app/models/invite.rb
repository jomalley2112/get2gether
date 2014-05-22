class Invite < ActiveRecord::Base
	belongs_to :person
	belongs_to :meeting
	validates :person, :presence => true
	validates :meeting, :presence => true
end
