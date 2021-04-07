class DashboardController < ApplicationController
	require 'date'
	before_action :set_master_table, only: %i[ timeRangeReport restrictParam findBy ] 
	before_action :authenticate_user!
	def index

		if current_user.table_entries.present? && current_user.master_table.present?
			#only concerned about first row. Need to make conditional based off values 
			@tableEntry = current_user.table_entries[0]

			#Need to add this logic to model to handle these break downs
			#@field_one = @table_entries.pluck(:field_one)
			#@field_one_size = @field_one.size
			#@f_one_avg = @field_one.map(&:to_i).sum / @field_one_size.to_i
			#@f_one_unique = @field_one.map(&:to_i).uniq.sort
			@masterTable = current_user.master_table
			@fieldValues = []
			@masterTable.attributes.each do |k,v|
				p k
				#these are the fields associated to with a postgres table we don't care about
				if k != 'id' && k != 'created_at' && k != 'updated_at'
					@fieldValues.push(v) 
				end 
			end 

		elsif !current_user.master_table.present?
			redirect_to master_tables_path, notice: "Please Create A Master Table"
		end 



			

	end 

	def timeRangeReport
		p '[time]'
		#p params[:start_date]
		#p params[:end_date]
		#p params[:field_selection]
		#p params[:unique_selection]
		startDate = params[:start_date].to_date.beginning_of_day
		endDate = params[:end_date].to_date.end_of_day

		#reduce by date
		@dateRestrictions = TableEntry.where(:created_at => startDate..endDate)
		#find specified entries
		@masterTable = current_user.master_table 
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:field_selection] == v

					@focusedTableEntries = @dateRestrictions.where("#{k}": "#{params[:unique_selection]}")
					p @focusedTableEntries
				end 
			end 
		end 



        respond_to do |format|
          #format.html 
          format.js
        end

	end 

	def restrictParam
		p params[:first_field]
		p params[:filter_one]

		p params[:second_field]
		p params[:filter_two]
		@masterTable = current_user.master_table 
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			#This will throw an error unless it is done in order....
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:first_field] == v
					@firstFocusedTableEntries = TableEntry.where("#{k}": "#{params[:filter_one]}")
				elsif params[:second_field] == v
					@secondFocusedTableEntries = @firstFocusedTableEntries.where("#{k}": "#{params[:filter_two]}")
				else
					p ' no match'
				end 
			end 
		end 
		


        respond_to do |format|
          #format.html 
          format.js
        end

	end 

	def findBy
		p params[:findby_field]
		p params[:values]

		@masterTable = current_user.master_table 
		@count = 0
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			#This will throw an error unless it is done in order....
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:findby_field] == v
					params[:values].split(',').each do |x|
						p x
						if @count == 0 
							@currentCollection = TableEntry.where("#{k}": "#{x}")	
							#logger.debug("current #{@currentCollection}")
							@FindByTableEntries = @currentCollection
							#logger.debug("FocusedTableEntries #{@FocusedTableEntries}")
						else 
							p 'not 0'
							nextCollection = TableEntry.where("#{k}": "#{x}")	
							#logger.debug("next #{nextCollection}")
							@FindByTableEntries = (@FindByTableEntries + nextCollection)
							
						end 
						@count = @count + 1
					end 
				end 
			end 
		end 
		logger.debug("focus #{@FindByTableEntries}")

        respond_to do |format|
          #format.html 
          format.js
        end

	end 

	def find_by_filter
		@masterTable = current_user.master_table  
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:findBy_filter] == v
					@focusedTableEntries = TableEntry.pluck(k)
					@uniqueEntries = @focusedTableEntries.uniq.sort
					p 'here'
					p @uniqueEntries
				end 
			end 
		end 
		#
        respond_to do |format|
          #format.html 
          format.js
        end
	end 

	def updateTimeFieldSelection
		@masterTable = current_user.master_table   
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:field_selection] == v
					@focusedTableEntries = TableEntry.pluck(k)
					@uniqueEntries = @focusedTableEntries.uniq.sort
					p 'here'
					p @uniqueEntries
				end 
			end 
		end 
		#
        respond_to do |format|
          #format.html 
          format.js
        end
	end 

	def update_filter_one
		p 'test'
		@masterTable = current_user.master_table 
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:filter_one] == v
					@focusedTableEntries = TableEntry.pluck(k)
					@uniqueEntries = @focusedTableEntries.uniq.sort
					p 'here'
					p @uniqueEntries
				end 
			end 
		end 
		#
        respond_to do |format|
          #format.html 
          format.js
        end
	end 

	def update_filter_two
		p 'test'
		@masterTable = current_user.master_table  
		@uniqueEntries = []
		@masterTable.attributes.each do |k,v|
			#these are the fields associated to with a postgres table we don't care about
			if k != 'id' && k != 'created_at' && k != 'updated_at'
				if params[:filter_two] == v
					@focusedTableEntries = TableEntry.pluck(k)
					@uniqueEntries = @focusedTableEntries.uniq.sort
					p 'here'
					p @uniqueEntries
				end 
			end 
		end 
		#
        respond_to do |format|
          #format.html 
          format.js
        end
	end 

	private 

    def set_master_table


      if current_user.master_table.present?

        #this should be the master table belonging to the user.
        @masterTable = current_user.master_table   
        @masterRow = []
        @masterWithIndex = []
        @masterTable.attributes.each do |k,v|
            logger.debug("K:#{k} V: #{v}")
          if k != 'id' && k != 'created_at' && k != 'updated_at' && v != nil

            @masterRow.push(v)
            @masterWithIndex.push([k,v])
          end 
        end 
      #
      end
    end
	
end
