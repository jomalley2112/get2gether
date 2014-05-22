class PeopleController < ApplicationController
  def index
  	setup_pagination
  	# @page = params[:page] || 1
   #  @per_page = params[:per_page] || 25
    @people = Person.search(params[:search], @page, @per_page)
    #@people = Person.paginate(:page => params[:page], :per_page => @per_page)
  end

  def index_no_layout
  	setup_pagination
  	@people = Person.paginate(:page => params[:page], :per_page => @per_page)
  	render :layout => nil
  end
end
