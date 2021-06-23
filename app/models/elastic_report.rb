class ElasticReport < ApplicationRecord
	require 'csv'
	include ElasticSearchHelper
	has_one :source

	def self.to_csv
	    begin
	      @all_data = fetch_all
	      #@time_data = devices_over_time
	      p 'success'
	    rescue
	      p 'issue'
	    end 

	    #Get Unique Keys
	    report_type = ElasticReport.pluck(:report_type_title)
	    @unique_keys = report_type.uniq 
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

	        logger.debug("HERE #{ @brewed}")
	      end 

	      #result
	      #{"Wireless"=>[["Corporate Wireless", 65], ["Guest Wireless", 65]], "Endpoint Compliance"=>[["No SEP Agent Unresolved", 6]]}

	      csv_headers = ["POLICY TYPE"]
	      policy_value_header = ["TYPE VALUE", "TOTAL"]
	      empty_row = ['','','','']

	      #Create CSV
	      CSV.generate(headers: true) do |csv|
	      	csv << csv_headers

	      	@brewed.each do |k,v|
	      		csv << [k.to_s]
	      		csv << policy_value_header
	      		v.each do |alpha|
	      			csv << [[alpha[0]],[alpha[1]]]
	      		end 
	      		csv << empty_row
	      	end 
	      end 
	end 

end
