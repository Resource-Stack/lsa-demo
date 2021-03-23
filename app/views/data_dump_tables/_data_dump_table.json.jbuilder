json.extract! data_dump_table, :id, :user_id, :source_id, :csv_header_name, :csv_row_value, :created_at, :updated_at
json.url data_dump_table_url(data_dump_table, format: :json)
