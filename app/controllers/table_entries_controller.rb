class TableEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_table_entry, only: %i[ show edit update destroy ]
  include ElasticSearchHelper

  # GET /table_entries or /table_entries.json
  def index

    begin
      @all_data = fetch_all
      p 'success'
    rescue
      p 'issue'
    end 
    #Get Unique Keys
    report_type = ElasticReport.pluck(:report_type_title)
    @unique_keys = report_type.uniq 
    logger.debug("Unique Keys:: #{@unique_keys}")

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

      p @brewed
    end 

    @table_entries = TableEntry.where("user_id = ? ", current_user.id)

        if current_user.table_entries.present? 
          @masterTable = current_user.master_table
          @masterRow = []
          p @masterTable
          @masterTable.attributes.each do |k,v|
            if k != 'id' && k != 'created_at' && k != 'updated_at' && v != nil
              @masterRow.push(v)
            end 
          end
        end 
  end

  # GET /table_entries/1 or /table_entries/1.json
  def show
  end

  # GET /table_entries/new
  def new
    @table_entry = TableEntry.new
  end

  # GET /table_entries/1/edit
  def edit
  end

  # POST /table_entries or /table_entries.json
  def create
    @table_entry = TableEntry.new(table_entry_params) 

    respond_to do |format|
      if @table_entry.save
        format.html { redirect_to @table_entry, notice: "Table entry was successfully created." }
        format.json { render :show, status: :created, location: @table_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @table_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /table_entries/1 or /table_entries/1.json
  def update
    respond_to do |format|
      if @table_entry.update(table_entry_params)
        format.html { redirect_to @table_entry, notice: "Table entry was successfully updated." }
        format.json { render :show, status: :ok, location: @table_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @table_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /table_entries/1 or /table_entries/1.json
  def destroy
    @table_entry.destroy
    respond_to do |format|
      format.html { redirect_to table_entries_url, notice: "Table entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table_entry
      @table_entry = TableEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def table_entry_params
      params.require(:table_entry).permit(:field_one, :field_two, :field_three,:field_four, :field_five, :field_six, :field_seven, :field_eight, :field_nine, :field_ten, :user_id, :csv_upload_date)
    end
end
