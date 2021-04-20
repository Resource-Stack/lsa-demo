require 'test_helper'

class ReportValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_value = report_values(:one)
  end

  test "should get index" do
    get report_values_url
    assert_response :success
  end

  test "should get new" do
    get new_report_value_url
    assert_response :success
  end

  test "should create report_value" do
    assert_difference('ReportValue.count') do
      post report_values_url, params: { report_value: { report_type_id: @report_value.report_type_id, title: @report_value.title } }
    end

    assert_redirected_to report_value_url(ReportValue.last)
  end

  test "should show report_value" do
    get report_value_url(@report_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_value_url(@report_value)
    assert_response :success
  end

  test "should update report_value" do
    patch report_value_url(@report_value), params: { report_value: { report_type_id: @report_value.report_type_id, title: @report_value.title } }
    assert_redirected_to report_value_url(@report_value)
  end

  test "should destroy report_value" do
    assert_difference('ReportValue.count', -1) do
      delete report_value_url(@report_value)
    end

    assert_redirected_to report_values_url
  end
end
