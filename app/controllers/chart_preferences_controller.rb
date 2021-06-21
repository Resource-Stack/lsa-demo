class ChartPreferencesController < ApplicationController
  before_action :set_chart_preference, only: %i[ show edit update destroy ]
  before_action :set_header_values
  include ElasticSearchHelper
  include AlphaHelper

  # GET /chart_preferences or /chart_preferences.json
  def index
    @chart_preferences = ChartPreference.all
  end

  # GET /chart_preferences/1 or /chart_preferences/1.json
  def show
  end

  # GET /chart_preferences/new
  def new
    @chart_preference = ChartPreference.new 
    @chart_preference.user_id = current_user.id if current_user
  end

  # GET /chart_preferences/1/edit
  def edit
  end

  # POST /chart_preferences or /chart_preferences.json
  def create
    @chart_preference = ChartPreference.new(chart_preference_params)

    respond_to do |format|
      if @chart_preference.save
        format.html { redirect_to user_path(current_user), notice: "Chart preference was successfully created." }
        format.json { render :show, status: :created, location: @chart_preference }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chart_preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chart_preferences/1 or /chart_preferences/1.json
  def update
    respond_to do |format|
      if @chart_preference.update(chart_preference_params)
        format.html { redirect_to user_path(current_user), notice: "Chart preference was successfully updated." }
        format.json { render :show, status: :ok, location: @chart_preference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chart_preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chart_preferences/1 or /chart_preferences/1.json
  def destroy
    @chart_preference.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Chart preference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_header_values 
      begin
        @all_data = fetch_all
        p 'success'
      rescue
        p 'issue'
      end 

      @headerValues = []
      check = JSON.parse(@all_data[0])
      check.each do |kilo,alpha|
        @headerValues.push(kilo)
      end  
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_chart_preference
      @chart_preference = ChartPreference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chart_preference_params
      params.require(:chart_preference).permit(:table_name, :hide_table, :user_id)
    end
end
