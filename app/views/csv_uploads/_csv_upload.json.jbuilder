json.extract! csv_upload, :id, :user_id, :flagged, :created_at, :updated_at
json.url csv_upload_url(csv_upload, format: :json)
