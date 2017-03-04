# Yp::Ruby

Ruby Class bindings for the Yorkshire Payments Direct HTTP Integration API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yp-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yp-ruby

## Usage

Different classes are available for the Gateway actions:

 - Yp::Sale
 - Yp::Preauth
 - Yp::Verify
 
If you need support for more actions, please [open an issue](https://github.com/andytango/yp-ruby/issues)!

### Authentication and params
 
You will need to pass in the correct parameters according to the Yorkshire Payments integration guide:

```ruby

signature_key = 'Engine0Milk12Next'

params = {
  merchantID: '101381',
  countryCode: 826,
  currencyCode:  826,
  cardNumber:  '4012001037141112',
  cardExpiryMonth:  12,
  cardExpiryYear:  15,
  cardCVV:  '083',
  customerName:  'Yorkshire Payments',
  customerEmail:  'support@yorkshirepayments.com',
  customerAddress:  '16 Test Street',
  customerPostCode:  'TE15 5ST',
  orderRef:  'Test purchase'
}

transaction = Yp::Sale.new(signature, params)

```

The library will *not* validate your parameters before sending. This feature is coming soon.

You pass in a callback method as a block, or access the response after the transaction is sent:

```ruby

transaction.send! do |response|
  puts response.state # --> 'captured'
end

# OR:

response = transaction.send!
puts response.state # --> 'captured'

```

### Error Handling

The client will raise a number of different types of errors:

#### Validation Errors

These occur if we could not perform any validation. This means the response is 
malformed and can arise if you did not correctly sign your request:

 - Yp::Response::InvalidSignatureError (potentially malicious)
 - Yp::Response::MissingSignatureError
 - Yp::Response::MissingResponseCodeError
 
#### Gateway Errors

These occur if, during validation, we found a Gateway error code. These come in 
three different flavours:

 - Yp::Response::MissingFieldError: _a field was missing in your request_
 - Yp::Response::InvalidFieldError: _a field value was invalid in your request_
 - Yp::Response::GatewayError: _the error could not be classified. The gateway's
 error message will be supplied_
 
#### Transaction Declined Error

This occurs if the transaction has entered the **Declined** state:
     
  - Yp::Response::DeclinedError

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andytango/yp-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

