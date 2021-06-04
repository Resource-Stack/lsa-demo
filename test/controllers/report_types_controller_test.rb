require 'test_helper'

class ReportTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_type = report_types(:one)
  end

  test "should get index" do
    get report_types_url
    assert_response :success
  end

  test "should get new" do
    get new_report_type_url
    assert_response :success
  end

  test "should create report_type" do
    assert_difference('ReportType.count') do
      post report_types_url, params: { report_type: { title: @report_type.title } }
    end

    assert_redirected_to report_type_url(ReportType.last)
  end

  test "should show report_type" do
    get report_type_url(@report_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_type_url(@report_type)
    assert_response :success
  end

  test "should update report_type" do
    patch report_type_url(@report_type), params: { report_type: { title: @report_type.title } }
    assert_redirected_to report_type_url(@report_type)
  end

  test "should destroy report_type" do
    assert_difference('ReportType.count', -1) do
      delete report_type_url(@report_type)
    end

    assert_redirected_to report_types_url
  end
end
