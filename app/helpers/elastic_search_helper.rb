module ElasticSearchHelper
  require 'json'


  def fetch_all  
    p "FETCH ALL"
    elastic_all_values = $redis.get("elastic_all_values") 
    #p elastic_all_values.class
    #p elastic_all_values.nil?
    if elastic_all_values.nil? #&& elastic_all_values.length > 1
    # GET ALL
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500')

      #p '[MODULE MODULE MODULE]'
      @responseBody = JSON.parse(response.body)
      @hashHash = Hash.new  
      @data_rows = []
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @hashHash[count] = k['_source']
        #p k['_source']
        @data_rows.push(k['_source'].to_json)
        count = count + 1
      end 
      #End Get All
          $headerValues = []
          check = JSON.parse(@data_rows[0])
          check.each do |kilo,alpha|
            $headerValues.push(kilo)
          end 

      elastic_all_values = @data_rows.to_json
      $redis.set("elastic_all_values", elastic_all_values)
      $redis.expire("elastic_all_values", 1.hour.to_i)
    end 
    JSON.load elastic_all_values
  end 

  def fetch_summary
      p "FETCH SUMMARY "
      elastic_fetch_summ = $redis.get('elastic_fetch_summ')
      #p elastic_fetch_summ.nil?
      #p elastic_fetch_summ.class

      if elastic_fetch_summ.nil? ##&& elastic_all_values.length > 1
        elastic_all_values = $redis.get("elastic_all_values")  
        headerValues = []
        #p 'All Values '       
        #p elastic_all_values
        check = JSON.parse(elastic_all_values)[0] 
          JSON.parse(check).each do |kilo,alpha|
            headerValues.push(kilo)
          end 
         # p 'HEADER VALUES'
         # p headerValues

          @keyValueCountHash = Hash.new 
          headerValues.each do |x|
                #if x.to_s == 'path' || 'host '
                  tightResponse = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500', 
                        :body => {
                          :aggs => {
                            :langs => { 
                              :terms => {
                                'field' => x.to_s + '.keyword','size' => 500
                              }
                            }
                          },
                          "fields" => [x.to_s + ".keyword"],
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
                  @importantvalues.each do |k,v|
                      @valuesArray = []
                      k.each do |key,value| 

                        #other value is count
                          valueCount +=1

                          if valueCount == 2
                            valueCount = 0
                          end 

                         if valueCount == 1
                           @valuesArray[0] = value
                         else
                            @valuesArray[1] = value
                         end 
                      end 


                    if @keyValueCountHash.include?(x.to_s)
                      #pre existing
                      @keyValueCountHash[x] << @valuesArray
                    else 
                      #new
                      @keyValueCountHash[x] = [@valuesArray]
                    end 
                  end 
                  p '[HASH]'
          #        p @keyValueCountHash
         end  

          elastic_fetch_summ = [@keyValueCountHash].to_json
          #p elastic_fetch_summ
          $redis.set("elastic_fetch_summ", elastic_fetch_summ)
          $redis.expire("elastic_fetch_summ", 1.hour.to_i)

      end 
      JSON.load elastic_fetch_summ

#elastic_fetch_summ = $redis.del('elastic_fetch_summ')
#elastic_all_values = $redis.del("elastic_all_values")  

  end 

  def devices_over_time 
    p 'hit'
      tightResponse = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500', 
                              :body => {
                                :aggs => {
                                  :langs => { 
                                    :terms => {
                                      'field' => '@timestamp' + '.keyword','size' => 500
                                    }
                                  }
                                },
                                "fields" => ['@timestamp' + '.keyword'],
                                "_source" => false
                              }.to_json,
                                :headers => {
                                  "Content-Type" => "application/json"
                                }
                            )

                         @time_stamp = JSON.parse(tightResponse.body)
                         @time_stamp_values = @time_stamp['aggregations']['langs']['buckets']

                         logger.debug("information", @time_stamp_values)
                         #Get Values From JSON
=begin
                        valueCount = 0
                        @importantvalues.each do |k,v|
                            @valuesArray = []
                            k.each do |key,value| 

                              #other value is count
                                valueCount +=1

                                if valueCount == 2
                                  valueCount = 0
                                end 

                               if valueCount == 1
                                 @valuesArray[0] = value
                               else
                                  @valuesArray[1] = value
                               end 
                            end 


                          if @keyValueCountHash.include?(x.to_s)
                            #pre existing
                            @keyValueCountHash[x] << @valuesArray
                          else 
                            #new
                            @keyValueCountHash[x] = [@valuesArray]
                          end 
                        end 
                        p '[HASH]'
                #        p @keyValueCountHash
=end
  end 




end 