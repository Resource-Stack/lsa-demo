class DashboardController < ApplicationController

	def index
		if MasterTable.first.present?
			#
			@masterTable = MasterTable.first  
			fieldValues = []
			@masterTable.attributes.each do |k,v|
				p k
				#these are the fields associated to with a postgres table we don't care about
				if k != 'id' && k != 'created_at' && k != 'updated_at'
					fieldValues.push(v)
				end 
			end 
			#
		end
	end 



	
end
