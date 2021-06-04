json.extract! report_value, :id, :title, :report_type_id, :created_at, :updated_at
json.url report_value_url(report_value, format: :json)
