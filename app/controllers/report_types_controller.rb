class ReportTypesController < ApplicationController
  before_action :set_report_type, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /report_types or /report_types.json
  def index
    @report_types = ReportType.all
  end

  # GET /report_types/1 or /report_types/1.json
  def show
    @report_types = ReportType.all
  end

  # GET /report_types/new
  def new
    @report_type = ReportType.new
  end

  # GET /report_types/1/edit
  def edit
    @report_types = ReportType.all
  end

  # POST /report_types or /report_types.json
  def create
    @report_type = ReportType.new(report_type_params)

    respond_to do |format|
      if @report_type.save
        format.html { redirect_to @report_type, notice: "Report type was successfully created." }
        format.json { render :show, status: :created, location: @report_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_types/1 or /report_types/1.json
  def update
    respond_to do |format|
      if @report_type.update(report_type_params)
        format.html { redirect_to @report_type, notice: "Report type was successfully updated." }
        format.json { render :show, status: :ok, location: @report_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_types/1 or /report_types/1.json
  def destroy
    @report_type.destroy
    respond_to do |format|
      format.html { redirect_to report_types_url, notice: "Report type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_type
      @report_type = ReportType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_type_params
      params.require(:report_type).permit(:title)
    end
end
