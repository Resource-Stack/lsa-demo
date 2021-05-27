module ElasticPoliciesHelper
require 'time'

    def random_datetime
      
      t1 = Time.parse("2020-01-01 14:40:34")
      t2 = Time.parse("2021-12-25 16:20:23")
      @random_datetime = rand(t1..t2)
    end 
end
