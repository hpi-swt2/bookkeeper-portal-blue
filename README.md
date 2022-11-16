# Bookkeeper Portal — 🟦 Edition
`dev` branch: [![CI & CD](https://github.com/hpi-swt2/bookkeeper-portal-blue/actions/workflows/ci_cd.yml/badge.svg?branch=dev)](https://github.com/hpi-swt2/bookkeeper-portal-blue/actions/workflows/ci_cd.yml)
, deployed staging app: [Heroku](https://bookkeeper-blue-dev.herokuapp.com)

`main` branch: [![CI & CD](https://github.com/hpi-swt2/bookkeeper-portal-blue/actions/workflows/ci_cd.yml/badge.svg?branch=main)](https://github.com/hpi-swt2/bookkeeper-portal-blue/actions/workflows/ci_cd.yml)
, deployed app: [Heroku](https://bookkeeper-blue-main.herokuapp.com)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

A web application for keeping track of items and loaning them out, written in [Ruby on Rails](https://rubyonrails.org/).
Created in the [Scalable Software Engineering course](https://hpi.de/plattner/teaching/winter-term-2022-23/scalable-software-engineering.html) at the HPI in Potsdam.

## Branch Naming

Branch names have the following structure: `<type>/<team>-<issue-number>-<issue-name>`

- `<type>` gets replaced with feature or fix, depending on the type of changes introduced by the branch 

- `<team>` gets replaced with the abbreviation (e.g. BR) of the team that mostly develops on the branch 

- `<issue-number>` gets replaced with the number of the issue the branch aims to close 

- `<issue-name>` gets replaced with the name of the issue the branch aims to close, or a shortened form of it 

Experimental branches may use the structure `experimental/<anything>`

## Development Setup
Ensure you have access to a Unix-like environment through:

* Your local Linux / MacOS installation
* Using the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) (WSL)
* Using a VM, e.g. [Virtualbox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/)
* Using a [docker](https://docs.microsoft.com/en-us/windows/wsl/install) container

### Application Setup
* `ruby --version` Ensure Ruby v2.7.4 using [rbenv](https://github.com/rbenv/rbenv) or [RVM](http://rvm.io/)
* `sqlite3 --version` Ensure [SQLite3 database installation](https://guides.rubyonrails.org/getting_started.html#installing-sqlite3)
* `bundle --version` Ensure [Bundler](https://rubygems.org/gems/bundler) installation (`gem install bundler`)
* `bundle config set without 'production' && bundle install` Install gem dependencies from `Gemfile`
* `rails db:migrate` Setup the database, run migrations
* `rails assets:precompile && rails s` Compile assets & start dev server (default port _3000_)
* `bundle exec rspec --format documentation` Run the tests (using [RSpec](http://rspec.info/) framework)

## Developer Guide

### Employed Frameworks
* [Stimulus JS](https://stimulus.hotwired.dev) as the default JavaScript framework, augmenting HTML
* [Bootstrap](https://getbootstrap.com/docs/5.2) for layout, styling and [icons](https://icons.getbootstrap.com/)
* [Devise](https://github.com/heartcombo/devise) library for authentication
* [FactoryBot](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#defining-factories) to generate test data
* [Capybara](https://github.com/teamcapybara/capybara#the-dsl) for feature testing
* [shoulda](https://github.com/thoughtbot/shoulda-matchers#matchers) for additional RSpec matchers

### Cheat Sheets
* [FactoryBot](https://devhints.io/factory_bot)
* [Testing using Capybara](https://devhints.io/capybara)

### Setup
* `bundle exec rails db:migrate RAILS_ENV=development && bundle exec rails db:migrate RAILS_ENV=test` Migrate both test and development databases
* `rails assets:clobber && rails assets:precompile` Redo asset compilation

### Testing
* `bundle exec rspec` Run the full test suite
  * `--format doc` More detailed test output
  * `-e 'search keyword in test name'` Specify what tests to run dynamically
  * `--exclude-pattern "spec/features/**/*.rb"` Exclude feature tests (which are typically fairly slow)
* `bundle exec rspec spec/<rest_of_file_path>.rb` Specify a folder or test file to run
* `bundle exec rspec --profile` Examine run time of tests
* Code coverage reports are written to `coverage/index.html` after test runs (by [simplecov](https://github.com/simplecov-ruby/simplecov))

### Linting
* `bundle exec rubocop` Use the static code analyzer [RuboCop](https://github.com/rubocop-hq) to find possible issues (based on the community [Ruby style guide](https://github.com/rubocop-hq/ruby-style-guide)).
  * `--autocorrect` to fix what can be fixed automatically.
  * RuboCop's behavior can be [controlled](https://docs.rubocop.org/en/latest/configuration) using `.rubocop.yml`

You can put the following script in `.git/hooks/pre-commit` to run RuboCop before each commit (run `chmod +x .git/hooks/pre-commit` to make it executable):

```bash
#!/bin/bash

# Exit if one of the following commands fails
set -e

# The branch we want to diff against
BASE=$(git merge-base origin/dev HEAD)

# Find all changed ruby files
FILES=$(git diff --name-only --diff-filter=d ${BASE} HEAD '*.rb')

# Execute Linters
bundle exec rubocop --force-exclusion --parallel $FILES
```

### Debugging
* `debug` anywhere in the code to access an interactive console
* `save_and_open_page` within a feature test to inspect the state of a webpage in a browser
* `rails c --sandbox` Test out some code in the Rails console without changing any data
* `rails dbconsole` Starts the CLI of the database you're using
* `bundle exec rails routes` Show all the routes (and their names) of the application
* `bundle exec rails about` Show stats on current Rails installation, including version numbers

### Generating
* `rails g migration DoSomething` Create migration _db/migrate/*_DoSomething.rb_
* `rails generate` takes a `--pretend` / `-p` option that shows what will be generated without changing anything
