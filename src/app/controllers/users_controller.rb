# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: users_controller.rb
# Description: controller for user account pages
# Last Modified on: April 15, 2026

# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end
end