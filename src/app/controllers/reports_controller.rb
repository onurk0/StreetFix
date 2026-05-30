=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: reports_controller.rb
# Description: CRUD operations for infrastructure reports
# Last Modified on: April 12, 2026
=end

# frozen_string_literal: true

class ReportsController < ApplicationController
  # Anyone can browse reports without logging in
  skip_before_action :authenticate_user!, only: [:index, :show]

  # Load the report once for actions that need a specific one
  before_action :set_report, only: [:show, :edit, :update, :destroy, :vote]

  # Only the report's owner can edit it
  before_action :authorize_owner!, only: [:edit, :update]
  # Only the report's owner or admin can delete it
  before_action :authorize_owner_or_admin!, only: [:destroy]

  # GET /reports
  def index
    # get all reports, newest first shown first
    @reports = Report.all.order(created_at: :desc)

    # Filter by user if user_id provided
    if params[:user_id].present?
      @reports = @reports.where(user_id: params[:user_id])
    end

    # Filter by report_type if provided
    if params[:report_type].present? && Report.report_types.key?(params[:report_type])
      @reports = @reports.where(report_type: params[:report_type])
    end
  end

  # GET /reports/:id
  def show
    # prepare the user view
    @vote_count = @report.vote_count
    @user_voted = current_user ? @report.voted_by?(current_user) : false
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # POST /reports
  def create
    # associate new report with current user
    @report = current_user.reports.build(report_params)
    @report.date_reported = Time.current

    if @report.save
      redirect_to @report, notice: "Report submitted successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /reports/:id/edit
  def edit
    # @report is already set by set_report and authorize_owner!
  end

  # PATCH/PUT /reports/:id
  def update
    if @report.update(report_params)
      redirect_to @report, notice: "Report updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reports/:id
  def destroy
    @report.destroy
    redirect_to reports_path, notice: "Report deleted."
  end

  # POST /reports/:id/vote
  def vote
    # manual check for authentication as this is a custom action
    unless current_user
      return redirect_to new_user_session_path, alert: "You must be logged in to vote."
    end

    # toggle vote: if user already voted, remove it; otherwise, add a new vote
    if @report.voted_by?(current_user)
      # Toggle: remove vote if already voted
      @report.votes.find_by(user: current_user)&.destroy
    else
      @report.votes.create(user: current_user)
    end

    redirect_to @report
  end

  private

  # helper to find the record based on the ID passed from URL
  def set_report
    @report = Report.find(params[:id])
  end

  # verification to prevent unauthorized edits
  # Only the report owner can edit
  def authorize_owner!
    unless @report.user == current_user
      redirect_to reports_path, alert: "You can only edit your own reports."
    end
  end

  # verification to prevent unauthorized deletions
  # Allows the report owner or any admin to delete
  def authorize_owner_or_admin!
    unless @report.user == current_user || current_user.admin?
      redirect_to reports_path, alert: "You can only delete your own reports."
    end
  end

  # allow only the specified parameters to be submitted through forms
  def report_params
    params.require(:report).permit(:title, :description, :location, :report_type, :image_url)
  end
end