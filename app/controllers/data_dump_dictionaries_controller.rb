class DataDumpDictionariesController < ApplicationController
  before_action :set_data_dump_dictionary, only: %i[ show edit update destroy ]

  # GET /data_dump_dictionaries or /data_dump_dictionaries.json
  def index
    @data_dump_dictionaries = DataDumpDictionary.all
  end

  # GET /data_dump_dictionaries/1 or /data_dump_dictionaries/1.json
  def show
    @dataDumpTables = @data_dump_dictionary.data_dump_tables
  end

  # GET /data_dump_dictionaries/new
  def new
    @data_dump_dictionary = DataDumpDictionary.new
  end

  # GET /data_dump_dictionaries/1/edit
  def edit
  end

  # POST /data_dump_dictionaries or /data_dump_dictionaries.json
  def create
    @data_dump_dictionary = DataDumpDictionary.new(data_dump_dictionary_params)

    respond_to do |format|
      if @data_dump_dictionary.save
        format.html { redirect_to @data_dump_dictionary, notice: "Data dump dictionary was successfully created." }
        format.json { render :show, status: :created, location: @data_dump_dictionary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @data_dump_dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_dump_dictionaries/1 or /data_dump_dictionaries/1.json
  def update
    respond_to do |format|
      if @data_dump_dictionary.update(data_dump_dictionary_params)
        format.html { redirect_to @data_dump_dictionary, notice: "Data dump dictionary was successfully updated." }
        format.json { render :show, status: :ok, location: @data_dump_dictionary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_dump_dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_dump_dictionaries/1 or /data_dump_dictionaries/1.json
  def destroy
    @data_dump_dictionary.destroy
    respond_to do |format|
      format.html { redirect_to data_dump_dictionaries_url, notice: "Data dump dictionary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_dump_dictionary
      @data_dump_dictionary = DataDumpDictionary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_dump_dictionary_params
      params.require(:data_dump_dictionary).permit(:user_id, :source_id, :csv_header_name)
    end
end
