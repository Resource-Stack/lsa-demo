class ElasticReportsController < ApplicationController
  before_action :set_elastic_report, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  include AlphaHelper

  # GET /elastic_reports or /elastic_reports.json
  def index
    begin
      @getter = get_elastic_index
      p 'getter success' 
      logger.debug("one two #{@getter}")
    rescue
      p 'getter fail'
      @getter = 'cyberapplicationplatformv2' 
    end 
    my_source = Source.find_by_source_title(@getter) 
    @elastic_reports = ElasticReport.where(source_id: my_source.id).sort_by { |obj| obj.report_type_title} 
    
    asdf = ElasticReport.where(source: my_source)
    logger.debug("one #{asdf}")
    fda =ElasticReport.where(source: my_source.id)
    logger.debug("two #{fda}")


    #@elastic_reports = ElasticReport.all.sort_by { |obj| obj.report_type_title} 
  end

  def find_by_id
    begin
      @getter = get_elastic_index
      p 'getter success' 
      logger.debug("one two #{@getter}")
    rescue
      p 'getter fail'
      @getter = 'cyberapplicationplatformv2' 
    end 

      selected_id = params[:selected_id]
        response = HTTParty.get('http://localhost:9200/' + @getter +'/_search?size=500',  
          :body => {
            :query => {
              :bool => {
                :must => {
                  :bool => {
                  :must => {"match": { "_id": selected_id }}
                 }
                }
              }
            }
          }.to_json,
            :headers => {
              "Content-Type" => "application/json" 
            }
        )

        p response.body
      @hashHash = Hash.new
      @responseBody = JSON.parse(response.body) 
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @hashHash[count] = k['_source']
        #p k['_source']
        count = count + 1
      end 

      @id_details = @hashHash
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
