=begin
# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: user.rb
# Description: model for user accounts
# Last Modified on: April 15, 2026
=end
# frozen_string_literal: true

# Represents a user of the web application
class User < ApplicationRecord
  # Devise is a premade system for managing logins
  # You don't need to do login yourself. It's done for you.
  # TCNJ: don't edit the login system.

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # each user can have many reports and votes
  # if either is deleted, the related records
  # in the database are also deleted by default
  has_many :reports, dependent: :destroy
  has_many :votes, dependent: :destroy

  # Check if user is admin
  def admin?
    admin == true
  end
end
