class DataDumpTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_dump_table, only: %i[ show edit update destroy ]

  # GET /data_dump_tables or /data_dump_tables.json
  def index
    @data_dump_tables = DataDumpTable.all
  end

  # GET /data_dump_tables/1 or /data_dump_tables/1.json
  def show
  end

  # GET /data_dump_tables/new
  def new
    @data_dump_table = DataDumpTable.new
  end

  # GET /data_dump_tables/1/edit
  def edit
  end

  # POST /data_dump_tables or /data_dump_tables.json
  def create
    @data_dump_table = DataDumpTable.new(data_dump_table_params)

    respond_to do |format|
      if @data_dump_table.save
        format.html { redirect_to @data_dump_table, notice: "Data dump table was successfully created." }
        format.json { render :show, status: :created, location: @data_dump_table }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @data_dump_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_dump_tables/1 or /data_dump_tables/1.json
  def update
    respond_to do |format|
      if @data_dump_table.update(data_dump_table_params)
        format.html { redirect_to @data_dump_table, notice: "Data dump table was successfully updated." }
        format.json { render :show, status: :ok, location: @data_dump_table }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @data_dump_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_dump_tables/1 or /data_dump_tables/1.json
  def destroy
    @data_dump_table.destroy
    respond_to do |format|
      format.html { redirect_to data_dump_tables_url, notice: "Data dump table was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_dump_table
      @data_dump_table = DataDumpTable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_dump_table_params
      params.require(:data_dump_table).permit(:user_id, :source_id, :csv_header_name, :csv_row_value)
    end
end
