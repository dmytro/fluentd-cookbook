fluentd Cookbook
=====================

This is re-write of original td-agent cookbook, which is seriously overenginered and fails in places, especially with second Ruby installed (via RVM,for example).


Requirements
------------

- init.d script relies on RVM being installed in `/usr/local/rvm`.

Attributes
----------

None

e.g.
#### fluentd::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['fluentd']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### fluentd::default

Just include `fluentd` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[fluentd]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: 
Dmytro Kovalov dmytro.kovalov@gmail.com
