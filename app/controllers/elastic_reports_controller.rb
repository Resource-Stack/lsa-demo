class ElasticReportsController < ApplicationController
  before_action :set_elastic_report, only: %i[ show edit update destroy ]

  # GET /elastic_reports or /elastic_reports.json
  def index
    @elastic_reports = ElasticReport.all.sort_by { |obj| obj.report_type_title}
  end

  # GET /elastic_reports/1 or /elastic_reports/1.json
  def show
  end

  # GET /elastic_reports/new
  def new
    @elastic_report = ElasticReport.new
  end

  # GET /elastic_reports/1/edit
  def edit
  end

  # POST /elastic_reports or /elastic_reports.json
  def create
    @elastic_report = ElasticReport.new(elastic_report_params)

    respond_to do |format|
      if @elastic_report.save
        format.html { redirect_to @elastic_report, notice: "Elastic report was successfully created." }
        format.json { render :show, status: :created, location: @elastic_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @elastic_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elastic_reports/1 or /elastic_reports/1.json
  def update
    respond_to do |format|
      if @elastic_report.update(elastic_report_params)
        format.html { redirect_to @elastic_report, notice: "Elastic report was successfully updated." }
        format.json { render :show, status: :ok, location: @elastic_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @elastic_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elastic_reports/1 or /elastic_reports/1.json
  def destroy
    @elastic_report.destroy
    respond_to do |format|
      format.html { redirect_to elastic_reports_url, notice: "Elastic report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elastic_report
      @elastic_report = ElasticReport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elastic_report_params
      params.require(:elastic_report).permit(:report_type_id, :report_value_id)
    end
end
