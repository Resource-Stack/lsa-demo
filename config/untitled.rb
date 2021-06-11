# User will upload a CSV
# First row from CSV will be parsed to create 
# Path will be predefined
# Host will be predefined for now. (Options will eventually become a dropdown)
# Index will be predefined for now.

#How will we delete





#https://qbox.io/blog/import-csv-elasticsearch-logstash-sincedb
#4 
logstash_path = "/home/timo/bitcoin-data/*.csv" # folder location of CSV
logstash_column = [] #parse the first row of the uploaded CSV
logstash_host = 'http://dev15.resourcestack.com:9200/'
logstash_index = 'cyberapplicationplatformv2' #admin defined options, related to source 
logstash_string = 


input {
  file {
    path => logstash_path #Ruby file Location
    start_position => "beginning"
   sincedb_path => "/dev/null"
  }
}
filter {
  csv {
      separator => ","
      columns => logstash_column #PreDefined
  }
}
output {
   elasticsearch {
     hosts => logstash_host  #Dev15
     index => logstash_index #Preset
  }
stdout {}
}


#elasticHealth: curl http://localhost:9200/_cluster/health?pretty

#Simple Version... User uploads a CSV to directory... Ruby System Call Executes update 

#can execute a rails script to mv the file to proper name


