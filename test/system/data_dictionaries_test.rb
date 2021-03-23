require "application_system_test_case"

class DataDictionariesTest < ApplicationSystemTestCase
  setup do
    @data_dictionary = data_dictionaries(:one)
  end

  test "visiting the index" do
    visit data_dictionaries_url
    assert_selector "h1", text: "Data Dictionaries"
  end

  test "creating a Data dictionary" do
    visit data_dictionaries_url
    click_on "New Data Dictionary"

    fill_in "Admin", with: @data_dictionary.admin_id
    fill_in "Csv header name", with: @data_dictionary.csv_header_name
    fill_in "Maps to", with: @data_dictionary.maps_to
    fill_in "User", with: @data_dictionary.user_id
    click_on "Create Data dictionary"

    assert_text "Data dictionary was successfully created"
    click_on "Back"
  end

  test "updating a Data dictionary" do
    visit data_dictionaries_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @data_dictionary.admin_id
    fill_in "Csv header name", with: @data_dictionary.csv_header_name
    fill_in "Maps to", with: @data_dictionary.maps_to
    fill_in "User", with: @data_dictionary.user_id
    click_on "Update Data dictionary"

    assert_text "Data dictionary was successfully updated"
    click_on "Back"
  end

  test "destroying a Data dictionary" do
    visit data_dictionaries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Data dictionary was successfully destroyed"
  end
end
