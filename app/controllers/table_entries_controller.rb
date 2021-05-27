class TableEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_table_entry, only: %i[ show edit update destroy ]
  include ElasticSearchHelper

  # GET /table_entries or /table_entries.json
  def index
    @user_colors = current_user.user_colors.pluck(:color)
    begin
      @all_data = fetch_all
      #@time_data = devices_over_time
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


    #build cool graphs
    @graph_hash = Hash.new
    ReportValue.all.each do |rv|

      value_collection = ElasticReport.where(report_value_title: rv.title)
      @graph_hash[rv.title] = value_collection

    end 
    p 'hollow tune'
    p @graph_hash

    @over_all = Hash.new
    ReportType.all.each do |rt|
      @over_all[rt.title] = []

      hash_writer_array = []
      rt.report_values.each do |rv|
        value_collection = ElasticReport.where(report_value_title: rv.title)
        #hash_writer_array.push({name: rv.title, data: value_collection})
        hash_writer_array.push(value_collection)
      end 
      @over_all[rt.title] << hash_writer_array
    end 

p 'could you be'
p @over_all



#####

=begin
    ReportType.all.each do |rt|
      over_all[rt.title] = []

      current_report_value_array = []
      rt.report_values.each do |rv|
        value_collection = ElasticReport.where(report_value_title: rv.title)
        current_report_value_array.push(value_collection)
      end 
    end 
  Report_Type { name: Report_value data: ElasticReport.where(report_value_title: tv)}
  
report_type[mobile] =     [
      { name: report_value, data: ElasticReport.where()}
    ]

    each array will belong to a report value
    [
      { name: report_value, data: ElasticReport.where()}
    ]

        <%= line_chart [
          {name: "Series A", data: series_a},
          {name: "Series B", data: series_b}
        ] %>
=end

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
