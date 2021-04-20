require "application_system_test_case"

class ElasticPoliciesTest < ApplicationSystemTestCase
  setup do
    @elastic_policy = elastic_policies(:one)
  end

  test "visiting the index" do
    visit elastic_policies_url
    assert_selector "h1", text: "Elastic Policies"
  end

  test "creating a Elastic policy" do
    visit elastic_policies_url
    click_on "New Elastic Policy"

    fill_in "Input requirements", with: @elastic_policy.input_requirements
    fill_in "Policy output", with: @elastic_policy.policy_output
    fill_in "Source", with: @elastic_policy.source
    fill_in "Title", with: @elastic_policy.title
    click_on "Create Elastic policy"

    assert_text "Elastic policy was successfully created"
    click_on "Back"
  end

  test "updating a Elastic policy" do
    visit elastic_policies_url
    click_on "Edit", match: :first

    fill_in "Input requirements", with: @elastic_policy.input_requirements
    fill_in "Policy output", with: @elastic_policy.policy_output
    fill_in "Source", with: @elastic_policy.source
    fill_in "Title", with: @elastic_policy.title
    click_on "Update Elastic policy"

    assert_text "Elastic policy was successfully updated"
    click_on "Back"
  end

  test "destroying a Elastic policy" do
    visit elastic_policies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Elastic policy was successfully destroyed"
  end
end
