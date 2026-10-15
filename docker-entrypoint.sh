#!/bin/bash -e

# Create/migrate the database before starting the server.
if [ "$1" == "./bin/rails" ] && [ "$2" == "server" ]; then
  ./bin/rails db:prepare
fi

exec "$@"
