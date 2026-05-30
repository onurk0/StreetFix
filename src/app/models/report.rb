# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: report.rb
# Description: manage incident data, types, and voting
# last modified: April 13, 2026

class Report < ApplicationRecord

  # Associations
  
  # reports belong to a user
  belongs_to :user

  # remove votes associated with a report when it is deleted
  has_many :votes, dependent: :destroy

  # shortcut to access the users who voted on a report
  has_many :voters, through: :votes, source: :user

  # Enums
  # maps int values in DB to readable categories
  enum :report_type, {
    pothole: 0,
    streetlight: 1,
    sidewalk: 2,
    tree: 3,
    power_line: 4,
    other: 5
  }

  # Validations
  validates :title,       presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location,    presence: true
  validates :report_type, presence: true

  # return the total number of votes for this report
  def vote_count
    votes.count
  end

  # check if a given user has already voted on this report
  def voted_by?(user)
    voters.include?(user)
  end
end
  
