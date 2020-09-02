# Inventory Management

This is a Ruby on Rails web application for inventory management.

## Local Development

You'll want to configure your machine to run:

* Ruby 2.7.1
* NodeJS 14.9.0
* Postgres 12.4

### Preferred Setup: asdf and Homebrew

Install necessary language versions with [asdf](https://asdf-vm.com):

```sh
asdf install
```

Install necessary development dependencies with [Homebrew](https://brew.sh/):

```sh
brew bundle
```

## Running the Application Locally

Use [`heroku-cli`](https://devcenter.heroku.com/articles/heroku-cli):

```sh
heroku local -f Procfile.dev
```

### Development Seeds

Seed the database by running:

```sh
rake dev_seed
```

### Employee Credentials

Once the application has been seeded, you can use access codes from the
[`DevSeed`](./lib/dev_seed.rb) class (under `DevSeed::EMPLOYEES`) to
authenticate as different employees.

## Testing

Tests are written with [RSpec](https://rspec.info/).

To run the test suite:

```sh
./bin/rspec
```
