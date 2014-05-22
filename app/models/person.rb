class Person < ActiveRecord::Base
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

  def full_name
  	str = ""
  	str += last_name
  	str += ", #{first_name}" unless first_name.blank?
  	return str
  end

  def self.search(search, page, per_page=25)
    #binding.pry
  	order('first_name, last_name').where('first_name like ? or last_name like ?', "%#{search}%", "%#{search}%").paginate(:per_page => per_page, :page => page)
	end
end
