# Maintenance

Follow the paths to files that have been modified significantly.

Application Path: `/home/student1/vm-csc415/S26-OK-StreetFix/src/`

From the `src` source path, enter the following paths to find the file you are looking for.

## Tech Stack
- Version control: git
- Versions: Rails 8.1.2 and Ruby 4.0.1
- use `bundle install` to install all the Gems
    - if any Gem is outdated, update it to a more recent version

## Controllers (`/app/controllers`)

- Home controller: `app/controllers/home_controller.rb`
    - controller for the home page

- Reports controller: `app/controllers/reports_controller.rb`
    - CRUD operations for reports

- Users controller: `app/controllers/users_controller.rb`
    - controller for user account pages

## Models (`/app/models`)

- report model: `app/models/report.rb`
    - manages incident data, types, and voting

- user model: `app/models/user.rb`
    - logic for user accounts

- vote model: `app/models/vote.rb`
    - join user and reports for voting system

## Views (`/app/views`)

Inside `/views/home`:

- index: `app/views/home/index.html.erb`
    - application home page
- success: `app/views/home/success.html.erb`
    - success page

Inside `views/layouts`:

- application: `app/views/layouts/application.html.erb`
    - structure of the application page

Inside `views/reports`:

- form: `app/views/reports/_form.html.erb`
    - form page for submitted reports
- edit: `app/views/reports/edit.html.erb`
    - page for editing an existing report
- index: `app/views/reports/index.html.erb`
    - lists reports with filtering by type
- new: `app/views/reports/new.html.erb`
    - form page for submitting new reports
- show: `app/views/reports/show.html.erb`
    - page for displaying report detaisl

Inside `views/users`
- show: `app/views/users/show.html.erb`
    - page to view user account information

Inside `src/db`
- schema: `db/schema.rb`
    - this file is automatically configured from the Rails console.
- seeds: `db/seeds.rb`
    - used for entering synthetic data into the system. Primarily for testing purposes. Do not include any sensitive data.
 
## Gemfile
Modify the Gemfile as needed. Add, remove, and update versions for Gems.






