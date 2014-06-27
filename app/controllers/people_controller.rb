class PeopleController < ApplicationController
  def index
  	setup_pagination
    #binding.pry
  	@people = Person.search(
                params[:search], ["first_name", "last_name"], "last_name, first_name", 
                @page, @per_page
                )
  end

  def index_no_layout
  	setup_pagination
  	@people = Person.paginate(:page => params[:page], :per_page => @per_page)
  	render :layout => nil
  end
end
