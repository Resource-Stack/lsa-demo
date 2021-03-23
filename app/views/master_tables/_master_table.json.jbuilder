json.extract! master_table, :id, :field_one, :field_two, :field_three, :created_at, :updated_at
json.url master_table_url(master_table, format: :json)
