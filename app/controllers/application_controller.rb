class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_person!
  before_action :configure_permitted_parameters, if: :devise_controller?

  

  protected
	  def flash_alert(obj)
	  	#binding.pry
	    err_str = view_context.render_for_controller("validation_errors", {:obj => obj})
	  	msg = ("Unable to #{action_name} #{obj.class}. for the following" + 
	  		" " + view_context.pluralize(obj.errors.full_messages.length, "reason") + 
	  		":#{err_str}") unless obj.errors.messages.size < 1
	  	flash.now[:error] = msg.html_safe
	  end

	  def setup_pagination
	  	case params[:per_page]
	  	when nil
	  		@per_page = 25
	  	when "All"
	  		@per_page = controller_name.classify.constantize.count
	  		@selected_val = "All"
	  	else
	  		@per_page = params[:per_page]
	  	end
	  end

	  def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) << :last_name
	  end

end
