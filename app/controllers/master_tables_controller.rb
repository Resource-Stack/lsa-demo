#https://dzone.com/articles/23-useful-elasticsearch-example-queries
class MasterTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master_table, only: %i[ show edit update destroy ]
  before_action :set_header_values
  include ElasticSearchHelper
  require 'json'

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
    @user_colors = current_user.user_colors.pluck(:color)
    p params[:key_values]

    condition = params[:query_condition_value]    
    key_value_parse = params[:key_values].split(',')
    logger.debug("[STEP ONE]")
    # PARAMETERS TO KEY VALUE
    lock_chain = Hash.new
    count = 0 
    values = []
    my_index = 0
    kv_length = key_value_parse.length
    #Create Hash
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

    logger.debug("[STEP 2 ] #{lock_chain}")
    # KEY/VALUE TO Elastic Format
    @string_array = []
      lock_chain.each do |k,v|
          if v.length > 1 
                v.each do |vvv|
                  @string_array.push({"match" => {k.to_s => vvv.to_s}})   
                end 
          else 
            @string_array.push({"match" => {k.to_s => v[0].to_s}})  
          end
      end 
      p @string_array

    logger.debug("[STEP THREE]")
    #move into seperate logic
    if condition == "AND"
        response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500',  
          :body => {
            :query => {
              :bool => {
                :must => {
                  :bool => {
                  :must => @string_array 
                 }
                }
              }
            }
          }.to_json,
            :headers => {
              "Content-Type" => "application/json"
            }
        )
    else # THIS IS AN OR STATEMENT
        response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500',  
          :body => {
            :query => {
              :bool => {
                :must => {
                  :bool => {
                  :should => @string_array 
                 }
                }
              }
            }
          }.to_json,
            :headers => {
              "Content-Type" => "application/json"
            }
        )
    end 
    logger.debug("[STEP FOUR]")
    # Response
    @jsonData = JSON.parse(response.body)


      @hashHash = Hash.new  
      @query_data_rows = []
      count = 0
      @jsonData['hits']['hits'].each do |k,v|
        @hashHash[count] = k['_source']
        #p k['_source']
        @query_data_rows.push(k['_source'].to_json)
        count = count + 1
      end 
      logger.debug("S4 HASH::: #{@hashHash}")
      logger.debug("S4 HASH:::")
      logger.debug("S4 ARRAY::: #{@query_data_rows}")


    ### End query
    logger.debug("[STEP FIVE]")
    #CREATE THE GRAPH VALUE
    @summarized_hash = Hash.new
    @headerValues.each do |hv|
      @summarized_hash[hv] = []
    end 
    @hashHash.each do |k,v|
          v.each do |key,value|


              current_set = @summarized_hash[key]

              logger.debug("S5 current::: #{key}")
              logger.debug("S5 current::: #{current_set}")
              if !current_set.nil? && current_set.length != 0
                  #Values Only
                  value_only_array = []
                  current_set.each do |x| 
                    value_only_array.push(x[0])
                  end 
                  #Check if it is included 
                  if value_only_array.include?(value)
                    #Increment
                    current_set.each do |x| 
                        if x[0].to_s == value.to_s
                          x[1] = x[1].to_i + 1
                        end
                    end 
                  else
                    #NOT included, push new value
                    p 'one'                    
                    @summarized_hash[key] << [value, 1]
                  end 

              elsif current_set != nil
                p 'initial push'
                @summarized_hash[key] << [value, 1]
              else 
                p 'two'
                @summarized_hash[key] = ['nil', 1]
              end
          end 
    end 

    #p 'Final'
    #p  @summarized_hash 

  new_new = $redis.get("new_new") 
  if new_new.nil?
        $redis.set("new_new", [@summarized_hash].to_json)
        $redis.expire("new_new", 1.hour.to_i)
  else
      $redis.del('new_new')
      $redis.set("new_new", [@summarized_hash].to_json)
      $redis.expire("new_new", 1.hour.to_i)
  end 
  JSON.load new_new
  p new_new

  user_pref = ChartPreference.where(:user => current_user, :hide_table =>true).pluck(:table_name)
    @summarized_hash.each do |k,v|
      if user_pref.include?(k)
        @summarized_hash.delete(k)
      end 
    end 


 
  end 


  def hide_search_chart
        new_new = $redis.get("new_new") 

        @user_colors = current_user.user_colors.pluck(:color)
        
        #search for chart first
        if ChartPreference.find_by(table_name: params[:chart_name]).present?
          cp = ChartPreference.find_by(table_name: params[:chart_name])
        end 

        if cp.present?
          cp.update_attribute(:hide_table, true)
        else
          hide_chart = ChartPreference.new
          hide_chart.table_name = params[:chart_name]
          hide_chart.hide_table = true
          hide_chart.user = current_user
          hide_chart.save
        end 

        # should only be charts that are true.... 
        user_pref = ChartPreference.where(:user => current_user, :hide_table =>true).pluck(:table_name)
        
          after_hash = JSON.parse(new_new)
          @summarized_hash = after_hash[0] 
          @summarized_hash.each do |k,v|
            if user_pref.include?(k)
              @summarized_hash.delete(k)
            end 
          end 
      ##
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
