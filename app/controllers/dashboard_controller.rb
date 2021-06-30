# using https://github.com/jnunemaker/httparty
class DashboardController < ApplicationController
	require 'date'
	before_action :authenticate_user!
	before_action :set_header_values
	include ElasticSearchHelper
	include AlphaHelper 
	
	def index
		#user charts not desired
		@user_colors = current_user.user_colors.pluck(:color)
		user_pref = ChartPreference.where(:user => current_user, :hide_table =>true).pluck(:table_name)
		#Summary

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

		### For Small Cards
    begin
      @all_data = fetch_all
      #@time_data = devices_over_time
      p 'success'
    rescue
      p 'issue2'
    end  
    #Get Unique Keys
    report_type = ElasticReport.pluck(:report_type_title)
    @unique_keys = report_type.uniq 
    logger.debug("Unique Keys:: #{@unique_keys}")
    @brewed = Hash.new
      @unique_keys.each do |x|
        #Get Unique Values
        unique_value = ElasticReport.where(report_type_title: x)
        unique = unique_value.pluck(:report_value_title)
        #count per unique value
        unique.uniq.each do |q|
            countdrac = ElasticReport.where(report_value_title: q)
            p q
            p countdrac.count
            #@brewed[count] = {report: x, key: q, value: countdrac.count}
            if @brewed.include?(x.to_s)
              #pre existing
              @brewed[x] << [q , countdrac.count]
            else 
              #new
              @brewed[x] = [[q , countdrac.count]]
            end 
        end 
        p @brewed
      end 

	end 

	def update_index
		set_elastic_index(params[:new_index])
	end 


	def tableView 

	end 

	def download_policies
		send_data ElasticReport.to_csv, filename: "policies-#{Date.today}.csv"
	end 

	def filter_toggle
	end 

	def hide_chart
		@user_colors = current_user.user_colors.pluck(:color)

		if ChartPreference.find_by(table_name: params[:chart_name]).present?
			cp = ChartPreference.find_by(table_name: params[:chart_name])
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
		@headerValues = []
		check = JSON.parse(@all_data[0])
		check.each do |kilo,alpha|
			@headerValues.push(kilo)
		end 
	end

	private 

		def set_header_values
			begin
				@all_data = []
				order_data = fetch_all
				order_data.each do |x|
					@all_data << eval(x).sort_by { |key| key }.to_h
				end 

				p 'success'
				@headerValues = []
				check = JSON.parse(@all_data[0])
				check.each do |kilo,alpha|
					@headerValues.push(kilo)
				end 

				@headerValues = @all_data[0].keys


			rescue => err
				p 'issue'
				p err

			end 
		end 
	
end
