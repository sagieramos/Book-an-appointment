#!/usr/bin/env bash

# exit on error
# rails secret | xclip -selection clipboard

set -o errexit

bundle install
# RAILS_ENV=production bin/rails assets:precompile
# ./bin/rails assets:clean

rails db:migrate RAILS_ENV=production

rails db:seed

# rails server -e production