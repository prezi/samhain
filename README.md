# samhain-cookbook
Installs and configures Samhain for host integrity monitoring. 
Samhain is pronounced 'saah-win' or 'saa-ween'

## Supported Platforms

Ubuntu 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['samhain']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

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

Author:: Ele Mooney (<ele.mooney@socrata.com>)
