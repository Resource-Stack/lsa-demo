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
	   pdf_attachment_path = Dir.pwd + '/logstash_folder' + "/#{csv_file.filename}"
	   
	   File.open(pdf_attachment_path, 'wb') do |file|
	       file.write(csv_file.download)
	   end   
	end

	def construct_conf_file
				
			conf_string = "input {
							  file {
							    path => #{self.logstash_path} 
							    start_position => 'beginning'
							   sincedb_path => '/dev/null'
							  }
							}
							filter {
							  csv {
							      separator => ','
							      columns => #{self.logstash_column}
							  }
							}
							output {
							   elasticsearch {
							     hosts => #{self.logstash_host}
							     index => #{self.logstash_index}
							  }
							stdout {}
							}"

		path = Dir.pwd + '/logstash_folder' + "/logstash_conf.conf"
		File.open(path, "wb") do |f|
		  f.write(conf_string)
		end
	end 


end
