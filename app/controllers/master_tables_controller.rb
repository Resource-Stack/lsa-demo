class MasterTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master_table, only: %i[ show edit update destroy ]

  # GET /master_tables or /master_tables.json
  def index
    #@master_tables = MasterTable.all
      p current_user.master_table
      p MasterTable.first.inspect
    if current_user.master_table.present?
      p 'true'
      @master_table = current_user.master_table
    else
      p 'false'
    end 
  end

  # GET /master_tables/1 or /master_tables/1.json
  def show
  end

  # GET /master_tables/new
  def new
    @master_table = MasterTable.new
  end

  # GET /master_tables/1/edit
  def edit
  end

  # POST /master_tables or /master_tables.json
  def create
    @master_table = MasterTable.new(master_table_params)

    respond_to do |format|
      if @master_table.save
        format.html { redirect_to @master_table, notice: "Master table was successfully created." }
        format.json { render :show, status: :created, location: @master_table }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @master_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_tables/1 or /master_tables/1.json
  def update
    respond_to do |format|
      if @master_table.update(master_table_params)
        format.html { redirect_to @master_table, notice: "Master table was successfully updated." }
        format.json { render :show, status: :ok, location: @master_table }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @master_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_tables/1 or /master_tables/1.json
  def destroy
    @master_table.destroy
    respond_to do |format|
      format.html { redirect_to master_tables_url, notice: "Master table was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_table
      @master_table = MasterTable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def master_table_params
      params.require(:master_table).permit(:field_one, :field_two, :field_three, :field_four, :field_five, :field_six, :field_seven, :field_eight, :field_nine, :field_ten, :user_id)
    end
end
