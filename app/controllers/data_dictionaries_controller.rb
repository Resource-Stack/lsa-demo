class DataDictionariesController < ApplicationController
  before_action :set_data_dictionary, only: %i[ show edit update destroy ]

  # GET /data_dictionaries or /data_dictionaries.json
  def index
    @data_dictionaries = DataDictionary.all
  end

  # GET /data_dictionaries/1 or /data_dictionaries/1.json
  def show
  end

  # GET /data_dictionaries/new
  def new
    @data_dictionary = DataDictionary.new
    #
    #
    @masterTable = MasterTable.first  
    @fieldValues = []
    @masterTable.attributes.each do |k,v|
      p k
      #these are the fields associated to with a postgres table we don't care about
      if k != 'id' && k != 'created_at' && k != 'updated_at'
        @fieldValues.push([v,k])
      end 
    end 
    #
  end

  # GET /data_dictionaries/1/edit
  def edit
  end

  # POST /data_dictionaries or /data_dictionaries.json
  def create
    p data_dictionary_params
    @data_dictionary = DataDictionary.new(data_dictionary_params)

    respond_to do |format|
      if @data_dictionary.save
        format.html { redirect_to @data_dictionary, notice: "Data dictionary was successfully created." }
        format.json { render :show, status: :created, location: @data_dictionary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @data_dictionary.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /data_dictionaries/1 or /data_dictionaries/1.json
  def update
    respond_to do |format|
      if @data_dictionary.update(data_dictionary_params)
        format.html { redirect_to @data_dictionary, notice: "Data dictionary was successfully updated." }
        format.json { render :show, status: :ok, location: @data_dictionary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_dictionaries/1 or /data_dictionaries/1.json
  def destroy
    @data_dictionary.destroy
    respond_to do |format|
      format.html { redirect_to data_dictionaries_url, notice: "Data dictionary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_dictionary
      @data_dictionary = DataDictionary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_dictionary_params
      params.require(:data_dictionary).permit( :user_id, :forescout_id, :source_id, :admin_id, :csv_header_name, :maps_to)


    end
end
