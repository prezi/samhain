Samhain Cookbook
================
[![Cookbook Version](https://img.shields.io/cookbook/v/samhain.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/samhain.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/samhain.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/samhain.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/samhain
[travis]: https://travis-ci.org/socrata-cookbooks/samhain
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/samhain
[coveralls]: https://coveralls.io/r/socrata-cookbooks/samhain

Installs and configures Samhain for host integrity monitoring. 

Requirements
============

This cookbook currently supports Ubuntu only and is actively tested against
15.10 and 14.04. The hope is to support other platforms as well in the future.

Assorted older Chef and Ruby conventions are intentionally used to (for now)
maintain compatibility with Chef 11.

Usage
=====

Include `samhain` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[samhain::default]"
  ]
}
```

Recipes
=======

***default***

Do a simple, attribute-based install of Samhain.

Attributes
==========

***default***

The attributes in `attributes/default.rb` are for the basic configuration of
Samhain. They write to a file at `/etc/samhain/samhainrc` The config is written
at run time and can be extended from any book by adding attributes. Since the
samhainrc is not a perfect hash, the syntax for adding attributes is a bit
different. 

To overwrite regular attributes:
```ruby
    ['samhain']['config']['Misc']['bacon'] = 'Applewood Smoked'
```
To add files or directories for monitoring: 
```ruby
    ['samhain']['config']['LogFiles']['file']['path/to/my/file'] = true
```
## Usage
The intent of the attributes file is to allow
service owners to add files to the Samhain watchlist. 
For more information on Samhain, see their docs at
[Samhain Labs](http://www.la-samhna.de/samhain/s_documentation.html)

Resources
=========

***samhain***

A parent resource for the Samhain components.

Syntax:

    samhain 'default' do
        config { 'Attributes' => { 'file' => { '/etc/mtab' => true } } }
        source 'http://example.com/samhain.package'
        action :create
    end

Actions:

| Action    | Description                                  |
|-----------|----------------------------------------------|
| `:create` | Install, configure, and enaile+start Samhain |
| `:remove` | Stop+disable and remove Samhain              |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| config    | `nil`      | A Samhain configuration hash        |
| source    | `nil`      | An optional custom package PATH/URL |
| action    | `:create`  | Action(s) to perform                |

***samhain_app***

A resource for installation and removal of the Samhain app package.

Syntax:

    samhain_app 'default' do
        source 'http://example.com/samhain.package'
        action :install
    end

Actions:

| Action     | Description                   |
|------------|-------------------------------|
| `:install` | Install the Samhain package   |
| `:remove`  | Uninstall the Samhain package |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| source    | `nil`      | An optional custom package PATH/URL |
| action    | `:install` | Action(s) to perform                |

***samhain_config***

A resource for generating Samhain configurations.

Syntax:

    samhain_config 'default' do
        config { 'Attributes' => { 'file' => { '/etc/mtab' => true } } }
        action :create
    end

Actions:

| Action    | Description                         |
|-----------|-------------------------------------|
| `:create` | Write out the samhainrc config file |
| `:remove` | Delete the samhainrc config file    |

Attributes:

| Attribute | Default    | Description                         |
|-----------|------------|-------------------------------------|
| config    | `nil`      | A Samhain configuration hash        |
| action    | `:create`  | Action(s) to perform                |

***samhain_service***

A resource for the Samhain service.

Syntax:

    samhain_service 'default' do
        action [:create, :enable, :start]
    end

Actions:

| Action     | Description                   |
|------------|-------------------------------|
| `:create`  | Ensure the service is defined |
| `:remove`  | Delete the service definition |
| `:enable`  | Enable the service            |
| `:disable` | Disable the service           |
| `:start`   | Start the service             |
| `:stop`    | Stop the service              |
| `:restart` | Restart the service           |

Attributes:

| Attribute | Default                      | Description          |
|-----------|------------------------------|----------------------|
| action    | `[:create, :enable, :start]` | Action(s) to perform |

Providers
=========

***Chef::Provider::Samhain***

Platform-agnostic provider that wraps each of the Samhain component resources.

***Chef::Provider::SamhainApp***

The parent for all platform-specific Samhain app package providers.

***Chef::Provider::SamhainApp::Ubuntu***

An implementation of the samhain_app provider for Ubuntu.

***Chef::Provider::SamhainService***

Platform-agnostic provider for managing the Samhain service.

***Chef::Provider::SamhainServce::Ubuntu::Trusty***

Specialized provider to patch the malfunctioning init script that ships with
Samhain for Ubuntu 14.04.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author:: Ele Mooney <ele.mooney@socrata.com>
- Author:: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2015 Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
