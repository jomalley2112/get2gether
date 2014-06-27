class InvitesController < ApplicationController
  def index
  	setup_pagination(Person)
  	#we need all people + all invites for the specified meeting
  	@meeting = Meeting.find(params[:meeting_id])
  	@people = Person.attendees_for_meeting(params[:search], @page, @per_page, @meeting.id)
  	
  	# @people = Person.search(params[:search], @page, @per_page, Person.count)
  	# 				.joins("left outer join invites on invites.person_id = people.id and invites.meeting_id = #{@meeting.id}")
  	# 				.select("first_name, last_name, email, people.created_at, invites.id as invite_id, people.id")
			# 			.order("last_name, first_name")
						
  # 	@invites = @meeting.invites
  # 	@people_and_invites = Person.all.inject([]) do |memo, person|
  # 		memo << { :person => person, :invite => @invites.select { |i| i.person.id == person.id } }
		# end
	end

	#Used by ajax only currently
  def create
  	@invite = Invite.new(invite_params)
  	if @invite.save
      render :json => {success: "successfully invited"}
    else
      render :json => {
                        type: "error", saved: false, person_id: invite_params[:person_id], 
                        error: @invite.errors.full_messages, 
                        modal_alert_display_val: 'show'
                      }
    end
	end
	#Used by ajax only currently
  def destroy
    #Test: {"id"=>"1", "meeting_id"=>"1", "controller"=>"invites", "action"=>"destroy"}
    #Actual {"id"=>"520", "action"=>"destroy", "controller"=>"invites", "meeting_id"=>"37"}
    @invite = Invite.find(params[:id])
  	@invite.destroy
  end

  private
  	def invite_params
  		params.permit(:meeting_id, :person_id)
  	end
end
