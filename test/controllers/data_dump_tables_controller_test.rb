require 'test_helper'

class DataDumpTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_dump_table = data_dump_tables(:one)
  end

  test "should get index" do
    get data_dump_tables_url
    assert_response :success
  end

  test "should get new" do
    get new_data_dump_table_url
    assert_response :success
  end

  test "should create data_dump_table" do
    assert_difference('DataDumpTable.count') do
      post data_dump_tables_url, params: { data_dump_table: { csv_header_name: @data_dump_table.csv_header_name, csv_row_value: @data_dump_table.csv_row_value, source_id: @data_dump_table.source_id, user_id: @data_dump_table.user_id } }
    end

    assert_redirected_to data_dump_table_url(DataDumpTable.last)
  end

  test "should show data_dump_table" do
    get data_dump_table_url(@data_dump_table)
    assert_response :success
  end

  test "should get edit" do
    get edit_data_dump_table_url(@data_dump_table)
    assert_response :success
  end

  test "should update data_dump_table" do
    patch data_dump_table_url(@data_dump_table), params: { data_dump_table: { csv_header_name: @data_dump_table.csv_header_name, csv_row_value: @data_dump_table.csv_row_value, source_id: @data_dump_table.source_id, user_id: @data_dump_table.user_id } }
    assert_redirected_to data_dump_table_url(@data_dump_table)
  end

  test "should destroy data_dump_table" do
    assert_difference('DataDumpTable.count', -1) do
      delete data_dump_table_url(@data_dump_table)
    end

    assert_redirected_to data_dump_tables_url
  end
end
