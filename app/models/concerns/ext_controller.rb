module ExtController
  def flash_alert(obj)
  	err_str = view_context.render_for_controller("validation_errors", {:obj => obj})
  	msg = ("Unable to #{action_name} #{obj.class} for the following" + 
  		" " + view_context.pluralize(obj.errors.full_messages.length, "reason") + 
  		":#{err_str}") unless obj.errors.messages.size < 1
  	flash.now[:error] = msg.html_safe
  end

  def setup_pagination(obj_class=controller_name.classify.constantize)
  	@page = params[:page] || 1
  	
  	case params[:per_page]
  	when nil
  		@per_page = 25
  	when "All"
  		@per_page = obj_class.count
  		@selected_val = "All"
  	else
  		@per_page = params[:per_page]
  	end
  end
end