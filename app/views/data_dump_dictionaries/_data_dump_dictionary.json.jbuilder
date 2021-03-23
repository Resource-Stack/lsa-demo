json.extract! data_dump_dictionary, :id, :user_id, :source_id, :csv_header_name, :created_at, :updated_at
json.url data_dump_dictionary_url(data_dump_dictionary, format: :json)
