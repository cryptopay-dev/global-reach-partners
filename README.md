# GlobalReachPartners
Global reach partners provider API

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'global-reach-partners-provider'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install global-reach-partners
```

## Usage

### Rails

Add configure file `config/initializers/global_reach_partners.rb`
```ruby
GlobalReachPartners.configure do |config|
  config.url = 'https://portal-uat.globalreach-partners.com/TradeService.asmx' # Sandbox url
  config.client_code = 'TEST_XXX'
  config.username = 'USERNAME'
  config.password = 'PASSWORD'
  config.proxy = 'https://proxy'
end
```

### Methods

-  Get currencies:
```ruby
GlobalReachPartners.get_currencies # Returns array of GlobalReachPartners::Currency instances
```

- Get rate:
```ruby
GlobalReachPartners.get_rate(sell_currency: 'USD', buy_currency: 'EUR', amount: 1) # Returns the Rate instance
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
