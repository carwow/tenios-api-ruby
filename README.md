# Tenios API Client ☎️

HTTP client for [Tenios API].

[Tenios API]: https://www.tenios.de/doc-topic/voice-api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tenios-api'
```

## Usage

```ruby
require 'tenios-api'

client = Tenios::API::Client.new(access_key: ENV['TENIOS_ACCESS_KEY'])
```

### Call Detail Records

[Tenios documentation](https://www.tenios.de/en/doc/api-cdr-request)

#### Retrive

```ruby
client.cdrs.retrieve(Time.utc(2019, 2, 1)..Time.utc(2019, 2, 2))
# returns lazy Enumerator with the records
```

### Number Order

[Tenios documentation](https://www.tenios.de/en/doc/api-number-order)

#### Verification

```ruby
# check Tenios documentation for verification options
verification_id = client.verification.create(options)['verification_id']
```

#### Order

```ruby
order_id = client.number.order(verification_id: verification_id)['order_id']
```

#### Cancel

```ruby
client.number.cancel(phone_number: '+49888888')
```

### Record Call

[Tenios documentation](https://www.tenios.de/en/doc/api-call-recording)

#### Start

```ruby
recording_uuid = client.record_call.start(call_uuid: '9315b018-86bd-424f-a086-7095ce427130')['recording_uuid']
```

#### Stop

```ruby
client.record_call.stop(
  call_uuid: '9315b018-86bd-424f-a086-7095ce427130',
  recording_uuid: recording_uuid
)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/carwow/tenios-api-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
