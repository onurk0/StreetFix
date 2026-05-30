=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: 20260412161701_add_report_type_to_reports.rb
# Description: defines the rules for report types
# Last Modified on: April 12, 2026
=end

# adding a column to reports to store votes
# enums are used to define the report type (pothole, light, etc)
# default of 0 is a pothole
# see app/models/reports.rb for full details

class AddReportTypeToReports < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :report_type, :integer, default: 0, null: false
  end
end
