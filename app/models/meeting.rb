class Meeting < ActiveRecord::Base
	include DateTimeHelper
	include Searchable

	DEFAULT_DURATION = 60 #TODO: Move this
	DEFAULT_START_TIME = Time.now + 1.day

	has_many :invites
	accepts_nested_attributes_for :invites, allow_destroy: true
	has_many :people, -> { order 'people.last_name, people.first_name' }, through: :invites
	belongs_to :organizer, class: Person, :foreign_key => :organizer_id
	#Person.first.booked_meetings.first.organizer == Person.first
	
	attr_writer :duration
	def duration
		(end_time && start_time) ? ((end_time - start_time) / 1.minute).round : DEFAULT_DURATION.to_s
	end

	attr_writer :in_start_time
	def in_start_time
		#convert back to "05/20/2014 03:45:13 PM" format for display
		return self.start_time ? pretty_start_time : Meeting.get_pretty_date_time(DEFAULT_START_TIME)
	end
	
	validates :organizer, :presence => true #should make sure that organizer (Person) exists
	validates_presence_of :location
	validates_datetime :start_time, :after => lambda { DateTime.now }
	

	before_validation do
		self.start_time = @in_start_time ? Meeting.parse_pretty_date_time(@in_start_time) : (Time.now + 1.hour)
		@duration = DEFAULT_DURATION unless @duration && @duration.to_i > 0
		self.end_time = start_time + @duration.to_i.minutes
	end

	def pretty_start_time
		Meeting.get_pretty_date_time(self.start_time)
	end

	def pretty_end_time
		Meeting.get_pretty_date_time(self.end_time)
	end

	def invite_people(p_id_arr)
		p_id_arr.each do |p_id|
			begin
				self.people << Person.find(p_id)
			rescue
				next #if Person doesn't exist just continue to the next
			end
		end
	end

end
