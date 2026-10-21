# syntax=docker/dockerfile:1.7
#
# StreetFix - self-contained development image.
#
# Replaces installruby.sh / uninstallruby.sh / setup.sh: Ruby, Bundler, Rails
# and every gem (including Dart Sass) and a PostgreSQL server all live in this image.
#
#   docker build -t streetfix .
#   docker run --rm -p 3000:3000 -v streetfix-db:/var/lib/postgresql/data streetfix
#
# Then open http://localhost:3000 (admin@example.com / password).
#
# To use an external PostgreSQL instead of the bundled one, pass
# -e DB_HOST=... -e DB_USERNAME=... -e DB_PASSWORD=... (optionally DB_PORT).

ARG RUBY_VERSION=4.0.1
FROM docker.io/library/ruby:${RUBY_VERSION}-slim

# System packages: compilers for native gems, libpq for the pg gem,
# libyaml for psych, and the PostgreSQL server itself.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git pkg-config curl \
      libpq-dev libyaml-dev \
      postgresql postgresql-contrib && \
    ln -s "$(ls -d /usr/lib/postgresql/*/bin)" /usr/local/pgbin && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    PGDATA=/var/lib/postgresql/data \
    PATH=/usr/local/pgbin:$PATH

# Unprivileged user that runs the Rails app
RUN groupadd --system rails && \
    useradd --system --gid rails --create-home --shell /bin/bash rails

WORKDIR /app

# Install gems first so this layer is cached between code changes
COPY src/Gemfile src/Gemfile.lock* src/.ruby-version ./
RUN echo 'gem: --no-document' > /etc/gemrc && \
    bundle install --jobs "$(nproc)" && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Application code
COPY src/ ./

# Precompile bootsnap caches and give the app user its writable directories
RUN bundle exec bootsnap precompile app/ lib/ && \
    mkdir -p tmp/pids log storage && \
    chown -R rails:rails tmp log storage db

# Entrypoint: start the bundled PostgreSQL (unless DB_HOST points elsewhere),
# create/migrate/seed the database, then run the given command as `rails`.
COPY --chmod=0755 <<'EOF' /usr/local/bin/docker-entrypoint
#!/bin/bash
set -e

if [ -z "${DB_HOST}" ]; then
  mkdir -p "${PGDATA}" /var/run/postgresql
  chown -R postgres:postgres "${PGDATA}" /var/run/postgresql
  chmod 0700 "${PGDATA}"

  if [ ! -s "${PGDATA}/PG_VERSION" ]; then
    echo "== Initializing PostgreSQL data directory =="
    runuser -u postgres -- initdb --auth=trust --encoding=UTF8 --username=postgres -D "${PGDATA}" >/dev/null
  fi

  echo "== Starting PostgreSQL =="
  runuser -u postgres -- pg_ctl -D "${PGDATA}" -w -l "${PGDATA}/server.log" \
    -o "-c listen_addresses='' -c unix_socket_directories=/var/run/postgresql" start

  runuser -u postgres -- psql -q -v ON_ERROR_STOP=1 -c \
    "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'rails') THEN CREATE ROLE rails LOGIN SUPERUSER; END IF; END \$\$;"

  trap 'runuser -u postgres -- pg_ctl -D "${PGDATA}" -m fast stop' EXIT
fi

# Remove a stale pid file left over from an unclean shutdown
rm -f /app/tmp/pids/server.pid

# Creates the database, loads the schema and seeds it on first run;
# runs pending migrations on later runs.
echo "== Preparing database =="
runuser -u rails -- bin/rails db:prepare

# Not exec'd so the EXIT trap can shut PostgreSQL down cleanly
set +e
runuser -u rails -- "$@" &
child=$!
trap 'kill -TERM "${child}" 2>/dev/null' TERM INT
wait "${child}"
status=$?
# wait returns early (>128) when a signal arrives; collect the real status
if [ "${status}" -gt 128 ]; then
  wait "${child}"
  status=$?
fi
exit "${status}"
EOF

VOLUME ["/var/lib/postgresql/data"]
EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
