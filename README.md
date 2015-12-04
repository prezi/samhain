# samhain
Installs and configures Samhain for host integrity monitoring. 

## Supported Platforms

supports ubuntu 14.04

## Attributes

The attributes in `attributes/default.rb` are for the 
basic configuration of Samhain, they write to a file 
at `/etc/samhain/samhainrc` The config is written at 
run time and can be extended from any book by adding 
attributes. Since the samhainrc is not a perfect hash, 
the syntax for adding attributes is a bit different. 

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

### samhain::default

Include `samhain` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[samhain::default]"
  ]
}
```

## License and Authors

Author:: Ele Mooney (ele.mooney@socrata.com)
