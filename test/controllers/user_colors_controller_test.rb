require 'test_helper'

class UserColorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_color = user_colors(:one)
  end

  test "should get index" do
    get user_colors_url
    assert_response :success
  end

  test "should get new" do
    get new_user_color_url
    assert_response :success
  end

  test "should create user_color" do
    assert_difference('UserColor.count') do
      post user_colors_url, params: { user_color: { color: @user_color.color, table_name: @user_color.table_name, user_id: @user_color.user_id } }
    end

    assert_redirected_to user_color_url(UserColor.last)
  end

  test "should show user_color" do
    get user_color_url(@user_color)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_color_url(@user_color)
    assert_response :success
  end

  test "should update user_color" do
    patch user_color_url(@user_color), params: { user_color: { color: @user_color.color, table_name: @user_color.table_name, user_id: @user_color.user_id } }
    assert_redirected_to user_color_url(@user_color)
  end

  test "should destroy user_color" do
    assert_difference('UserColor.count', -1) do
      delete user_color_url(@user_color)
    end

    assert_redirected_to user_colors_url
  end
end
