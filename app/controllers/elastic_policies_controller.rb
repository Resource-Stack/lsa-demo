class ElasticPoliciesController < ApplicationController
  before_action :set_elastic_policy, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :source_getter
  # GET /elastic_policies or /elastic_policies.json
  include ElasticPoliciesHelper
  include AlphaHelper
  require 'elasticsearch'
  
  def index
    @elastic_policies = ElasticPolicy.where(source: @getter)
    #@elastic_policies = ElasticPolicy.all
  end

  # GET /elastic_policies/1 or /elastic_policies/1.json
  def show 
  end

  # GET /elastic_policies/new
  def new
    @elastic_policy = ElasticPolicy.new
    @report_values = ReportValue.all
    @report_types = ReportType.all
    @sources = Source.all

    # GET ALL (for input values)
      response = HTTParty.get('http://localhost:9200/' + @getter +'/_search?size=500')
        p '[RESPONSE CODE]'
        p response.code
      #Convert To JSON
      @responseBody = JSON.parse(response.body)
        p '[RESPONSE BODY]'
        p @responseBody
      #Get the HITS
      @responseHash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @responseHash[count] = k['_source']
        count = count + 1
      end 
      #Get The Header Values
      @headerValues = []
      @responseHash[0].each do |kilo,alpha|
        @headerValues.push(kilo)
      end 
    ##
  end

  def false_create    
    my_source = Source.find_by_source_title(@getter)
    ElasticReport.where(source_id: my_source.id).destroy_all
    #ElasticReport.delete_all

    #Gets all data for the index
    p '[REFRESH DATA]'
      response = HTTParty.get('http://localhost:9200/' + @getter +'/_search?size=1000')
      @responseBody = JSON.parse(response.body)
      @data_hash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @data_hash[k['_id']] = k['_source']
        count = count + 1
      end 
      #ROWS
      #Get The Header Values
      @headerValues = []
      @data_hash.first.each do |kilo,alpha|
        @headerValues.push(kilo) 
      end 

     ## Loop Through Data and create new ElasticReports
        @data_hash.each do |karma, data|
            ElasticPolicy.all.each do |ep|
              logger.debug("POLICY: #{ep.title} input #{ep.input_requirements}")
                  @trueFalse = []
                  ep[:input_requirements].each do |policy_index,policy_KV|
                      data.each do |key,value|  
                        #logger.debug(" YOU NEED THE DATA #{data}")
                        #logger.debug("Keys::: d #{key.to_s} == p #{policy_KV['key'].to_s}")
                        #logger.debug("Values::: d #{value.to_s} == p #{policy_KV['value'].to_s}")

                         if key.to_s == policy_KV['key'].to_s && value.to_s == policy_KV['value'].to_s
                           p ' MATCH'
                            @trueFalse.push(true)
                         end 
                            #logger.debug("Length: tf#{@trueFalse.length} p#{ep.input_requirements.length}")
                            if ep[:input_requirements].size == @trueFalse.length
                              p 'eureka'
                                 ep[:policy_output].each do |kk,vv|
                                   er = ElasticReport.new  
                                   er.report_type_title = ReportType.find_by_title(vv['key']).title
                                   er.report_value_title = ReportValue.find_by_title(vv['value']).title
                                   er.elastic_id = karma.to_s

                                   #have to find sourceID
                                   logger.debug("source title #{ep.id}") 
                                   current_source = Source.find_by_source_title(ep.source)
                                   logger.debug("current_source #{current_source.inspect}")
                                   er.source_id = current_source.id
                                   #data_creation will eventually be associated to the DATA
                                   er.data_creation_date = random_datetime.strftime('%F')
                                   er.save
                                 end 
                                 #reset count
                                 @trueFalse = []
                            end #End Input check
                      end #End Data Loop
                  end # End Current Input
            end #End ElasticPolicy
      end #End Data Hash

      redirect_to table_entries_path
  end 

  # GET /elastic_policies/1/edit
  def edit
    @report_values = ReportValue.all
    @report_types = ReportType.all
    @sources = Source.all
#NOT DRY
    # GET ALL (for input values)
      response = HTTParty.get('http://localhost:9200/' + @getter +'/_search?size=500')
      @responseBody = JSON.parse(response.body)
      @responseHash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @responseHash[count] = k['_source']
        count = count + 1
      end 

      #Get The Header Values
      @headerValues = []
      @responseHash[0].each do |kilo,alpha|
        @headerValues.push(kilo)
      end 
    ##
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
    p "update"
    #source
    policy_sources = params[:source]
    #params[:source].split(',')
    #output
    output_keys = params[:output_keys].split(',')
    output_values = params[:output_values].split(',')
    output = Hash.new 
    x=0
    while x < output_keys.length
      output[x] = {key: output_keys[x], value: output_values[x]}
      x +=1
    end 

    #input
    input_keys = params[:input_keys].split(',')
    input_values = params[:input_values].split(',')
    input = Hash.new 
    i=0
    while i < input_keys.length
      input[i] = {key: input_keys[i], value: input_values[i]}
      i +=1
    end 

  #remove source, needs to be consistient :source => policy_sources,
  @elastic_policy.update_attributes(:title => params[:title], :policy_output => output, :input_requirements => input)
  redirect_to elastic_policies_path

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
    p 'update input'
    #Get A Value
        tightResponse = HTTParty.get('http://localhost:9200/' + @getter +'/_search?size=500', 
              :body => {
                :aggs => {
                  :langs => { 
                    :terms => {
                      'field' => params[:field_selection]+'.keyword','size' => 500
                    }
                  } 
                },
                "fields" => [params[:field_selection]+".keyword"],
                "_source" => false
              }.to_json,
                :headers => {
                  "Content-Type" => "application/json"
                }
            )

         @tight = JSON.parse(tightResponse.body)
         @importantvalues = @tight['aggregations']['langs']['buckets']

         #Get Values From JSON
        valueCount = 0
        @valuesArray =  []
        @importantvalues.each do |k,v|
            k.each do |key,value| 
              
              valueCount +=1
              if valueCount == 2
                valueCount = 0
              end 

              if valueCount == 1
               @valuesArray.push(value)  
             end 
             

            end 
        end 
        p 'value array'
        p @valuesArray 
    # end get value

    passed_id = params[:id_selection]
    if passed_id == 'input_requirement_header_id'
      @inputID = 'input_requirement_value_id'
      p 'here'
    else 
      id_value = passed_id.split('_')
      p id_value
      @inputID = 'input_requirement_value_id_' + id_value[id_value.length-1].to_s
    end 

  end 


  def create_policy
    p ' hit'
    #source
    #policy_sources = params[:source].split(',')
    #output
    policy_sources = params[:source]
    output_keys = params[:output_keys].split(',')
    output_values = params[:output_values].split(',')
    output = Hash.new 
    x=0
    while x < output_keys.length
      output[x] = {key: output_keys[x], value: output_values[x]}
      x +=1
    end 

    #input
    input_keys = params[:input_keys].split(',')
    input_values = params[:input_values].split(',')
    input = Hash.new 
    i=0
    while i < input_keys.length
      input[i] = {key: input_keys[i], value: input_values[i]}
      i +=1
    end 

    @new_policy = ElasticPolicy.new
    @new_policy.title = params[:title]
    @new_policy.source = policy_sources
    @new_policy.policy_output = output
    @new_policy.input_requirements = input
    

    respond_to do |format|
      if @new_policy.save
        format.html { redirect_to elastic_policies_path, notice: "Elastic policy was successfully created." }
        format.json { render :show, status: :created, location: elastic_policies_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @new_policy.errors, status: :unprocessable_entity }
      end
    end


  end 

  private
    #getter for index
    def source_getter
      begin
        @getter = get_elastic_index
        p 'getter success' 
      rescue
        p 'getter fail'
        @getter = 'cyberapplicationplatformv2'
      end 
    end 

    # Use callbacks to share common setup or constraints between actions.
    def set_elastic_policy
      @elastic_policy = ElasticPolicy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elastic_policy_params
      params.require(:elastic_policy).permit(:title, :source, :policy_output, :input_requirements)
    end
end
