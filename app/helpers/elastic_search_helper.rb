module ElasticSearchHelper
  require 'json'


  def fetch_all  
    p "FETCH ALL"
    elastic_all_values = $redis.get("elastic_all_values") 
    #if elastic_all_values.nil?
    # GET ALL
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=100')

      p '[MODULE MODULE MODULE]'
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
          @headerValues = []
          check = JSON.parse(@data_rows[0])
          check.each do |kilo,alpha|
            @headerValues.push(kilo)
          end 

      elastic_all_values = @data_rows.to_json
      $redis.set("elastic_all_values", elastic_all_values)
      $redis.expire("elastic_all_values", 1.hour.to_i)
    #end 
    JSON.load elastic_all_values
    

  end 

  def fetch_header 
    p "FETCH HEADER"
    elastic_header_values = $redis.get("elastic_header_values")
    if elastic_header_values.nil?
    # GET ALL
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=100')

      p '[MODULE MODULE MODULE]'
      @responseBody = JSON.parse(response.body)
      @hashHash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @hashHash[count] = k['_source']
        count = count + 1
      end 

      @headerValues = []
      @hashHash[0].each do |kilo,alpha|
        @headerValues.push(kilo)
      end 
    #End Get All
      elastic_header_values = @headerValues.to_json
      $redis.set("elastic_header_values", elastic_header_values)
      $redis.expire("elastic_header_values", 1.hour.to_i)
    end 
    JSON.load elastic_header_values
  end 


  def fetch_summary
      p "FETCH SUMMARY "
      elastic_fetch_summ = $redis.get('elastic_fetch_summ')
      #if elastic_fetch_summary.nil?
          @keyValueCountHash = Hash.new
          @headerValues.each do |x|
                #if x.to_s == 'path' || 'host '
                  tightResponse = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=50', 
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
                  #p @keyValueCountHash
          #end 

          elastic_fetch_summ = [@keyValueCountHash].to_json
          p elastic_fetch_summ
          $redis.set("elastic_fetch_summ", elastic_fetch_summ)
          $redis.expire("elastic_fetch_summ", 1.hour.to_i)

      end 
      JSON.load elastic_fetch_summ

  end 




end 