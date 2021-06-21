class ReportValuesController < ApplicationController
  before_action :set_report_value, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  include AlphaHelper
  # GET /report_values or /report_values.json
  def index
    @report_values = ReportValue.all
    @report_types = ReportType.all
  end

  # GET /report_values/1 or /report_values/1.json
  def show
  end

  # GET /report_values/new
  def new
    @report_value = ReportValue.new
    @report_types = ReportType.all
  end

  # GET /report_values/1/edit
  def edit
    @report_types = ReportType.all
  end

  # POST /report_values or /report_values.json
  def create
    @report_value = ReportValue.new(report_value_params)

    respond_to do |format|
      if @report_value.save
        format.html { redirect_to @report_value, notice: "Report value was successfully created." }
        format.json { render :show, status: :created, location: @report_value }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_values/1 or /report_values/1.json
  def update
    respond_to do |format|
      if @report_value.update(report_value_params)
        format.html { redirect_to @report_value, notice: "Report value was successfully updated." }
        format.json { render :show, status: :ok, location: @report_value }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_values/1 or /report_values/1.json
  def destroy
    @report_value.destroy
    respond_to do |format|
      format.html { redirect_to report_values_url, notice: "Report value was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_value
      @report_value = ReportValue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_value_params
      params.require(:report_value).permit(:title, :report_type_id)
    end
end
