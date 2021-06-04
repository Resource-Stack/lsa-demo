require "application_system_test_case"

class TableEntriesTest < ApplicationSystemTestCase
  setup do
    @table_entry = table_entries(:one)
  end

  test "visiting the index" do
    visit table_entries_url
    assert_selector "h1", text: "Table Entries"
  end

  test "creating a Table entry" do
    visit table_entries_url
    click_on "New Table Entry"

    fill_in "Field one", with: @table_entry.field_one
    fill_in "Field three", with: @table_entry.field_three
    fill_in "Field two", with: @table_entry.field_two
    click_on "Create Table entry"

    assert_text "Table entry was successfully created"
    click_on "Back"
  end

  test "updating a Table entry" do
    visit table_entries_url
    click_on "Edit", match: :first

    fill_in "Field one", with: @table_entry.field_one
    fill_in "Field three", with: @table_entry.field_three
    fill_in "Field two", with: @table_entry.field_two
    click_on "Update Table entry"

    assert_text "Table entry was successfully updated"
    click_on "Back"
  end

  test "destroying a Table entry" do
    visit table_entries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Table entry was successfully destroyed"
  end
end
