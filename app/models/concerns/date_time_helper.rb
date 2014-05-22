module DateTimeHelper

	def self.included base
	   base.extend ClassMethods
	   #base.send :include, InstanceMethods
	end

	module ClassMethods
		def parse_pretty_date_time(str_date)
			str_date.gsub!(/(\d*)\/(\d*)\/(\d{4})/, "\\3-\\1-\\2")
			return DateTime.parse(str_date)
		end
		def get_pretty_date_time(date_time=DateTime.now)
			date_time ? date_time.strftime('%m/%d/%Y %I:%M:%S %p') : ""
		end
	end

	
end