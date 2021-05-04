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

    # GET ALL (for input values)
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=50')
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
    
    ElasticReport.delete_all
    p '[REFRESH DATA]'

    #@json = {"took":69,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":17,"relation":"eq"},"max_score":1.0,"hits":[{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"9RpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"LSA,Laptop,Dan-laptop,10.0.0.3,9C-B6-D0-BD-ED-ED,Windows 10,Avast,No,intel i7,Minnesota USA\r","@version":"1","DeviceName":"Dan-laptop","DeviceOS":"Windows 10","Source":"LSA","DeviceAV":"Avast","DeviceChip":"intel i7","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Minnesota USA","DeviceIP":"10.0.0.3","@timestamp":"2021-04-12T04:42:02.941Z","DeviceMac":"9C-B6-D0-BD-ED-ED"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"_hpixHgB5sIurMUI-OzX","_score":1.0,"_source":{"DeviceWired":"Yes","DeviceType":"Laptop","message":"RSI,Laptop,Anuj-laptop,192.168.1.7,9C-B6-D0-BD-ED-EA,Windows 10,Mcafee,Yes,intel i7,Maryland USA\r","@version":"1","DeviceName":"Anuj-laptop","DeviceOS":"Windows 10","Source":"RSI","DeviceAV":"Mcafee","DeviceChip":"intel i7","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Maryland USA","DeviceIP":"192.168.1.7","@timestamp":"2021-04-12T04:42:02.940Z","DeviceMac":"9C-B6-D0-BD-ED-EA"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"8xpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"Yes","DeviceType":"Server","message":"RSI,Server,Third-Cloud,192.168.1.12,9C-B6-D0-BD-ED-AE,Centos,None,Yes,intel i7,New York USA\r","@version":"1","DeviceName":"Third-Cloud","DeviceOS":"Centos","Source":"RSI","DeviceAV":"None","DeviceChip":"intel i7","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"New York USA","DeviceIP":"192.168.1.12","@timestamp":"2021-04-12T04:42:02.941Z","DeviceMac":"9C-B6-D0-BD-ED-AE"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"ABpixHgB5sIurMUI-O3X","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"RSI,Laptop,Sameer-laptop,192.168.1.3,9C-B6-D0-BD-ED-EB,Windows 10,Symantec,No,Intel i7,Virginia USA\r","@version":"1","DeviceName":"Sameer-laptop","DeviceOS":"Windows 10","Source":"RSI","DeviceAV":"Symantec","DeviceChip":"Intel i7","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Virginia USA","DeviceIP":"192.168.1.3","@timestamp":"2021-04-12T04:42:02.939Z","DeviceMac":"9C-B6-D0-BD-ED-EB"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"ARpixHgB5sIurMUI-O3X","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"RSI,Laptop,Amit-laptop,192.168.1.16,9C-B6-D0-BD-ED-AG,Windows 10,Symantec,No,Intel i5,Virginia USA\r","@version":"1","DeviceName":"Amit-laptop","DeviceOS":"Windows 10","Source":"RSI","DeviceAV":"Symantec","DeviceChip":"Intel i5","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Virginia USA","DeviceIP":"192.168.1.16","@timestamp":"2021-04-12T04:42:02.941Z","DeviceMac":"9C-B6-D0-BD-ED-AG"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"_BpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"RSI,Laptop,Jishnu-laptop,192.168.1.15,9C-B6-D0-BD-ED-AH,Windows 10,Symantec,No,Intel i5,Arizona USA\r","@version":"1","DeviceName":"Jishnu-laptop","DeviceOS":"Windows 10","Source":"RSI","DeviceAV":"Symantec","DeviceChip":"Intel i5","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Arizona USA","DeviceIP":"192.168.1.15","@timestamp":"2021-04-12T04:42:02.942Z","DeviceMac":"9C-B6-D0-BD-ED-AH"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"-BpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"RSI,Laptop,Mason-laptop,192.168.1.5,9C-B6-D0-BD-ED-EY,MACOS,Symantec,No,intel i5,Texas USA\r","@version":"1","DeviceName":"Mason-laptop","DeviceOS":"MACOS","Source":"RSI","DeviceAV":"Symantec","DeviceChip":"intel i5","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Texas USA","DeviceIP":"192.168.1.5","@timestamp":"2021-04-12T04:42:02.940Z","DeviceMac":"9C-B6-D0-BD-ED-EY"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"-hpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"message":"\r","@version":"1","path":"C:/Users/samee/workspace/first_set_v3.csv","@timestamp":"2021-04-12T04:42:02.942Z","host":"DESKTOP-8NACH6E"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"9BpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"Yes","DeviceType":"Server","message":"RSI,Server,Second-Cloud,192.168.1.11,9C-B6-D0-BD-ED-AD,Centos,None,Yes,intel i7,New York USA\r","@version":"1","DeviceName":"Second-Cloud","DeviceOS":"Centos","Source":"RSI","DeviceAV":"None","DeviceChip":"intel i7","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"New York USA","DeviceIP":"192.168.1.11","@timestamp":"2021-04-12T04:42:02.941Z","DeviceMac":"9C-B6-D0-BD-ED-AD"}},{"_index":"cyberapplicationplatformv2","_type":"_doc","_id":"-xpixHgB5sIurMUI-OzW","_score":1.0,"_source":{"DeviceWired":"No","DeviceType":"Laptop","message":"RSI,Laptop,Harsh-laptop,192.168.1.4,9C-B6-D0-BD-ED-EX,MACOS,None,No,intel i5,Virginia USA\r","@version":"1","DeviceName":"Harsh-laptop","DeviceOS":"MACOS","Source":"RSI","DeviceAV":"None","DeviceChip":"intel i5","path":"C:/Users/samee/workspace/first_set_v3.csv","host":"DESKTOP-8NACH6E","Region":"Virginia USA","DeviceIP":"192.168.1.4","@timestamp":"2021-04-12T04:42:02.940Z","DeviceMac":"9C-B6-D0-BD-ED-EX"}}]}}
    # GET ALL
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=50')

      p '[RESPONSE CODE]'
      p response.code
      #Convert To JSON
      @responseBody = JSON.parse(response.body)
      p '[RESPONSE BODY]'
      p @responseBody
      #Get the HITS
      @data_hash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @data_hash[count] = k['_source']
        count = count + 1
      end 
      #ROWS
      #Get The Header Values
      @headerValues = []
      @data_hash[0].each do |kilo,alpha|
        @headerValues.push(kilo)
      end 

    #End Get All 

    ##
        @data_hash.each_value do |data|
            ElasticPolicy.all.each do |ep|
              logger.debug("POLICY: #{ep.title} input #{ep.input_requirements}")
                  @trueFalse = []
                  ep[:input_requirements].each do |policy_index,policy_KV|
                      data.each do |key,value|  


                        #logger.debug("Keys::: d #{key.to_s} == p #{policy_KV['key'].to_s}")
                        #logger.debug("Values::: d #{value.to_s} == p #{policy_KV['value'].to_s}")

                         if key.to_s == policy_KV['key'].to_s && value.to_s == policy_KV['value'].to_s
                           p ' MATCH'
                            @trueFalse.push(true)
                         end 
                            logger.debug("Length: tf#{@trueFalse.length} p#{ep.input_requirements.length}")
                            if ep[:input_requirements].size == @trueFalse.length
                              p 'eureka'
                                 ep[:policy_output].each do |kk,vv|
                                   er = ElasticReport.new 
                                   er.report_type_title = ReportType.find_by_title(vv['key']).title
                                   er.report_value_title = ReportValue.find_by_title(vv['value']).title
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
    # GET ALL (for input values)
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=50')
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
    policy_sources = params[:source].split(',')
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

  @elastic_policy.update_attributes(:title => params[:title], :source => policy_sources, :policy_output => output, :input_requirements => input)
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
        tightResponse = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=50', 
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
    policy_sources = params[:source].split(',')
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
    # Use callbacks to share common setup or constraints between actions.
    def set_elastic_policy
      @elastic_policy = ElasticPolicy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elastic_policy_params
      params.require(:elastic_policy).permit(:title, :source, :policy_output, :input_requirements)
    end
end
