require 'test_helper'

class DataDictionariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_dictionary = data_dictionaries(:one)
  end

  test "should get index" do
    get data_dictionaries_url
    assert_response :success
  end

  test "should get new" do
    get new_data_dictionary_url
    assert_response :success
  end

  test "should create data_dictionary" do
    assert_difference('DataDictionary.count') do
      post data_dictionaries_url, params: { data_dictionary: { admin_id: @data_dictionary.admin_id, csv_header_name: @data_dictionary.csv_header_name, maps_to: @data_dictionary.maps_to, user_id: @data_dictionary.user_id } }
    end

    assert_redirected_to data_dictionary_url(DataDictionary.last)
  end

  test "should show data_dictionary" do
    get data_dictionary_url(@data_dictionary)
    assert_response :success
  end

  test "should get edit" do
    get edit_data_dictionary_url(@data_dictionary)
    assert_response :success
  end

  test "should update data_dictionary" do
    patch data_dictionary_url(@data_dictionary), params: { data_dictionary: { admin_id: @data_dictionary.admin_id, csv_header_name: @data_dictionary.csv_header_name, maps_to: @data_dictionary.maps_to, user_id: @data_dictionary.user_id } }
    assert_redirected_to data_dictionary_url(@data_dictionary)
  end

  test "should destroy data_dictionary" do
    assert_difference('DataDictionary.count', -1) do
      delete data_dictionary_url(@data_dictionary)
    end

    assert_redirected_to data_dictionaries_url
  end
end
