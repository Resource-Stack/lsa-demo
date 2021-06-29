class CsvUploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_csv_upload, only: %i[ show edit update destroy ]
  include AlphaHelper
  require 'csv'
  require 'open3'

  # GET /csv_uploads or /csv_uploads.json
  def index
    @csv_uploads = CsvUpload.all
    #CsvUpload.delete_all
  end

  # GET /csv_uploads/1 or /csv_uploads/1.json
  def show
    if @csv_upload.logstash_column == [] || @csv_upload.logstash_column == nil
      p 'first time?'
      up_logstash_column = []
      @count = 0
      CSV.parse( @csv_upload.csv_file.download, headers: false) do |row|
        if @count == 0
          p row
          up_logstash_column = row
        end 
        @count+=1
      end 
      @csv_upload.update_attribute(:logstash_column, up_logstash_column)
    end 

    #Create LogStash Conf,Copy CSV, Create Script
    @csv_upload.process_attachment
    @csv_upload.construct_conf_file 
    @csv_upload.construct_execute_file      
    #CALL SYSTEM SCRIPT

    execute_index = @csv_upload.logstash_index
    construct_string = "execute_#{execute_index}.sh"
    path =  "logstash_folder/#{construct_string}"
    puts "EXECUTE!!!!"

    command = Thread.new do
       system("#{path}")
    end
    command.join 

    puts "command complete"
  end 

  # GET /csv_uploads/news
  def new
    @csv_upload = CsvUpload.new
    @sources = Source.all
    @default_path = Dir.pwd + '/csv_uploads/'
    @default_host = "159.203.165.143:9200"
    @default_index = 'cyberapplicationplatformv2'
  end

  # GET /csv_uploads/1/edit
  def edit
  end

  # POST /csv_uploads or /csv_uploads.json
  def create
    p params['csv_upload']
    p params['csv_upload']['logstash_index']
    format_index = params['csv_upload']['logstash_index'].downcase
    change_params = csv_upload_params
    change_params['logstash_index'] = format_index

    #we do this step to gain access to the CSV. CHANGE
    @csv_upload = CsvUpload.new(change_params)

    respond_to do |format|
      if @csv_upload.save
        format.html { redirect_to @csv_upload, notice: "Csv upload was successfully created." }
        format.json { render :show, status: :created, location: @csv_upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /csv_uploads/1 or /csv_uploads/1.json
  def update
    respond_to do |format|
      if @csv_upload.update(csv_upload_params)
        format.html { redirect_to @csv_upload, notice: "Csv upload was successfully updated." }
        format.json { render :show, status: :ok, location: @csv_upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /csv_uploads/1 or /csv_uploads/1.json
  def destroy
    @csv_upload.destroy
    respond_to do |format|
      format.html { redirect_to csv_uploads_url, notice: "Csv upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_csv_upload
      @csv_upload = CsvUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def csv_upload_params
      params.require(:csv_upload).permit( :source_id, :uploaded, :csv_upload_date, :logstash_path, :logstash_column, :logstash_host, :logstash_index, :csv_file)
    end


    #Could use to validate header against new updates
    #before_action :set_master_table, only: %i[ show edit validate submit create add_data_dictionary add_data_dump update destroy ]
    def set_master_table
      if current_user.master_table.present?

        #this should be the master table belonging to the user.
        #@masterTable = MasterTable.first  
        @masterTable = current_user.master_table
        @masterRow = []
        @masterWithIndex = []
        @masterTable.attributes.each do |k,v|
            logger.debug("K:#{k} V: #{v}")
          if k != 'id' && k != 'created_at' && k != 'updated_at' && v != nil && k != 'user_id'

            @masterRow.push(v)
            @masterWithIndex.push([k,v])
          end 
        end 
      #
      end
    end
end