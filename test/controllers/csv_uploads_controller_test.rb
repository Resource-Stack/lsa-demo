require 'test_helper'

class CsvUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @csv_upload = csv_uploads(:one)
  end

  test "should get index" do
    get csv_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_csv_upload_url
    assert_response :success
  end

  test "should create csv_upload" do
    assert_difference('CsvUpload.count') do
      post csv_uploads_url, params: { csv_upload: { flagged: @csv_upload.flagged, user_id: @csv_upload.user_id } }
    end

    assert_redirected_to csv_upload_url(CsvUpload.last)
  end

  test "should show csv_upload" do
    get csv_upload_url(@csv_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_csv_upload_url(@csv_upload)
    assert_response :success
  end

  test "should update csv_upload" do
    patch csv_upload_url(@csv_upload), params: { csv_upload: { flagged: @csv_upload.flagged, user_id: @csv_upload.user_id } }
    assert_redirected_to csv_upload_url(@csv_upload)
  end

  test "should destroy csv_upload" do
    assert_difference('CsvUpload.count', -1) do
      delete csv_upload_url(@csv_upload)
    end

    assert_redirected_to csv_uploads_url
  end
end
