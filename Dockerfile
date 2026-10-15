# syntax=docker/dockerfile:1
# Production image for StreetFix (Rails app lives in src/).
#
#   docker build -t streetfix .
#   docker run -p 3000:3000 \
#     -e DATABASE_URL=postgres://user:pass@db-host:5432/streetfix \
#     -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
#     streetfix
#
# Or use docker-compose.yml to run it together with PostgreSQL.

ARG RUBY_VERSION=4.0.1
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libpq5 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test" \
    RAILS_SERVE_STATIC_FILES=1 \
    RAILS_LOG_TO_STDOUT=1

# ---------------------------------------------------------------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Gemfile.lock is gitignored, so dependencies are resolved at build time.
COPY src/Gemfile ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY src/ ./

# bin/ scripts are committed with CRLF endings and without +x; fix both.
RUN sed -i "s/\r$//" bin/* && chmod +x bin/* && \
    bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ---------------------------------------------------------------------------
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp/pids && \
    chown -R rails:rails db log storage tmp && \
    chmod +x /usr/local/bin/docker-entrypoint
USER 1000:1000

ENTRYPOINT ["docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
