# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:pothole)
  end

  test 'anyone can view reports' do
    get reports_url
    assert_response :success

    get report_url(@report)
    assert_response :success
  end

  test 'owner can edit their report' do
    sign_in users(:one)
    patch report_url(@report), params: { report: { title: 'Updated' } }
    assert_redirected_to report_url(@report)
    assert_equal 'Updated', @report.reload.title
  end

  test 'non-owner cannot edit a report' do
    sign_in users(:two)
    patch report_url(@report), params: { report: { title: 'Hijacked' } }
    assert_redirected_to reports_url
    assert_not_equal 'Hijacked', @report.reload.title
  end

  test 'invalid report type is rejected instead of raising' do
    sign_in users(:one)
    patch report_url(@report), params: { report: { report_type: 'bogus' } }
    assert_response :unprocessable_entity
  end

  test 'voting toggles' do
    sign_in users(:two)
    assert_difference -> { @report.votes.count }, 1 do
      post vote_report_url(@report)
    end
    assert_difference -> { @report.votes.count }, -1 do
      post vote_report_url(@report)
    end
  end

  test 'non-admin cannot access the admin panel' do
    sign_in users(:one)
    get rails_admin_url
    assert_redirected_to root_url
  end

  test 'admin can access the admin panel' do
    sign_in users(:admin)
    get rails_admin_url
    assert_response :success
  end
end
