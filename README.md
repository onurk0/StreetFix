# StreetFix README

Welcome to StreetFix!

Failing infrastructure is bad for a community. Potholes, damaged sidewalks, malfunctioning street lights, downed trees and powerlines all
present a hazard to the community. Not only it is a hazard, first responders also have trouble accessing the area during an emergency.

This project aims to help help the community report infrastructure issues in their area by utilizing a web-based application. 

To achieve this efficiently, users can login and submit a detailed report about the damaged infrastructure. Users can then vote on the report to 
boosts its popularity and visibility.

## Getting Started
Let's get started!

First, clone this repository to a directory.

This application uses a PostgreSQL database. In order to use it, add these following lines to the bottom of your
`.bash_profile`:
```bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(~/.rbenv/bin/rbenv init – bash)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="/usr/pgsql-18/bin:$PATH"
```
After this, run the `./installruby.sh` script to ensure that the necessary Ruby version is on your device. Just a heads up-this will take while!

Quick sanity check:
- Check your PostgreSQL version: `which postgres` should return `/usr/pgsql-17/bin` or `/usr/pgsql-17/bin/postgres`
- Check your Ruby version: `which ruby` should return `~/.rbenv/shims/ruby`
- `ruby -v` should return `ruby 4.0.1`

After installing, navigate to the directory titled `StreetFix`

Navigate to `src`, then run 
```bash
bundle install
```

To create and seed the database, run `rails db:setup`

To clean the database and reseed, run `rails db:reset`

To remove all data and add your own, run `rails db:truncate_all`

You can make an account using the `Login` button. From there you can freely interact with
the site by making reports, deleting reports, updating reports, and viewing reports. You can
interact with the reports by liking them as well.

Default users:
- default user: `user@example.com / password`
- admin: `admin@example.com / password`


## Project Maintenance
Please refer to [review](/docs/maintenance.md) to learn more about maintaining this project.


 
## Milestones
- [x] added functionality to make reports
- [x] added functionality to login and create account
- [x] added support to logout
- [x] added admin functionality (remove posts)
- [x] added synthetic/testing data to the application
- [x] addded buttons to home page
- [x] added vote counter to all projects
- [x] added `sort by` function for project sorting

