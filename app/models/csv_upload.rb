class CsvUpload < ApplicationRecord
require 'fileutils'
#require 'net/ssh'
#require 'net/sftp'
after_create :set_filename
has_one_attached :csv_file 

  def set_filename
    if self.csv_file.attached?
    	random = (0...8).map { (65 + rand(26)).chr }.join
      self.csv_file.blob.update(filename: "#{random}.#{self.csv_file.filename.extension}")
      p csv_file
    end 
  end

  def avatar_path
    ActiveStorage::Blob.service.path_for(csv_file.key)
  end

	def process_attachment       
		p 'Process Attachment'
		directory_name = "logstash_folder/" + "#{self.logstash_index}/" 
		Dir.mkdir(directory_name) unless File.exists?(directory_name)
	  pdf_attachment_path = directory_name + "#{self.csv_file.filename}"
	   
	   # works on smaller files
	   #File.open(pdf_attachment_path, 'wb') do |file|
	   #    file.write(csv_file.download) 
	   #end   
     #Use this for larger files
	   upload(directory_name, self.csv_file.filename)
	end

	def construct_conf_file
			
			puts "UPDATE METHOD CONF_STRING /app/models/csv_uploads.rb ...method construct_conf_file"
			#Update "path =>", line 37, to your app directory. For example, /home/unbuntu/lsa-demo/logstash_folder/...

			conf_string = "input {
							  file {
							  	mode => 'read'
									path => '/home/augustus/dev/lsa-demo/logstash_folder/#{self.logstash_index}/*.csv'
							    start_position => 'beginning'
							    sincedb_path => '/dev/null'
							    exit_after_read => 'true'
							    file_completed_log_path => '/home/augustus/dev/lsa-demo/logstash_folder/#{self.logstash_index}_master'
							    file_completed_action => 'log_and_delete'
							  }
							}
							filter {
							  csv {
							      separator => ','
							      columns => #{self.logstash_column}
							      skip_header => 'true'
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

		path = Dir.pwd + "/logstash_folder/"+ self.logstash_index + "/#{self.logstash_index}.conf"
		#hosts => #{self.logstash_host}
		File.open(path, "wb") do |f|
		  f.write(conf_string)
		end
	end  

	def construct_execute_file
		execute_file = "#!/bin/bash
	    sudo /usr/share/logstash/bin/logstash -f logstash_folder/#{self.logstash_index}/#{self.logstash_index}.conf"

			path = "logstash_folder/execute_#{self.logstash_index}.sh"
			#hosts => #{self.logstash_host}
			File.open(path, "wb") do |f|
			  f.write(execute_file)
			end
			File.chmod(0777,path)    
	end 

  #UN COMMENT ARGUEMENTS
  def self.upload(directory, file_name) 
    @server = 'xxxxxxxx'
    @username = 'xxx'
    @password = 'xxx'

    Net::SFTP.start(@server, @username, :password => @password.to_s) do |sftp|
      sftp.upload!(csv_file.download, directory + "#{file_name}")
    end
  end

  def self.test_upload
  	file = File.open("Mock_Data_One.csv")
  	directory = "logstash_folder/test_index/"

    @server = '104.248.127.32'
    @username = 'augustus'
    @password = 'xxx'
    Net::SFTP.start(@server, @username, :password => @password.to_s) do |sftp|
      #sftp.mkdir! (directory) # use if index is not there
      sftp.upload!(file, directory + "Mock_Data_One.csv")
    end
  end 

end
