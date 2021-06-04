require 'test_helper'

class ElasticReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @elastic_report = elastic_reports(:one)
  end

  test "should get index" do
    get elastic_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_elastic_report_url
    assert_response :success
  end

  test "should create elastic_report" do
    assert_difference('ElasticReport.count') do
      post elastic_reports_url, params: { elastic_report: { report_type_id: @elastic_report.report_type_id, report_value_id: @elastic_report.report_value_id } }
    end

    assert_redirected_to elastic_report_url(ElasticReport.last)
  end

  test "should show elastic_report" do
    get elastic_report_url(@elastic_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_elastic_report_url(@elastic_report)
    assert_response :success
  end

  test "should update elastic_report" do
    patch elastic_report_url(@elastic_report), params: { elastic_report: { report_type_id: @elastic_report.report_type_id, report_value_id: @elastic_report.report_value_id } }
    assert_redirected_to elastic_report_url(@elastic_report)
  end

  test "should destroy elastic_report" do
    assert_difference('ElasticReport.count', -1) do
      delete elastic_report_url(@elastic_report)
    end

    assert_redirected_to elastic_reports_url
  end
end
