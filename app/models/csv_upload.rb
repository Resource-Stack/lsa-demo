class CsvUpload < ApplicationRecord

after_create :set_filename
has_one_attached :csv_file

  def set_filename
    if self.csv_file.attached?

      self.csv_file.blob.update(filename: "elastic_csv.#{self.csv_file.filename.extension}")
      p csv_file
    end
  end

  def avatar_path
    ActiveStorage::Blob.service.path_for(csv_file.key)
  end


	def process_attachment       
		p 'Process Attachment'
	  pdf_attachment_path = Dir.pwd + "/logstash_folder/#{csv_file.filename}" #"elastic_csv.csv" 
	   
	   File.open(pdf_attachment_path, 'wb') do |file|
	       file.write(csv_file.download)
	   end   
	end

	def construct_conf_file
			#path => '/home/augustus/dev/lsa-demo/logstash_folder/elastic_csv.csv'
			#This issue we face uploading all CSV is there is no guarentee they will have the same header.
			#Better solution is rerun logstash PER csv upload currently.

				
			conf_string = "input {
							  file {
							    path => '/home/augustus/dev/lsa-demo/logstash_folder/'+ #{self.csv_file.filename}
							    start_position => 'beginning'
							    sincedb_path => '/dev/null'
							  }
							}
							filter {
							  csv {
							      separator => ','
							      columns => #{self.logstash_column}
							  }
							    mutate {
          					remove_field => ['message','@timestamp','path','host','@version']
  								}
							}
							output {
							   elasticsearch {
							     hosts => 'http://localhost:9200'
							     index => #{self.logstash_index}
							  }
							stdout {}
							}"

		path = Dir.pwd + "/logstash_folder/" + "rails_conf.conf"
		#hosts => #{self.logstash_host}
		File.open(path, "wb") do |f|
		  f.write(conf_string)
		end
	end 


end
