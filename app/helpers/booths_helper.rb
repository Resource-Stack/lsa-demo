module BoothsHelper

  def fetch_booths_16
    # GET ALL
      response = HTTParty.get('http://dev15.resourcestack.com:9200/cyberapplicationplatformv2/_search?size=500')

      p '[MODULE MODULE MODULE]'
      #p response.code
      #Convert To JSON
      @responseBody = JSON.parse(response.body)
      #p '[RESPONSE BODY]'
      #p @responseBody
      #Get the HITS
      @hashHash = Hash.new  
      count = 0
      @responseBody['hits']['hits'].each do |k,v|
        @hashHash[count] = k['_source']
        count = count + 1
      end 
      #ROWS
      #Get The Header Values
      @headerValues = []
      @hashHash[0].each do |kilo,alpha|
        @headerValues.push(kilo)
      end 

    #End Get All
    snippets = $redis.get("snippets")
    if snippets.nil?
      snippets = @headerValues.to_json
      $redis.set("snippets", snippets)
      $redis.expire("snippets", 1.hour.to_i)
    end 
    JSON.load snippets

  end 


end 