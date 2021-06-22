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
 	p 'set INDEX'
    #reset elastic index
 	 reset_index = $redis.del('elastic_index')
    #reset elastic summary 
    elastic_fetch_summ = $redis.del('elastic_fetch_summ') 
    elastic_all_values = $redis.del("elastic_all_values") 
    #
    $redis.set("elastic_index", new_index)
    set_index = $redis.get("elastic_index") 
    return set_index
 end 
end 

 