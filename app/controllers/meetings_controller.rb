class MeetingsController < ApplicationController
  def index
    setup_pagination
    @meetings = Meeting.search(
                  params[:search], ["descr", "location"], "start_time desc", 
                  @page, @per_page
                )
  end

  def new
    session[:current_meeting] = @meeting = Meeting.new(:organizer => current_person)
  end

  def edit
    @meeting = Meeting.find(params[:id])
    #TODO Figure out pagination ajax thing
    @people = Person.paginate(:page => params[:page], :per_page => params[:per_page] || 25).order(:last_name, :first_name)
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.organizer = current_person
    if @meeting.save
      flash[:success] = "Created meeting successfully."
      redirect_to edit_meeting_url(@meeting)
    else
      flash_alert(@meeting)
      render :new
    end
  end

  def update
    #@meeting.organizer = current_person ???
    @meeting = Meeting.find(params[:id])
    if @meeting.update_attributes(meeting_params)
      flash[:success] = "Updated meeting successfully"
      redirect_to edit_meeting_url(@meeting)
    else
      flash_alert(@meeting)
      render :edit
    end
  end

  def destroy
  end

  def meeting_params
    params.required(:meeting).permit(:descr, :in_start_time, :duration, :organizer_id, :location, invites_attributes: [:meeting_id, :person_id, :_destroy, :id])
  end
end
