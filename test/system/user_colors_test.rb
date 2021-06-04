require "application_system_test_case"

class UserColorsTest < ApplicationSystemTestCase
  setup do
    @user_color = user_colors(:one)
  end

  test "visiting the index" do
    visit user_colors_url
    assert_selector "h1", text: "User Colors"
  end

  test "creating a User color" do
    visit user_colors_url
    click_on "New User Color"

    fill_in "Color", with: @user_color.color
    fill_in "Table name", with: @user_color.table_name
    fill_in "User", with: @user_color.user_id
    click_on "Create User color"

    assert_text "User color was successfully created"
    click_on "Back"
  end

  test "updating a User color" do
    visit user_colors_url
    click_on "Edit", match: :first

    fill_in "Color", with: @user_color.color
    fill_in "Table name", with: @user_color.table_name
    fill_in "User", with: @user_color.user_id
    click_on "Update User color"

    assert_text "User color was successfully updated"
    click_on "Back"
  end

  test "destroying a User color" do
    visit user_colors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User color was successfully destroyed"
  end
end
