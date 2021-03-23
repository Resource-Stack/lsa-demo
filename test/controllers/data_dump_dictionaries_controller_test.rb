require 'test_helper'

class DataDumpDictionariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_dump_dictionary = data_dump_dictionaries(:one)
  end

  test "should get index" do
    get data_dump_dictionaries_url
    assert_response :success
  end

  test "should get new" do
    get new_data_dump_dictionary_url
    assert_response :success
  end

  test "should create data_dump_dictionary" do
    assert_difference('DataDumpDictionary.count') do
      post data_dump_dictionaries_url, params: { data_dump_dictionary: { csv_header_name: @data_dump_dictionary.csv_header_name, source_id: @data_dump_dictionary.source_id, user_id: @data_dump_dictionary.user_id } }
    end

    assert_redirected_to data_dump_dictionary_url(DataDumpDictionary.last)
  end

  test "should show data_dump_dictionary" do
    get data_dump_dictionary_url(@data_dump_dictionary)
    assert_response :success
  end

  test "should get edit" do
    get edit_data_dump_dictionary_url(@data_dump_dictionary)
    assert_response :success
  end

  test "should update data_dump_dictionary" do
    patch data_dump_dictionary_url(@data_dump_dictionary), params: { data_dump_dictionary: { csv_header_name: @data_dump_dictionary.csv_header_name, source_id: @data_dump_dictionary.source_id, user_id: @data_dump_dictionary.user_id } }
    assert_redirected_to data_dump_dictionary_url(@data_dump_dictionary)
  end

  test "should destroy data_dump_dictionary" do
    assert_difference('DataDumpDictionary.count', -1) do
      delete data_dump_dictionary_url(@data_dump_dictionary)
    end

    assert_redirected_to data_dump_dictionaries_url
  end
end
