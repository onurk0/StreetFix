# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: seeds.rb
# Description: seeds the database with synthetic testing data
# Last Modified on: April 15, 2026
#
# Instructions:
# to seed the database, run `rails db:seed`
# to clean the database and reseed, run `rails db:reset`
# to remove all data, run `rails db:truncate_all`
#
#
# frozen_string_literal: true

# set language to English because Faker defaults to Latin
Faker::Config.locale = 'en'

# remove all existing data
puts "Cleaning database..."
Vote.destroy_all
Report.destroy_all
User.destroy_all
AppConfig.destroy_all

# =============================================================================
# 1. Global Config
# =============================================================================
AppConfig.create!(
  name: 'StreetFix',
  logo_url: 'https://placehold.co/400x100/png?text=StreetFix+Logo'
)

if Rails.env.development?

  # ===========================================================================
  # 2. Users
  # ===========================================================================
  puts "Creating users..."

  # default testing admin
  admin = User.create!(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
  )

  # default testing user
  user = User.create!(
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password'
  )

  # create 15 random users
  15.times do
    User.create!(
      email: Faker::Internet.unique.email,
      password: 'password',
      password_confirmation: 'password'
    )
  end

  # output success message and new user count
  all_users = User.all
  puts "Created #{all_users.count} users."

  # ===========================================================================
  # 3. Reports
  # ===========================================================================

  # Report type integer values match the enum in report.rb:
  # 0: pothole, 1: streetlight, 2: sidewalk, 3: tree, 4: powerline, 5: other
  report_types = [0, 1, 2, 3, 4, 5]
  statuses = %w[open in_progress resolved]


  # default images saved in src/app/assets/images
  image_urls = {
    0 => "/assets/pothole.jpg",
    1 => "/assets/streetlight.jpg",
    2 => "/assets/sidewalk.jpg",
    3 => "/assets/tree.jpg",
    4 => "/assets/powerline.jpg",
    5 => "/assets/other.jpg"
  }

  # default title names 
  titles = {
    0 => [
      "Large pothole on %s",
      "Deep pothole near %s",
      "Road crater forming on %s"
    ],
    1 => [
      "Broken streetlight at %s",
      "Flickering streetlight on %s",
      "Streetlight out for weeks at %s"
    ],
    2 => [
      "Cracked sidewalk on %s",
      "Uneven pavement on %s",
      "Trip hazard on sidewalk near %s"
    ],
    3 => [
      "Fallen tree blocking %s",
      "Dead tree leaning over %s",
      "Large branch down on %s"
    ],
    4 => [
      "Sparking powerline on %s",
      "Downed powerline near %s",
      "Exposed wire hanging over %s"
    ],
    5 => [
      "General maintenance issue on %s",
      "Unidentified hazard near %s",
      "Miscellaneous infrastructure problem on %s"
    ]
  }
  

  descriptions = {
    0 => [
      "There is a large pothole that has been growing for several weeks. It is deep enough to damage vehicle tires and suspension. Multiple cars have already been affected.",
      "A significant road crater has formed after recent heavy rain. The pothole spans nearly the full width of one lane and is a serious hazard for cyclists and drivers.",
      "This pothole has been reported before but never repaired. It has now expanded and poses a real danger, especially at night when it is hard to see."
    ],
    1 => [
      "The streetlight has been completely out for over a week. The area is very dark at night and residents feel unsafe walking in the area after sunset.",
      "This streetlight flickers on and off throughout the night. It is disruptive to nearby residents and does not provide reliable lighting for pedestrians.",
      "The light at this intersection has been broken for nearly a month. Near-miss incidents have been reported due to poor visibility at the crossing."
    ],
    2 => [
      "A large section of the sidewalk has cracked and shifted, creating an uneven surface. This is a serious trip hazard, especially for elderly residents and those using wheelchairs.",
      "The pavement here has buckled, likely due to tree roots underneath. Several people have tripped on this section. It needs urgent attention.",
      "The sidewalk panel is completely broken and has sunk several inches below the surrounding surface. It collects water and is very slippery when wet."
    ],
    3 => [
      "A large tree branch came down during last night's storm and is partially blocking the road. Vehicles are having to swerve around it which is causing a traffic hazard.",
      "A dead tree is leaning dangerously over the sidewalk and could fall at any time. It needs to be assessed and removed before it causes injury or property damage.",
      "Several large branches have fallen across the bike lane. Cyclists are being forced into traffic to get around them. Please clear as soon as possible."
    ],
    4 => [
      "A powerline is visibly sparking after the storm last night. This is an urgent safety emergency. The area should be cordoned off until it is repaired.",
      "A downed powerline is lying across the road. The line may still be live. Emergency services have been notified but the line has not yet been cleared.",
      "A power line is sagging very low over the road, likely due to storm damage. Tall vehicles such as trucks cannot safely pass underneath it."
    ],
    5 => [
    "There is a general maintenance issue in this area that does not fit neatly into another category. It requires inspection by the appropriate city department.",
    "An unidentified hazard has been spotted that may pose a risk to pedestrians or vehicles. Please send someone to assess the situation.",
    "This is a miscellaneous infrastructure concern reported by a resident. Details are included and follow-up may be needed."
  ]
  }

  # create 100 random reports
  puts "Creating 100 reports..."
  100.times do |i|
    type = report_types.sample
    street = Faker::Address.street_name
    city   = Faker::Address.city

    Report.create!(
      title:         titles[type].sample % street,
      description:   descriptions[type].sample,
      location:      "#{Faker::Address.building_number} #{street}, #{city}",
      report_type:   type,
      status:        statuses.sample,
      date_reported: Faker::Time.backward(days: 60),
      image_url:     image_urls[type],
      user:          all_users.sample
    )
  end

  # success message with new report count
  puts "Created #{Report.count} reports."

  # ===========================================================================
  # 4. Votes
  # ===========================================================================
  puts "Generating votes..."

  all_reports = Report.all
  vote_count  = 0

  # create 300 random votes
  300.times do
    begin
      Vote.find_or_create_by!(
        user:   all_users.sample,
        report: all_reports.sample
      )
      vote_count += 1
    rescue ActiveRecord::RecordInvalid
      next # Skip duplicate user/report pairs
    end
  end

  # output success message
  puts "Created #{vote_count} votes."
  puts ""
  puts "Done! Database seeded successfully."
  puts "  Login as admin:     admin@example.com / password"
  puts "  Login as test user: user@example.com / password"
end