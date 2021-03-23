require 'test_helper'

class TableEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @table_entry = table_entries(:one)
  end

  test "should get index" do
    get table_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_table_entry_url
    assert_response :success
  end

  test "should create table_entry" do
    assert_difference('TableEntry.count') do
      post table_entries_url, params: { table_entry: { field_one: @table_entry.field_one, field_three: @table_entry.field_three, field_two: @table_entry.field_two } }
    end

    assert_redirected_to table_entry_url(TableEntry.last)
  end

  test "should show table_entry" do
    get table_entry_url(@table_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_table_entry_url(@table_entry)
    assert_response :success
  end

  test "should update table_entry" do
    patch table_entry_url(@table_entry), params: { table_entry: { field_one: @table_entry.field_one, field_three: @table_entry.field_three, field_two: @table_entry.field_two } }
    assert_redirected_to table_entry_url(@table_entry)
  end

  test "should destroy table_entry" do
    assert_difference('TableEntry.count', -1) do
      delete table_entry_url(@table_entry)
    end

    assert_redirected_to table_entries_url
  end
end
