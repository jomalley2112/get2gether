class SessionsController < Devise::SessionsController

	skip_before_filter :authenticate_user!
	
	def after_sign_in_path_for(resource)
  	root_path  
	end
end