class Person < ActiveRecord::Base
  include Searchable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :invites
  has_many :meetings, through: :invites

  has_many :booked_meetings, :foreign_key => :organizer_id, :class_name => "Meeting"
  #Person.first.booked_meetings.first.organizer == Person.first

  default_scope { order('last_name, first_name') }

  validates :last_name, { presence: true }
  validates :email, { presence: true }

  scope :attendees_for_meeting, ->(search_str, page, per_page, meeting_id) { 
    search(search_str, ["first_name", "last_name"], "last_name, first_name", page, per_page, true)
            .joins("left outer join invites on invites.person_id = people.id and invites.meeting_id = #{meeting_id}")
            .select("first_name, last_name, email, people.created_at, invites.id as invite_id, people.id")
            .order("last_name, first_name")
   }

  def full_name
  	str = ""
  	str += last_name
  	str += ", #{first_name}" unless first_name.blank?
  	return str
  end

 #  def self.search(search, page, per_page=25, total_entries=nil)
 #    paginate_opts = {:per_page => per_page, :page => page}
 #    paginate_opts.merge!(:total_entries => total_entries) if total_entries
 #  	order('first_name, last_name')
 #      .where('first_name like ? or last_name like ?', "%#{search}%", "%#{search}%")
 #      .paginate(paginate_opts)
	# end
end
