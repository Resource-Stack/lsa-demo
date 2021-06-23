class TableEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_table_entry, only: %i[ show edit update destroy ]
  include ElasticSearchHelper
  include AlphaHelper

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


    #Line Graph Algo
    @graph_hash = Hash.new
    ReportValue.all.each do |rv|
      value_collection = ElasticReport.where(report_value_title: rv.title)
      @graph_hash[rv.title] = value_collection
    end 
    p 'hollow tune'
    p @graph_hash

    @over_all = Hash.new
    ReportType.all.each do |rt|
      #init key
      @over_all[rt.title] = []

      report_value_hash = Hash.new
      rt.report_values.each do |rv|
          find_dates = ElasticReport.where(report_value_title: rv.title).pluck(:data_creation_date)
          woof = find_dates.uniq.map{|t| [t, find_dates.count(t)]}.to_a
          if !woof.empty?
            logger.debug("WOOF #{woof}")
            report_value_hash[rv.title] = woof
            @over_all[rt.title] << report_value_hash
          end 
      end 
      # end loop
      p 'why why why'
      p @over_all    
    end 


 def download_policies
  send_data ElasticReport.to_csv, filename: "policy-#{Date.today}.csv"
 end 
#####

=begin
  hash[ReportType] = 
  [
    {name: report_value.title, data: [["2016-02-10", 19], ["2016-02-11", 5]]; }
  ]
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
