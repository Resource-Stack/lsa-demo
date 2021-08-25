# using https://github.com/jnunemaker/httparty
class DashboardController < ApplicationController
	require 'date'
	before_action :authenticate_user!
	before_action :set_header_values
	before_action :set_user_pref, only: %i[ index ]
	include ElasticSearchHelper
	include AlphaHelper 
	
	def index
		#user charts not desired
		@user_colors = current_user.user_colors.pluck(:color)
		user_pref = ChartPreference.where(:user => current_user, :hide_table =>true).pluck(:table_name)

		### For Small Cards
    begin
      @all_data = fetch_all
      p 'success'
    rescue
      p 'issue'
    end  
    @brewed = ElasticReport.get_count_summary   
	end 

	def hide_chart
		p 'hide_chart'
		@user_colors = current_user.user_colors.pluck(:color)

		if ChartPreference.where(:user => current_user, :table_name => params[:chart_name]).present?
			cp = ChartPreference.where(:user => current_user, :table_name => params[:chart_name])
		end 

		if cp.present?
			cp.update_attribute(:hide_table, true)

		else
			hide_chart = ChartPreference.new
			hide_chart.table_name = params[:chart_name]
			hide_chart.hide_table = true
			hide_chart.user = current_user
			hide_chart.save
		end 
		
		user_pref = ChartPreference.where(user: current_user).pluck(:table_name)

		#need to refresh with updates (Not Dry, but needed)
		begin
			p 'fetch summary'
			@summary = fetch_summary[0]
			@summary.each do |k,v|
				if user_pref.include?(k)
					@summary.delete(k)
				end 
			end 
			@headerValues = []
			check = JSON.parse(@all_data[0])
			check.each do |kilo,alpha|
				@headerValues.push(kilo)
			end  
		rescue => err
			p 'issue'
			p err
		end 
	end

	def update_index
		set_elastic_index(params[:new_index])
	end 

	def tableView 
		@headerValues = @all_data[0].keys
	end 

	def download_policies
		send_data ElasticReport.to_csv, filename: "policies-#{Date.today}.csv"
	end 

	def filter_toggle
		 @headerValues = @all_data[0].keys 
	end 

	private 

		def set_header_values
			begin
				@all_data = []
				order_data = fetch_all

				order_data.each do |x|
            current_row = JSON.parse(x)
						current_row.each do |kk,vv|
							if vv == nil || vv == 'nil'
									current_row[kk] = 'NONE'
							end
						end
					#@all_data << eval(x).sort_by { |key| key }.to_h
					@all_data << current_row.sort_by { |key,val| key.to_s}.to_h
				end 

				p 'success'
				@headerValues = []

				#check = JSON.parse(@all_data[0])
				#check.each do |kilo,alpha|
				#		@headerValues.push(kilo)
				#end 

				#@headerValues = @all_data[0].keys
				@all_data[0].each do |x|
					@headerValues.push(x[0])
				end

			rescue => err
				p 'issue'
				p err

			end 
		end 

		def set_user_pref
					begin
						@summary = fetch_summary[0]
						p 'success'

						@summary.each do |k,v|
							if user_pref.include?(k)
								@summary.delete(k)
							end 
							p k
							#sp v
						end 
					rescue
						p 'issue'
					end 
		end

end
