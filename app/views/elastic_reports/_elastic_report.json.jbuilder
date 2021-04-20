json.extract! elastic_report, :id, :report_type_id, :report_value_id, :created_at, :updated_at
json.url elastic_report_url(elastic_report, format: :json)
