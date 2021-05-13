#https://dzone.com/articles/23-useful-elasticsearch-example-queries
class MasterTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master_table, only: %i[ show edit update destroy ]
  before_action :set_header_values
  include ElasticSearchHelper

  # GET /master_tables or /master_tables.json
  def index
    #@master_tables = MasterTable.all
      p current_user.master_table
      p MasterTable.first.inspect
    if current_user.master_table.present?
      p 'true'
      @master_table = current_user.master_table
    else
      p 'false'
    end 

    @uniqueEntries = [1,2,3,4,5]

  end

  # GET /master_tables/1 or /master_tables/1.json
  def show
  end

  # GET /master_tables/new
  def new
    @master_table = MasterTable.new
  end

  # GET /master_tables/1/edit
  def edit
  end

  # POST /master_tables or /master_tables.json
  def create
    @master_table = MasterTable.new(master_table_params)

    respond_to do |format|
      if @master_table.save
        format.html { redirect_to @master_table, notice: "Master table was successfully created." }
        format.json { render :show, status: :created, location: @master_table }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @master_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_tables/1 or /master_tables/1.json
  def update
    respond_to do |format|
      if @master_table.update(master_table_params)
        format.html { redirect_to @master_table, notice: "Master table was successfully updated." }
        format.json { render :show, status: :ok, location: @master_table }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @master_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_tables/1 or /master_tables/1.json
  def destroy
    @master_table.destroy
    respond_to do |format|
      format.html { redirect_to master_tables_url, notice: "Master table was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_input
    p 'update input' 
    #Get A Value
        tightResponse = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500', 
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
    if passed_id == 'query_key_selection_id'
      @inputID = 'query_value_selection_id'
      p 'here'
    else 
      id_value = passed_id.split('_')
      p id_value
      @inputID = 'query_value_selection_id_' + id_value[id_value.length-1].to_s
    end 
  end 

  def query_module
    p 'hit'
    #p params[:end_date]
    #p params[:start_date]
    p params[:key_values]
    key_value_parse = params[:key_values].split(',')


    lock_chain = Hash.new
    count = 0 
    values = []
    my_index = 0
    kv_length = key_value_parse.length

    key_value_parse.each do |kv|
      if @headerValues.include?(kv) 
          #account for first key, and then reset when a key is found
          if count == 0
            @set_key = kv
          else
            lock_chain[@set_key] = values
            @set_key = kv
            values = []
            count = 0
          end 
          count = count + 1
      else 
        values.push(kv)
      end 

      #The End of the array is a VALUE, finalize hash
      my_index+=1
      if my_index == kv_length
        lock_chain[@set_key] = values
      end 

    end 
    logger.debug("final:: #{lock_chain}")

    ### Construct Query
    #testing 
    response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500',  
      :body => {
        :query => {
          :bool => {
            :must => {
              :bool => { 
                :should => [
                  { "match": { "DeviceWired": "Yes" }},
                  { "match": { "DeviceWired": "No" }}
                ],
                "must": { "match": { "DeviceWired": "Yes" }},
                "must": { "match": { "DeviceWired": "No" }}  
              }
            },
            "must_not": { "match": {"authors": "radu gheorge" }}
          }
        }
      }.to_json,
        :headers => {
          "Content-Type" => "application/json"
        }
    )

    @jsonData = JSON.parse(response.body)
    p @jsonData
    ### End query

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
    def set_master_table
      @master_table = MasterTable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def master_table_params
      params.require(:master_table).permit(:field_one, :field_two, :field_three, :field_four, :field_five, :field_six, :field_seven, :field_eight, :field_nine, :field_ten, :user_id)
    end
end
