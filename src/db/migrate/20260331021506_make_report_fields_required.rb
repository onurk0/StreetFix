=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: 20260331021506_make_report_fields_required.rb
# Description: defines the rules for the Reports table, enforced by the DBMS
# Last Modified on: April 12, 2026
=end

class MakeReportFieldsRequired < ActiveRecord::Migration[8.1]
  def change
    change_column_null :reports, :title, false
    change_column_null :reports, :description, false
    change_column_null :reports, :location, false
  end
end
