require "application_system_test_case"

class ElasticReportsTest < ApplicationSystemTestCase
  setup do
    @elastic_report = elastic_reports(:one)
  end

  test "visiting the index" do
    visit elastic_reports_url
    assert_selector "h1", text: "Elastic Reports"
  end

  test "creating a Elastic report" do
    visit elastic_reports_url
    click_on "New Elastic Report"

    fill_in "Report type", with: @elastic_report.report_type_id
    fill_in "Report value", with: @elastic_report.report_value_id
    click_on "Create Elastic report"

    assert_text "Elastic report was successfully created"
    click_on "Back"
  end

  test "updating a Elastic report" do
    visit elastic_reports_url
    click_on "Edit", match: :first

    fill_in "Report type", with: @elastic_report.report_type_id
    fill_in "Report value", with: @elastic_report.report_value_id
    click_on "Update Elastic report"

    assert_text "Elastic report was successfully updated"
    click_on "Back"
  end

  test "destroying a Elastic report" do
    visit elastic_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Elastic report was successfully destroyed"
  end
end
