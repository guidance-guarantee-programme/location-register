# Location Register

[![Build Status](https://travis-ci.org/guidance-guarantee-programme/location-register.svg?branch=master)](https://travis-ci.org/guidance-guarantee-programme/location-register)

Manage [Pension Wise] locations.


## Prerequisites

* [Bundler]
* [Git]
* [PostgreSQL]
* [Ruby 2.3.0][Ruby]
* [Signon] - not yet implemented


## Installation

Clone the repository:

```sh
$ git clone https://github.com/guidance-guarantee-programme/location-register.git
```

Setup the application:

```sh
$ ./bin/setup
```

## Usage

To start the application:

```sh
$ ./bin/foreman s -p <port>
```

where <port> is the port you'd like the application to listen on.

### Production-mode

To run the application in "production" mode, the following environment variables need to be set:

* `RAILS_ENV=production`
* `SECRET_KEY_BASE=<some secret token>`

## Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


## Contributing

Please see the [contributing guidelines](/CONTRIBUTING.md).

[bundler]: http://bundler.io
[git]: http://git-scm.com
[heroku]: https://www.heroku.com
[pension wise]: https://www.pensionwise.gov.uk          
[postgresql]: http://www.postgresql.org
[ruby]: http://www.ruby-lang.org/en
[signon]: https://github.com/guidance-guarantee-programme/signonotron2
