require "application_system_test_case"

class CsvUploadsTest < ApplicationSystemTestCase
  setup do
    @csv_upload = csv_uploads(:one)
  end

  test "visiting the index" do
    visit csv_uploads_url
    assert_selector "h1", text: "Csv Uploads"
  end

  test "creating a Csv upload" do
    visit csv_uploads_url
    click_on "New Csv Upload"

    check "Flagged" if @csv_upload.flagged
    fill_in "User", with: @csv_upload.user_id
    click_on "Create Csv upload"

    assert_text "Csv upload was successfully created"
    click_on "Back"
  end

  test "updating a Csv upload" do
    visit csv_uploads_url
    click_on "Edit", match: :first

    check "Flagged" if @csv_upload.flagged
    fill_in "User", with: @csv_upload.user_id
    click_on "Update Csv upload"

    assert_text "Csv upload was successfully updated"
    click_on "Back"
  end

  test "destroying a Csv upload" do
    visit csv_uploads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Csv upload was successfully destroyed"
  end
end
