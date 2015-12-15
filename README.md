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

This cookbook is currently tested against Ubuntu 14.04 only. Any other
platforms, YMMV.

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
