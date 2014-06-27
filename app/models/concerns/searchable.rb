module Searchable

	def self.included base
	   base.extend ClassMethods
	   #base.send :include, InstanceMethods
	end

	module ClassMethods
		#override_count should generally be set to true only if your selecting specific columns in your query
		# when using mySql. Apparently it doesn;t like the "select count(col1, col2, ...)" syntax will_paginate uses
		def search(search_for, search_in, order_clause, page, per_page=25, override_count=false)
			qry_str = search_in.inject("(1=2)") do |memo, field|
				memo += " or (#{field} like :search_str)"
			end
			#binding.pry
			collection = order(order_clause).where(qry_str, {:search_str => "%#{search_for}%"})
	  	paginate_opts = {:per_page => per_page, :page => page}
	    paginate_opts.merge!(:total_entries => collection.length) if override_count
	    collection.paginate(paginate_opts)
		end		
	end

end