# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: vote.rb
# Description: join user and reports for voting system
# last modified: April 12, 2026

class Vote < ApplicationRecord

  # link vote to user that cast it
  belongs_to :user

  # link vote to report it is associated with
  belongs_to :report

  # ensure a user can only vote once per report at the application level
  # in addition to the database constraints
  validates :user_id, uniqueness: { scope: :report_id, message: "you already voted for this report"}
end