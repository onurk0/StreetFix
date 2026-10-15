# StreetFix

StreetFix is a Rails web application built to help communities report and track local infrastructure issues such as potholes, broken sidewalks, damaged street lights, fallen trees, and downed power lines.

Residents can submit reports, add details about a problem, and vote to raise the visibility of issues that need attention. The app is designed to make it easier for communities to identify, prioritize, and monitor hazards in public spaces.

## Overview

StreetFix helps with:

- reporting location-based infrastructure problems
- describing the issue and adding context to a report
- increasing visibility through community voting
- reviewing and managing reports in an admin workflow
- creating a simple, user-friendly experience for public maintenance requests

## Runtime previews

The placeholders below are ready for real screenshots or app captures once the project is running locally.

![StreetFix dashboard placeholder](docs/images/streetfix-dashboard.svg)
![StreetFix report form placeholder](docs/images/streetfix-report-form.svg)
![StreetFix report list placeholder](docs/images/streetfix-report-list.svg)

## Tech stack

- Ruby 4.0.1
- Rails 8.1
- PostgreSQL
- Hotwire / Turbo / Stimulus
- Bootstrap styling
- Puma web server

## Prerequisites

Before installing, make sure your machine has:

- Git
- PostgreSQL
- Ruby 4.0.1 and Bundler
- Node.js and npm
- A local shell environment configured for Ruby version management

Use the single installer script for the project environment:

```bash
./installruby.sh
```

This script installs the correct Ruby version and the matching Rails version for the app, then configures Bundler.

## Installation

1. Clone the repository:

```bash
git clone <your-repository-url>
cd StreetFix
```

2. Run the single project installer:

```bash
./installruby.sh
```

This is the only install script the project uses for the runtime environment. If the script updates your shell configuration, log out and back in before continuing.

3. Start PostgreSQL and confirm it is available:

```bash
which postgres
postgres --version
```

4. Install the Ruby gems:

```bash
cd src
bundle install
```

5. Create and seed the database:

```bash
bin/rails db:setup
```

6. Start the app:

```bash
bin/rails server
```

Then open the application in your browser at:

```text
http://localhost:3000
```

## Running with Docker

You can also run StreetFix with Docker instead of installing Ruby and PostgreSQL yourself. The included `docker-compose.yml` starts the app together with a PostgreSQL database.

1. Install [Docker](https://docs.docker.com/get-docker/) with the Compose plugin.

2. Build and start the containers from the repository root:

```bash
SECRET_KEY_BASE=$(openssl rand -hex 64) docker compose up --build
```

On first start the database is created and migrated automatically.

3. Open the application at:

```text
http://localhost:3000
```

To stop the app, press `Ctrl+C` or run `docker compose down`. Database data and uploaded files are kept in Docker volumes; use `docker compose down -v` to delete them.

The container runs in production mode, so the demo accounts and sample reports are not seeded. To make an account an admin, sign up in the browser and then run:

```bash
docker compose exec web bin/rails runner 'User.find_by(email: "you@example.com").update!(admin: true)'
```

To run the image without Compose, provide your own database connection:

```bash
docker build -t streetfix .
docker run -p 3000:3000 \
  -e DATABASE_URL=postgres://user:password@db-host:5432/streetfix \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  streetfix
```

## Common database commands

```bash
bin/rails db:setup
bin/rails db:reset
bin/rails db:migrate
```

## Default demo accounts

The application includes seeded users for testing:

- User: `user@example.com` / `password`
- Admin: `admin@example.com` / `password`

## Project maintenance

For project maintenance notes and operational guidance, see [docs/maintenance.md](docs/maintenance.md).

## License

This project is available under the terms in the repository license file.

## Milestones

- [x] report creation
- [x] user login and account creation
- [x] logout support
- [x] admin moderation actions
- [x] seeded testing data
- [x] homepage actions and navigation
- [x] vote counter support
- [x] sorting/filtering for reports

