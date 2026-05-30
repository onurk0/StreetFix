=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: 20260412162605_create_votes.rb
# Description: defines the vote record
# Last Modified on: April 12, 2026
=end

class CreateVotes < ActiveRecord::Migration[8.1]
  def change

    # create 'vote' table in the database
    create_table :votes do |t|

      # stores ID of user who voted; field cannot be empty
      t.references :user, null: false, foreign_key: true

      # stores ID of report being voted on; field cannot be empty
      t.references :report, null: false, foreign_key: true

      # automatically adds 'created_at' and 'updated_at' columns
      t.timestamps
    end

    # prevent a user from voting on the same report twice
    # as a general rule: one vote per user per report
    add_index :votes, [:user_id, :report_id], unique: true
  end
end
