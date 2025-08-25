# Inventory Management

This is a Ruby on Rails web application for inventory management.

## Interview Prompts

This application can be used as a baseline Ruby on Rails application for
feature development as evaluation criteria during technical interviews.

* [Tech lead prompts]

[Tech lead prompts]: ./TECH_LEAD_PROMPTS.md

## Local Development

You'll want to configure your machine to run:

* Ruby 3.2.2
* Node.js 14.9.0
* Postgres

## Setup

Please run 'bin/setup'.

## Running the Application Locally

Use [`heroku-cli`](https://devcenter.heroku.com/articles/heroku-cli):

```sh
bundle exec heroku local -f Procfile.dev
```

### Employee Credentials

Once the application has been seeded, you can use access codes from the
[`DevSeed`](./lib/dev_seed.rb) class (under `DevSeed::EMPLOYEES`) to
authenticate as different employees.

## Testing

Tests are written with [RSpec](https://rspec.info/).

To run the test suite:

```sh
bin/rspec
```

## License

Copyright 2020–2021 Techieminions. See the [LICENSE](LICENSE).
