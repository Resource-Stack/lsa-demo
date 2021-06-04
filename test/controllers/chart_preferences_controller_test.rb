require 'test_helper'

class ChartPreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chart_preference = chart_preferences(:one)
  end

  test "should get index" do
    get chart_preferences_url
    assert_response :success
  end

  test "should get new" do
    get new_chart_preference_url
    assert_response :success
  end

  test "should create chart_preference" do
    assert_difference('ChartPreference.count') do
      post chart_preferences_url, params: { chart_preference: { hide_table: @chart_preference.hide_table, table_name: @chart_preference.table_name, user_id: @chart_preference.user_id } }
    end

    assert_redirected_to chart_preference_url(ChartPreference.last)
  end

  test "should show chart_preference" do
    get chart_preference_url(@chart_preference)
    assert_response :success
  end

  test "should get edit" do
    get edit_chart_preference_url(@chart_preference)
    assert_response :success
  end

  test "should update chart_preference" do
    patch chart_preference_url(@chart_preference), params: { chart_preference: { hide_table: @chart_preference.hide_table, table_name: @chart_preference.table_name, user_id: @chart_preference.user_id } }
    assert_redirected_to chart_preference_url(@chart_preference)
  end

  test "should destroy chart_preference" do
    assert_difference('ChartPreference.count', -1) do
      delete chart_preference_url(@chart_preference)
    end

    assert_redirected_to chart_preferences_url
  end
end
