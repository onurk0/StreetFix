# Directory Layout

This page describes how the StreetFix repository is organized: where each piece
lives and what it is responsible for. StreetFix is a standard Rails 8.1
application, so most of the layout follows Rails conventions. The Rails app
itself lives in `src/`, while the repository root holds the Docker setup and
documentation.

## Top level

```text
.
├── Dockerfile          # Builds the full dev environment (Ruby, gems, PostgreSQL)
├── .dockerignore       # Files kept out of the Docker build context
├── .gitattributes      # Git line-ending / diff settings
├── .gitignore          # Files Git should not track (logs, tmp, master.key, ...)
├── LICENSE.md          # Project license
├── README.md           # Project overview, install and run instructions
├── docs/               # Project documentation (this file lives here)
└── src/                # The Rails application
```

| Path | Purpose |
| --- | --- |
| [`Dockerfile`](../Dockerfile) | Self-contained development image. Installs Ruby 4.0.1, system libraries, every gem and a PostgreSQL server. Its entrypoint starts PostgreSQL (unless `DB_HOST` is set), runs `bin/rails db:prepare` and then starts the Rails server on port 3000. |
| [`.dockerignore`](../.dockerignore) | Keeps Git metadata, docs, logs, temp files and `config/master.key` out of the image. |
| [`README.md`](../README.md) | Entry point for new contributors: what StreetFix is, how to install Docker, build and run the app, and the demo accounts. |

## `docs/` — documentation

```text
docs/
├── Installation_Guide.md   # Step-by-step Docker install and project setup
├── maintenance.md          # Notes on significantly modified files and upkeep
├── directoryLayout.md      # This file
└── images/                 # Placeholder screenshots used by the README
    ├── streetfix-dashboard.svg
    ├── streetfix-report-form.svg
    └── streetfix-report-list.svg
```

## `src/` — the Rails application

```text
src/
├── Gemfile             # Ruby gem dependencies
├── Rakefile            # Loads Rails rake tasks
├── config.ru           # Rack entry point used by Puma
├── .ruby-version       # Ruby version (4.0.1)
├── .browserslistrc     # Supported browsers for assets
├── app/                # Application code (MVC)
├── bin/                # Executable scripts (rails, rake, setup, ...)
├── config/             # App, environment, route and gem configuration
├── db/                 # Schema, migrations and seed data
├── lib/                # Custom libraries and rake tasks (currently empty)
├── log/                # Runtime logs (not tracked)
├── public/             # Static files served as-is (error pages, icons)
├── storage/            # Active Storage files (not tracked)
├── test/               # Automated tests
├── tmp/                # Caches, pid files (not tracked)
└── vendor/             # Third-party code (currently empty)
```

### Key gems ([`src/Gemfile`](../src/Gemfile))

- `rails` — the web framework
- `pg` — PostgreSQL database adapter
- `puma` — web server
- `devise` — user registration, login and password handling
- `rails_admin` — admin dashboard mounted at `/admin`
- `turbo-rails`, `stimulus-rails`, `importmap-rails` — Hotwire front end without a Node build step
- `sprockets-rails`, `sassc-embedded` — asset pipeline and SCSS compilation
- `faker` (dev/test) — generates realistic seed data
- `capybara`, `selenium-webdriver` (test) — browser/system tests

### `src/app/` — application code

```text
app/
├── assets/
│   ├── config/manifest.js      # Tells Sprockets which assets to compile
│   ├── images/                 # Default images for each report type
│   └── stylesheets/            # SCSS (application.scss, home.scss)
├── channels/application_cable/ # Action Cable base classes (unused)
├── controllers/
│   ├── application_controller.rb
│   ├── home_controller.rb
│   ├── reports_controller.rb
│   ├── users_controller.rb
│   └── concerns/
├── helpers/
│   ├── application_helper.rb
│   └── home_helper.rb
├── javascript/
│   ├── application.js          # Main JS entry point
│   └── controllers/            # Stimulus controllers
├── jobs/application_job.rb     # Base class for background jobs (unused)
├── mailers/application_mailer.rb # Base class for mailers (unused)
├── models/
│   ├── application_record.rb
│   ├── app_config.rb
│   ├── report.rb
│   ├── user.rb
│   ├── vote.rb
│   └── concerns/
└── views/
    ├── home/                   # index, success
    ├── layouts/                # application layout, mailer layouts
    ├── reports/                # index, show, new, edit, _form
    └── users/                  # show
```

#### Models (`app/models/`)

| File | What it does |
| --- | --- |
| [`application_record.rb`](../src/app/models/application_record.rb) | Abstract parent class for all models. |
| [`report.rb`](../src/app/models/report.rb) | An infrastructure issue. Belongs to a user, has many votes. Defines the `report_type` enum (`pothole`, `streetlight`, `sidewalk`, `tree`, `power_line`, `other`), validations, and `vote_count` / `voted_by?` helpers. |
| [`user.rb`](../src/app/models/user.rb) | A user account managed by Devise. Has many reports and votes; `admin?` checks the admin flag. |
| [`vote.rb`](../src/app/models/vote.rb) | Join model between users and reports. Enforces one vote per user per report. |
| [`app_config.rb`](../src/app/models/app_config.rb) | Global app settings (app name and logo URL), read by `ApplicationHelper#app_name`. |

#### Controllers (`app/controllers/`)

| File | What it does |
| --- | --- |
| [`application_controller.rb`](../src/app/controllers/application_controller.rb) | Base controller. Enables CSRF protection and requires login for every action by default. |
| [`home_controller.rb`](../src/app/controllers/home_controller.rb) | Public home page (`/`) and the `/success` confirmation page. |
| [`reports_controller.rb`](../src/app/controllers/reports_controller.rb) | Full CRUD for reports, filtering the index by `user_id` and `report_type`, and the `vote` action that toggles a user's vote. Only the owner can edit; the owner or an admin can delete. Index and show are public. |
| [`users_controller.rb`](../src/app/controllers/users_controller.rb) | The signed-in user's account page. |

#### Views (`app/views/`)

| File | What it does |
| --- | --- |
| [`layouts/application.html.erb`](../src/app/views/layouts/application.html.erb) | Page shell shared by every page: `<head>`, navbar, flash messages. |
| [`home/index.html.erb`](../src/app/views/home/index.html.erb) | Landing page. |
| [`home/success.html.erb`](../src/app/views/home/success.html.erb) | Generic success page. |
| [`reports/index.html.erb`](../src/app/views/reports/index.html.erb) | List of reports with type filtering. |
| [`reports/show.html.erb`](../src/app/views/reports/show.html.erb) | Single report with details and vote button. |
| [`reports/new.html.erb`](../src/app/views/reports/new.html.erb) / [`edit.html.erb`](../src/app/views/reports/edit.html.erb) | Create / edit pages; both render the shared `_form` partial. |
| [`reports/_form.html.erb`](../src/app/views/reports/_form.html.erb) | Report form fields (title, description, location, type, image URL). |
| [`users/show.html.erb`](../src/app/views/users/show.html.erb) | Account information page. |

Devise's login and registration views come from the gem itself and are not
copied into this folder.

#### Front end

- [`app/javascript/application.js`](../src/app/javascript/application.js) — loads Turbo and Stimulus and hides the navbar while scrolling down.
- [`app/javascript/controllers/`](../src/app/javascript/controllers/) — Stimulus setup; any `*_controller.js` added here is loaded automatically.
- [`app/assets/stylesheets/`](../src/app/assets/stylesheets/) — SCSS styles compiled by Sprockets.
- [`app/assets/images/`](../src/app/assets/images/) — default photos per report type (`pothole.jpg`, `streetlight.jpg`, ...), used by the seed data.

#### Helpers

- [`application_helper.rb`](../src/app/helpers/application_helper.rb) — `app_name`, available in all views.
- [`home_helper.rb`](../src/app/helpers/home_helper.rb) — helpers for home views (empty).

### `src/config/` — configuration

| Path | What it does |
| --- | --- |
| [`routes.rb`](../src/config/routes.rb) | URL routing: `/` → home, Devise user routes, `/users/:id`, `resources :reports` plus `POST /reports/:id/vote`, `/success`, and Rails Admin at `/admin`. |
| [`database.yml`](../src/config/database.yml) | PostgreSQL settings per environment. Connection details come from `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`. |
| [`application.rb`](../src/config/application.rb), [`boot.rb`](../src/config/boot.rb), [`environment.rb`](../src/config/environment.rb) | Rails boot and global app configuration. |
| [`environments/`](../src/config/environments/) | Per-environment settings (`development`, `test`, `production`). |
| [`importmap.rb`](../src/config/importmap.rb) | Maps JavaScript module names (Turbo, Stimulus, controllers) to files. |
| [`puma.rb`](../src/config/puma.rb) | Web server threads, port and workers. |
| [`cable.yml`](../src/config/cable.yml), [`storage.yml`](../src/config/storage.yml) | Action Cable and Active Storage backends. |
| [`credentials.yml.enc`](../src/config/credentials.yml.enc) | Encrypted secrets (needs `master.key`, which is not committed). |
| [`locales/`](../src/config/locales/) | Translation strings, including Devise messages. |
| [`initializers/`](../src/config/initializers/) | Code run at boot. Notable ones: `devise.rb` (auth settings), `rails_admin.rb` (restricts `/admin` to admins), `psych_aliases.rb` (allows YAML aliases with newer Psych versions). |

### `src/db/` — database

| Path | What it does |
| --- | --- |
| [`schema.rb`](../src/db/schema.rb) | Auto-generated snapshot of the current database structure (`app_configs`, `reports`, `users`, `votes`). Do not edit by hand. |
| [`migrate/`](../src/db/migrate/) | Migrations that build the schema step by step (users, reports columns, report types, votes, admin flag). |
| [`seeds.rb`](../src/db/seeds.rb) | Wipes and repopulates the database. Always creates the `AppConfig`; in development it also creates the demo admin/user accounts, 15 random users, 100 reports and ~300 votes. |

### `src/bin/` — scripts

- `rails`, `rake`, `bundle` — wrappers that run those tools with the app's settings.
- `importmap` — manages pinned JavaScript packages.
- `setup` — installs gems and prepares the database (the Docker entrypoint does this for you).

### `src/test/` — tests

```text
test/
├── test_helper.rb                  # Shared test setup
├── application_system_test_case.rb # Base class for browser tests
├── channels/                       # Action Cable tests
├── controllers/                    # Controller tests (home)
├── fixtures/                       # Sample data loaded for tests
├── models/                         # Model tests (app_config, user)
├── helpers/, integration/, mailers/, system/  # Empty, ready for new tests
```

Run them with `docker run --rm -e RAILS_ENV=test streetfix bin/rails test`.

### Other `src/` folders

- `public/` — static files served directly: error pages (`404.html`, `422.html`, `500.html`), favicon, `robots.txt`.
- `lib/`, `vendor/` — reserved for custom libraries and third-party code; currently only `.keep` files.
- `log/`, `tmp/`, `storage/` — created at runtime; their contents are ignored by Git.

## Where to make common changes

| I want to... | Look in |
| --- | --- |
| Add a page or URL | `src/config/routes.rb`, then a controller action and a view |
| Change what a report stores | A new migration in `src/db/migrate/`, then `src/app/models/report.rb` and `src/app/views/reports/_form.html.erb` |
| Add a report type | The `report_type` enum in `src/app/models/report.rb` (and an image in `src/app/assets/images/`) |
| Change permissions | `before_action` filters in `src/app/controllers/reports_controller.rb`; admin panel access in `src/config/initializers/rails_admin.rb` |
| Change the look | `src/app/views/layouts/application.html.erb` and `src/app/assets/stylesheets/` |
| Change demo data | `src/db/seeds.rb` |
| Add a gem | `src/Gemfile`, then rebuild the Docker image |
