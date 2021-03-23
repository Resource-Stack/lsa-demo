require "application_system_test_case"

class DataDumpDictionariesTest < ApplicationSystemTestCase
  setup do
    @data_dump_dictionary = data_dump_dictionaries(:one)
  end

  test "visiting the index" do
    visit data_dump_dictionaries_url
    assert_selector "h1", text: "Data Dump Dictionaries"
  end

  test "creating a Data dump dictionary" do
    visit data_dump_dictionaries_url
    click_on "New Data Dump Dictionary"

    fill_in "Csv header name", with: @data_dump_dictionary.csv_header_name
    fill_in "Source", with: @data_dump_dictionary.source_id
    fill_in "User", with: @data_dump_dictionary.user_id
    click_on "Create Data dump dictionary"

    assert_text "Data dump dictionary was successfully created"
    click_on "Back"
  end

  test "updating a Data dump dictionary" do
    visit data_dump_dictionaries_url
    click_on "Edit", match: :first

    fill_in "Csv header name", with: @data_dump_dictionary.csv_header_name
    fill_in "Source", with: @data_dump_dictionary.source_id
    fill_in "User", with: @data_dump_dictionary.user_id
    click_on "Update Data dump dictionary"

    assert_text "Data dump dictionary was successfully updated"
    click_on "Back"
  end

  test "destroying a Data dump dictionary" do
    visit data_dump_dictionaries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Data dump dictionary was successfully destroyed"
  end
end
