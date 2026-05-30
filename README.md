# StreetFix README

**[AI Disclosure](docs/AI_Disclosure_and_Author_Statement.md)**

Welcome to StreetFix!

Failing infrastructure is bad for a community. Potholes, damaged sidewalks, malfunctioning street lights, downed trees and powerlines all
present a hazard to the community. Not only it is a hazard, property values fall, and first responders have trouble accessing the area during an emergency.

This project, StreetFix, aims to help the community report infrastructure issues in their area by utilizing a web application. 

A web application is the best way to reach many people easily and quickly. 

To achieve this goal, users can login and submit a detailed report about the damaged infrastructure. Users can then vote on the report to 
boosts its popularity and visibility.

## Getting Started
Before doing anything, make sure the application is running on the Virtual Machine (VM).

To run the application: `rails server --binding=10.18.6.35`

The application runs [here](http://csc415-server35.hpc.tcnj.edu:3000/)

To seed the database, run `rails db:seed`

To clean the database and reseed, run `rails db:reset`

To remove all data, run `rails db:truncate_all`

You can make an account using the `Login` button. From there you can freely interact with
the site by making reports, deleting reports, updating reports, and viewing reports. You can
interact with the reports by liking them as well.

Default users:
- default user: `user@example.com / password`
- admin: `admin@example.com / password`

## Diagrams
- [Use Case Diagram](/docs/USE_CASE_DIAGRAM.png)
- [Class Diagram](/docs/CLASS_DIAGRAM.png)
- [Design Class Diagram](/docs/DESIGN_CLASS_DIAGRAM.png)
- [State Diagram](/docs/STATE_DIAGRAM.png)
- [Use Case 1 System State Diagram](/docs/USE_CASE_1_SSD.png)
- [Use Case 2 System State Diagram](/docs/USE_CASE_2_SSD.png)
- [Use Case 3 System State Diagram](/docs/USE_CASE_3_SSD.png)
- [Example Home UI](/docs/HOME_UI.png)
- [Example Report Page](/docs/REPORT_PAGE.png)

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

