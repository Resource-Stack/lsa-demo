require "application_system_test_case"

class ReportValuesTest < ApplicationSystemTestCase
  setup do
    @report_value = report_values(:one)
  end

  test "visiting the index" do
    visit report_values_url
    assert_selector "h1", text: "Report Values"
  end

  test "creating a Report value" do
    visit report_values_url
    click_on "New Report Value"

    fill_in "Report type", with: @report_value.report_type_id
    fill_in "Title", with: @report_value.title
    click_on "Create Report value"

    assert_text "Report value was successfully created"
    click_on "Back"
  end

  test "updating a Report value" do
    visit report_values_url
    click_on "Edit", match: :first

    fill_in "Report type", with: @report_value.report_type_id
    fill_in "Title", with: @report_value.title
    click_on "Update Report value"

    assert_text "Report value was successfully updated"
    click_on "Back"
  end

  test "destroying a Report value" do
    visit report_values_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report value was successfully destroyed"
  end
end
