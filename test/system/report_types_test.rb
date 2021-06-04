require "application_system_test_case"

class ReportTypesTest < ApplicationSystemTestCase
  setup do
    @report_type = report_types(:one)
  end

  test "visiting the index" do
    visit report_types_url
    assert_selector "h1", text: "Report Types"
  end

  test "creating a Report type" do
    visit report_types_url
    click_on "New Report Type"

    fill_in "Title", with: @report_type.title
    click_on "Create Report type"

    assert_text "Report type was successfully created"
    click_on "Back"
  end

  test "updating a Report type" do
    visit report_types_url
    click_on "Edit", match: :first

    fill_in "Title", with: @report_type.title
    click_on "Update Report type"

    assert_text "Report type was successfully updated"
    click_on "Back"
  end

  test "destroying a Report type" do
    visit report_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report type was successfully destroyed"
  end
end
