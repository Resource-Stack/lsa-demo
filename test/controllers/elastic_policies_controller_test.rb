require 'test_helper'

class ElasticPoliciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @elastic_policy = elastic_policies(:one)
  end

  test "should get index" do
    get elastic_policies_url
    assert_response :success
  end

  test "should get new" do
    get new_elastic_policy_url
    assert_response :success
  end

  test "should create elastic_policy" do
    assert_difference('ElasticPolicy.count') do
      post elastic_policies_url, params: { elastic_policy: { input_requirements: @elastic_policy.input_requirements, policy_output: @elastic_policy.policy_output, source: @elastic_policy.source, title: @elastic_policy.title } }
    end

    assert_redirected_to elastic_policy_url(ElasticPolicy.last)
  end

  test "should show elastic_policy" do
    get elastic_policy_url(@elastic_policy)
    assert_response :success
  end

  test "should get edit" do
    get edit_elastic_policy_url(@elastic_policy)
    assert_response :success
  end

  test "should update elastic_policy" do
    patch elastic_policy_url(@elastic_policy), params: { elastic_policy: { input_requirements: @elastic_policy.input_requirements, policy_output: @elastic_policy.policy_output, source: @elastic_policy.source, title: @elastic_policy.title } }
    assert_redirected_to elastic_policy_url(@elastic_policy)
  end

  test "should destroy elastic_policy" do
    assert_difference('ElasticPolicy.count', -1) do
      delete elastic_policy_url(@elastic_policy)
    end

    assert_redirected_to elastic_policies_url
  end
end
