require "application_system_test_case"

class MasterTablesTest < ApplicationSystemTestCase
  setup do
    @master_table = master_tables(:one)
  end

  test "visiting the index" do
    visit master_tables_url
    assert_selector "h1", text: "Master Tables"
  end

  test "creating a Master table" do
    visit master_tables_url
    click_on "New Master Table"

    fill_in "Field one", with: @master_table.field_one
    fill_in "Field three", with: @master_table.field_three
    fill_in "Field two", with: @master_table.field_two
    click_on "Create Master table"

    assert_text "Master table was successfully created"
    click_on "Back"
  end

  test "updating a Master table" do
    visit master_tables_url
    click_on "Edit", match: :first

    fill_in "Field one", with: @master_table.field_one
    fill_in "Field three", with: @master_table.field_three
    fill_in "Field two", with: @master_table.field_two
    click_on "Update Master table"

    assert_text "Master table was successfully updated"
    click_on "Back"
  end

  test "destroying a Master table" do
    visit master_tables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Master table was successfully destroyed"
  end
end
