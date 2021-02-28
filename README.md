# Tolk
<a href="https://badge.fury.io/rb/tolk" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/tolk.svg" alt="Gem Version"></a>
<a href='https://github.com/tolk/tolk/actions' target='_blank'><img src="https://github.com/tolk/tolk/workflows/Tests/badge.svg" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/tolk' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://ruby-gem-downloads-badge.herokuapp.com/tolk?label=rubygems&type=total&total_label=downloads&color=brightgreen' border='0' alt='RubyGems Downloads' /></a>

Tolk is a Rails Engine that provides a web interface for editing I18n translations.

## Install

To install add the following to your Gemfile:

```ruby
gem 'tolk'
```

Also add either [`kaminari`](https://github.com/amatsuda/kaminari) or [`will_paginate`](https://github.com/mislav/will_paginate):

```ruby
gem 'kaminari'
# OR
gem 'will_paginate'
```

To setup just run the following command and follow the on-screen instructions.

```bash
$ rake tolk:setup
```

## Usage

### Setup and Import

Tolk treats `I18n.default_locale` as the master source of strings to be translated. If you want the master source to be different from `I18n.default_locale`, you can override it by setting `Tolk::Locale.primary_locale_name`. Developers are expected to make all the changes to the master locale file ( en.yml by default ) and treat all the other locale.yml files as readonly files.

As tolk stores all the keys and translated strings in the database, you need to ask Tolk to update its database from the primary yml file:

The below command will fetch all the new keys from en.yml and put them in the database. Additionally, it'll also get rid of the deleted keys from the database and reflect updated translations - if any.

```bash
$ rake tolk:sync
```

If you already have data in your non primary locale files, you will need to import those to Tolk as a one time thing:

```bash
$ rake tolk:import
```

Upon visiting `http://your_app.com/tolk` - you will be presented with different options like creating new locale or providing translations for the existing locales.


### Saving Locales To Files


Once done with translating all the pending strings, you are can write back the new locales to filesystem. You have two options when dumping database locale data to file:

To generate a single yml file for a specified locale. The locale ISO code should be given in string format as the only argument ("en-us" or "en-gb" for example).

```bash
$ rake tolk:dump_yaml["the_target_locale"]
```

To generate individual .yml files for all non primary locales and put them in `#{Rails.root}/config/locales/` directory by default.

```bash
$ rake tolk:dump_all
```

You can use the dump_all method defined in `Tolk::Locale` directly and pass directory path as the argument if you want the generated files to be at a different location:

```bash
$ rails runner "Tolk::Locale.dump_all('/path/to/your/folder/')"
```

You can even download the yml file using Tolk web interface by appending `.yaml` to the locale url. E.g `http://your_app.com/tolk/locales/de.yaml`

### Additional Configuration Settings

You can add some settings in the initializer file

```ruby
# config/initializers/tolk.rb

Tolk.config do |config|
  # exclude locales tokens from gems.
  config.exclude_gems_token = true

  # reject files of type xxx.<locale>.yml when syncing locales.
  config.block_xxx_en_yml_locale_files = true

  # Dump locale path by default the locales folder (config/locales).
  config.dump_path = '/new/path'

  # Mapping : a hash of the type { 'ar' => 'Arabic' }.
  config.mapping['en'] = 'New English'
  config.mapping['fr'] = 'New French'

  # primary locale to not be overriden by default locale in development mode.
  config.primary_locale_name = 'de'

  # Don't strip translation texts automatically
  config.strip_texts = false
  
  # Ignore all faker.* and devise.* keys
  config.ignore_keys = ['faker', 'devise']
end
```

### Translation Statistics

You can get statistics about missing or updated translations to be tracked for third party tools in `http://your_app.com/tolk/stats.json` endpoint.

```json
{
  "ca":
    {
      "missing":1377,
      "updated":1,
      "updated_at":"2013-03-04T13:06:46Z"
    },
  "fr":
    {
      "missing":735,
      "updated":5,
      "updated_at":"2013-03-04T13:15:51Z"
    }
}
```

## Authentication

If you want to authenticate users who can access Tolk, you can provide a <tt>Tolk::ApplicationController.authenticator</tt> proc. The Authenticator proc will be run from a before filter in controller context.

For example:

```ruby
  # config/initializers/tolk.rb
  Tolk::ApplicationController.authenticator = ->(){
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'translator' && password == 'password'
    end
  }
```

Alternatively you can secure it within your routes:

```ruby
authenticate :user, ->(){|user| user.admin? } do
  mount Tolk::Engine, at: "/tolk"
end
```

## Handling blank and non-string values

Tolk speaks YAML for non strings values. If you want to enter a nil values, you could just enter '~'. Similarly, for an Array value, you could enter:

```yml
  ---
  - Sun
  - Mon
```

And Tolk will take care of generating the appropriate entry in the YAML file.


# Screenshots

<img src="https://raw.githubusercontent.com/westonganger/tolk/master/screenshot_1.png"/>

<img src="https://raw.githubusercontent.com/westonganger/tolk/master/screenshot_2.png"/>


## Contributing

We test multiple versions of `Rails` using the `appraisal` gem. Please use the following steps to test using `appraisal`.

1. `bundle exec appraisal install`
2. `bundle exec appraisal rake test`
