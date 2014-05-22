module ApplicationHelper

	def render_for_controller(partial, local_vars)
		#when a controller directly renders a partial you can't render a view after that
		render(:partial => partial, :locals => local_vars).html_safe
	end
	
end
