json.extract! data_dictionary, :id, :user_id, :admin_id, :csv_header_name, :maps_to, :created_at, :updated_at
json.url data_dictionary_url(data_dictionary, format: :json)
