require 'test_helper'

class MasterTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @master_table = master_tables(:one)
  end

  test "should get index" do
    get master_tables_url
    assert_response :success
  end

  test "should get new" do
    get new_master_table_url
    assert_response :success
  end

  test "should create master_table" do
    assert_difference('MasterTable.count') do
      post master_tables_url, params: { master_table: { field_one: @master_table.field_one, field_three: @master_table.field_three, field_two: @master_table.field_two } }
    end

    assert_redirected_to master_table_url(MasterTable.last)
  end

  test "should show master_table" do
    get master_table_url(@master_table)
    assert_response :success
  end

  test "should get edit" do
    get edit_master_table_url(@master_table)
    assert_response :success
  end

  test "should update master_table" do
    patch master_table_url(@master_table), params: { master_table: { field_one: @master_table.field_one, field_three: @master_table.field_three, field_two: @master_table.field_two } }
    assert_redirected_to master_table_url(@master_table)
  end

  test "should destroy master_table" do
    assert_difference('MasterTable.count', -1) do
      delete master_table_url(@master_table)
    end

    assert_redirected_to master_tables_url
  end
end
