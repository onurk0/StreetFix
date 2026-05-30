=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: db/migrate/20260331020333_add_columns_to_reports.rb
# Description: Table for storing reports
# Last Modified on: March 30, 2026
=end

class AddColumnsToReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :description
      t.string :location
      t.string :status, default: "open"
      t.string :image_url
      t.datetime :date_reported
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end