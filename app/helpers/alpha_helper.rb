module AlphaHelper
 require 'json'
 def get_elastic_index
    p "get index"
    current_index = $redis.get("elastic_index") 
    if current_index.nil?
      $redis.set("elastic_index", 'cyberapplicationplatformv2')
      $redis.expire("elastic_index", 1.min.to_i) 
  	else
  		current_index
    end
    #JSON.load elastic_index
 end 

 def set_elastic_index(new_index)
 	p 'hit'
 	p new_index
 	  reset_index = $redis.del('elastic_index')
    $redis.set("elastic_index", new_index)

 end 
end 

 