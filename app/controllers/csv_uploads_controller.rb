class CsvUploadsController < ApplicationController
  before_action :set_csv_upload, only: %i[ show edit update destroy ]
  before_action :set_master_table, only: %i[ show edit validate submit create add_data_dictionary add_data_dump update destroy ]
  require 'csv'

  # GET /csv_uploads or /csv_uploads.json
  def index
    @csv_uploads = CsvUpload.all
  end

  # GET /csv_uploads/1 or /csv_uploads/1.json
  def show

    @count = 0
    @current_row = []
    CSV.parse( @csv_upload.csv_file.download, headers: false) do |row|
      if @count == 0
        @current_row = row
      end 
      @count+=1
    end 

    @unidentifiedValues = []
    @current_row.each do |i|
      ind = i.to_s.rstrip
      if !@masterRow.include?(ind) && !DataDictionary.find_by_csv_header_name(ind).present? && !DataDumpDictionary.find_by_csv_header_name(ind).present?
        @unidentifiedValues.push(i)
      end 
    end  

  end 

  # GET /csv_uploads/news
  def new
    @csv_upload = CsvUpload.new
  end

  # GET /csv_uploads/1/edit
  def edit
  end

  # POST /csv_uploads or /csv_uploads.json
  def create
    #we do this step to gain access to the CSV. CHANGE
    @csv_upload = CsvUpload.new(csv_upload_params)
    @modified_paramters = csv_upload_params

    validation_array = []
    @count = 0
    CSV.parse( @csv_upload.csv_file.download, headers: false) do |row|
      if @count == 0
        current_row = row
        p @masterRow
        p current_row
        ###The Money
        row.each do |ind|
          if ind != nil
            p @masterRow
              currentIndex = ind.to_s.rstrip
              if @masterRow.include?(currentIndex) || DataDictionary.find_by_csv_header_name(ind).present? || DataDumpDictionary.find_by_csv_header_name(ind).present?
                validation_array.push("true")
              else
                validation_array.push("false")
              end 
            end 
        end 

      end 
      @count+=1
    end 
    #Validate our finds
    if validation_array.include?('false')
      @modified_paramters['flagged'] = true
    else
      @modified_paramters['flagged'] = false
    end 

    @csv_offical_upload = CsvUpload.new(@modified_paramters)
    respond_to do |format|
      if @csv_offical_upload.save
        format.html { redirect_to @csv_offical_upload, notice: "Csv upload was successfully created." }
        format.json { render :show, status: :created, location: @csv_offical_upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @csv_offical_upload.errors, status: :unprocessable_entity }
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

  def validate 

    my_csv = CsvUpload.find_by_id(params[:csv_id])
    p 'here'
    p my_csv

    @count = 0
    current_row = []
    CSV.parse( my_csv.csv_file.download, headers: false) do |row|
      if @count == 0
        current_row = row
        @validation = []

        current_row.each do |x|
          #Model.where("attribute = ? OR attribute2 = ?", value, value)
          #dd = DataDictionary.where("csv_header_name = ? AND " )

          if x != nil
            ind = x.to_s.rstrip
            logger.debug(" DTA DUMP Dictionary::: #{DataDumpTable.find_by_csv_header_name(ind).present?}")
            if @masterRow.include?(ind) || DataDictionary.find_by_csv_header_name(ind).present? || DataDumpDictionary.find_by_csv_header_name(ind).present?
              @validation.push('true')
            else 
              @validation.push('false')
            end 
          end 

        end 

      end #if @count
      @count+=1
    end 

    p @validation


      respond_to do |format|
        if @validation.include?('false')
          format.html { redirect_to my_csv, notice: "Csv did not pass." }
          format.json { render :show, status: :ok, location: my_csv }
        else
          my_csv.update_attribute(:flagged, false)
          format.html { redirect_to my_csv, notice: "Csv did pass." }
          format.json { render :show, status: :ok, location: my_csv }
        end
      end

  end 

  def submit     
    my_csv = CsvUpload.find_by_id(params[:csv_id])
    @current_row = []
    @count = 0
    CSV.parse( my_csv.csv_file.download, headers: false) do |row|
      if @count == 0
        row.each do |x|
          if x != nil
            @current_row.push(x)
          end 
        end 
      end 
      @count+=1
    end 

    logger.debug("Master Row :: #{@masterRow}")
    mapping = Hash.new 
    @dumpValues = []
    @current_row.each do |x|
      singleRowValue = x.to_s.rstrip
      logger.debug("Match #{x} :: TF:: #{@masterRow.include?(singleRowValue)}")
      if @masterRow.include?(singleRowValue)
        mapping[ @masterWithIndex[@masterRow.index(singleRowValue)][0] ] = @current_row.index(x)
        #mapping['field_three'] = the current csv index of
      elsif DataDictionary.find_by_csv_header_name(singleRowValue).present?
        
        @map_key = DataDictionary.where("user_id = ? AND csv_header_name = ?", '333', x)
        current_index = @current_row.index(x)
        mapping[@map_key[0].maps_to] = current_index
        #logger.debug("mapKey: #{@map_key[0].maps_to}....Index: #{current_index}")
      elsif DataDumpDictionary.find_by_csv_header_name(singleRowValue).present?
        ddd = DataDumpDictionary.find_by_csv_header_name(singleRowValue)
          @dumpValues.push(ddd.csv_header_name)
      else
        #this is nil value
        p 'nil value'
      end 
    end 

    logger.debug("UploadRow: #{@current_row}")
    p mapping
    #create TE


    CSV.parse( my_csv.csv_file.download, headers: true) do |row|

      #need to create a conditional to either create a TableEntry or a DumpEntry
      #create a new mapping for data dump
      #dump_mapping[''] = 
      #dump_entries would con
      #we need to know the header name & 


      # Need to map the index of the CSV header row and work off of that 
        #ddt= ddt.new
        #ddt.csv_header_name = mapping header name
        #ddr.csv_row_vale= mapping row value

      te = TableEntry.new 
      te.field_one = row[mapping['field_one']]
      te.field_two = row[mapping['field_two']]
      te.field_three = row[mapping['field_three']]
      te.field_four = row[mapping['field_four']]
      te.field_five = row[mapping['field_five']]
      te.field_six = row[mapping['field_six']]
      te.field_seven = row[mapping['field_seven']]
      te.field_eight = row[mapping['field_eight']]
      te.field_nine = row[mapping['field_nine']]
      te.field_ten = row[mapping['field_ten']]
      te.save
      #p row[mapping['field_one']]
      #p row[mapping['field_two']]
      #p row[mapping['field_three']]

      #find the index of 
      #IF THIS IS NEEDED *Conditonal 
      @dumpValues.each do |x|
        @singleValue = x.to_s.rstrip
        @select_index = row.index(@singleValue)

        ddd = DataDumpDictionary.find_by_csv_header_name(@singleValue)
        dump = DataDumpTable.new
        dump.data_dump_dictionary_id = ddd.id
        dump.csv_header_name = @singleValue
        dump.csv_row_value = row[@select_index]
        dump.save
      end 

    end 

    my_csv.destroy
    respond_to do |format|
      format.html { redirect_to csv_uploads_url, notice: "Csv was successfully uploaded into database." }
      format.json { head :no_content }
    end
    

  end 


  def add_data_dictionary
        @data_dictionary = DataDictionary.new
        respond_to do |format|
          format.html
          format.js
        end
  end 

  def add_data_dump
      @data_dump_dictionary = DataDumpDictionary.new
        respond_to do |format|
          format.html 
          format.js
        end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_csv_upload
      @csv_upload = CsvUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def csv_upload_params
      params.require(:csv_upload).permit(:user_id, :flagged, :csv_file, :source_id, :location_id, :policy_id)
    end



    def set_master_table

      if MasterTable.first.present?

        #this should be the master table belonging to the user.
        @masterTable = MasterTable.first  
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

    def upload_csv_first_row

    end  
end
