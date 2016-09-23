# PhonegapbuildRuby

Small ruby wrapper for most actions of the PhoneGap Build API, such as creating and building apps and unlocking signing keys

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phonegap_build'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phonegap_build

## Getting Started

### Require the library

    require 'phonegap_build'

### Create an API client

    username = 'email@example.com'
    password = 'my_secret_password'

    client = PhonegapBuild::Client.new(username, password)`

### Use the library

    puts client.me


## Reference

There are three important resources which you can manage over the API. The logged in user, his apps, and his signing keys.

The interface tries to mimic ActiveRecord, so most of it should work intuitively.

### User

#### Get user info

    client.me.to_s

### Apps

#### Get all and query apps

    client.apps.all
    #=> array of all apps

    client.apps.first
    #=> first app

    client.apps.find(2374624)
    #=> find app by id

#### Create a new app

    # create_method file requires you to upload the zipped app
    file = File.new('my_app.zip', 'rb')
    client.apps.create(title: 'myapp', create_method: 'file', debug: false,
      keys: [], file: file)

    # create_method remote_repo requires you to provide the repository url
    client.apps.create(title: 'myapp', create_method: 'file', debug: false,
      keys: [], repo: 'git@bitbucket.org/Zeilenwerk/phonegapbuild.git')

#### Update an existing app

    client.apps.find(2374624).update(debug: true)

#### Start a build for all platforms

    client.apps.find(2374624).build

#### Start a build for a specific platform

    client.apps.find(2374624).build(:android)

#### Delete an app

    client.apps.find(2374624).destroy

### Keys

#### List all keys

    client.keys.all

#### Add a key
    For Android

    file = File.new('my_app.keystore', 'rb')
    client.keys.create(platform: :android, title: 'myKey', keystore: ks_file,
      alias: 'myalias', keystore_pw: 'kspw1234', key_pw: '8rt3372fgta')

    or for iOS

    profile = File.new('profile.mobileprovision', 'rb')
    cert = File.new('cert.p12', 'rb')
    client.keys.create(platform: :ios, title: 'myKey', provision: profile,
      cert_name: cert, password: 'certificate_password')

#### Unlock a key for signing

    For Android

    client.keys.find(345453).update(key_pw: 'yxcvb', keystore_pw: 't3887werftgs')

    or for iOS

    client.keys.find(239784).update(password: 'certificate_password')


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phonegapbuild-ruby.
