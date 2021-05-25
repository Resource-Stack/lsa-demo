require "application_system_test_case"

class ChartPreferencesTest < ApplicationSystemTestCase
  setup do
    @chart_preference = chart_preferences(:one)
  end

  test "visiting the index" do
    visit chart_preferences_url
    assert_selector "h1", text: "Chart Preferences"
  end

  test "creating a Chart preference" do
    visit chart_preferences_url
    click_on "New Chart Preference"

    check "Hide table" if @chart_preference.hide_table
    fill_in "Table name", with: @chart_preference.table_name
    fill_in "User", with: @chart_preference.user_id
    click_on "Create Chart preference"

    assert_text "Chart preference was successfully created"
    click_on "Back"
  end

  test "updating a Chart preference" do
    visit chart_preferences_url
    click_on "Edit", match: :first

    check "Hide table" if @chart_preference.hide_table
    fill_in "Table name", with: @chart_preference.table_name
    fill_in "User", with: @chart_preference.user_id
    click_on "Update Chart preference"

    assert_text "Chart preference was successfully updated"
    click_on "Back"
  end

  test "destroying a Chart preference" do
    visit chart_preferences_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Chart preference was successfully destroyed"
  end
end
