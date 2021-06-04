require "application_system_test_case"

class DataDumpTablesTest < ApplicationSystemTestCase
  setup do
    @data_dump_table = data_dump_tables(:one)
  end

  test "visiting the index" do
    visit data_dump_tables_url
    assert_selector "h1", text: "Data Dump Tables"
  end

  test "creating a Data dump table" do
    visit data_dump_tables_url
    click_on "New Data Dump Table"

    fill_in "Csv header name", with: @data_dump_table.csv_header_name
    fill_in "Csv row value", with: @data_dump_table.csv_row_value
    fill_in "Source", with: @data_dump_table.source_id
    fill_in "User", with: @data_dump_table.user_id
    click_on "Create Data dump table"

    assert_text "Data dump table was successfully created"
    click_on "Back"
  end

  test "updating a Data dump table" do
    visit data_dump_tables_url
    click_on "Edit", match: :first

    fill_in "Csv header name", with: @data_dump_table.csv_header_name
    fill_in "Csv row value", with: @data_dump_table.csv_row_value
    fill_in "Source", with: @data_dump_table.source_id
    fill_in "User", with: @data_dump_table.user_id
    click_on "Update Data dump table"

    assert_text "Data dump table was successfully updated"
    click_on "Back"
  end

  test "destroying a Data dump table" do
    visit data_dump_tables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Data dump table was successfully destroyed"
  end
end
