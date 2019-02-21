# Tenios API Client ☎️

Get Call Detail Records (CDRs) from [Tenios API].

[Tenios API]: https://www.tenios.de/en/doc/api-cdr-request

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tenios-api'
```

## Usage

```ruby
require 'tenios-api'

client = Tenios::API::Client.new(access_key: ENV['TENIOS_ACCESS_KEY'])

client.cdrs(Time.new(2019, 2, 1)..Time.new(2019, 2, 2))
# returns lazy Enumerator with the records
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/carwow/tenios-api-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
