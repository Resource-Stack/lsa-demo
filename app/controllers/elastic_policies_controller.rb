class ElasticPoliciesController < ApplicationController
  before_action :set_elastic_policy, only: %i[ show edit update destroy ]

  # GET /elastic_policies or /elastic_policies.json
  def index
    @elastic_policies = ElasticPolicy.all
  end

  # GET /elastic_policies/1 or /elastic_policies/1.json
  def show
  end

  # GET /elastic_policies/new
  def new
    @elastic_policy = ElasticPolicy.new
        @report_values = ReportValue.all
    @report_types = ReportType.all
  end

  # GET /elastic_policies/1/edit
  def edit
  end

  # POST /elastic_policies or /elastic_policies.json
  def create
    @elastic_policy = ElasticPolicy.new(elastic_policy_params)

    respond_to do |format|
      if @elastic_policy.save
        format.html { redirect_to @elastic_policy, notice: "Elastic policy was successfully created." }
        format.json { render :show, status: :created, location: @elastic_policy }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @elastic_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elastic_policies/1 or /elastic_policies/1.json
  def update
    respond_to do |format|
      if @elastic_policy.update(elastic_policy_params)
        format.html { redirect_to @elastic_policy, notice: "Elastic policy was successfully updated." }
        format.json { render :show, status: :ok, location: @elastic_policy }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @elastic_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elastic_policies/1 or /elastic_policies/1.json
  def destroy
    @elastic_policy.destroy
    respond_to do |format|
      format.html { redirect_to elastic_policies_url, notice: "Elastic policy was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_output
    p 'hit' 
    passed_id = params[:id_selection]
    if passed_id == 'elastic_policy_report_type_id'
      @identify = 'elastic_policy_report_values_id'
      p 'here'
    else 
      id_value = passed_id.split('_')
      @identify = 'elastic_policy_report_values_id_' + id_value[id_value.length-1].to_s
    end 

    p @identify

    selected_report_type = ReportType.find_by_title(params[:field_selection])
    @return_values = ReportValue.where(report_type_id: selected_report_type.id)
    p @return_values.inspect

  end 

  def update_input
    p 'hit'

  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elastic_policy
      @elastic_policy = ElasticPolicy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elastic_policy_params
      params.require(:elastic_policy).permit(:title, :source, :policy_output, :input_requirements)
    end
end
