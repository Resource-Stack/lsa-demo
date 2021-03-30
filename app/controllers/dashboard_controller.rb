class DashboardController < ApplicationController

	def index

		@table_entries = TableEntry.all
		#Need to add this logic to model to handle these break downs
		@field_one = @table_entries.pluck(:field_one)
		@field_one_size = @field_one.size
		@f_one_avg = @field_one.map(&:to_i).sum / @field_one_size.to_i
		@f_one_unique = @field_one.map(&:to_i).uniq.sort



		if MasterTable.first.present?
			#
			@masterTable = MasterTable.first  
			@fieldValues = []
			@masterTable.attributes.each do |k,v|
				p k
				#these are the fields associated to with a postgres table we don't care about
				if k != 'id' && k != 'created_at' && k != 'updated_at'
					@fieldValues.push(v)
				end 
			end 
			#
		end
	end 



	
end
