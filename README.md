fluentd Cookbook
=====================

This is re-write of original td-agent cookbook, which is seriously overenginered and fails in places, especially with second Ruby installed (via RVM,for example).

Cookbooks installs fluents and basic configuration file. Additional configuratuion provides means to install fluentd plugins and create configrations for input plugins (sources) and output ones (matches).

Requirements
------------

- init.d script relies on RVM being installed in `/usr/local/rvm`.

Attributes
----------

* node[:fluentd][:plugins] - Array. List of short names of the fluent plugins, i.e gem name withoug
* node[:fluentd][:configs][:source] - Array of Hashes for input plugin configration
* node[:fluentd][:configs][:match] - Array of Hashes for output plugin configuration

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

#### Example usage with databag

* Role file

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ruby

    name "logger"
    description "Log server"
    
    run_list("recipe[fluentd]")
    
    override_attributes 'fluentd' => { 
        'plugins' => [ 's3' ],
        'configs' => Chef::DataBag.load(:application)["logger"]
    }

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Databag

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~json

    {
    "id" : "logger",
        "source" : [
        {
            "type" :      "tail",
            "format" :    "syslog",
            "path":      "/var/log/messages,
            "pos_file":  "/var/log/messages.pos,
            "tag":       "tail.syslog"
        }
    ],
    "match" : [
        {
	        "match":              "tail.syslog",
	        "type":              "s3",
	        "aws_key_id":        "SECRET",
	        "aws_sec_key":       "BIGSECRET",
	        "s3_bucket":         "logbucket",
	        "s3_endpoint":       "",
	        "path":              "syslog/",
	        "buffer_path":       "/var/log/fluent/buf/s3.syslog",
	        "time_slice_format": "%Y/%m/%d/%H",
	        "flush_interval":    "10m"
        }
	]
    }

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
License: MIT

October, 2013

Authors: 

* Dmytro Kovalov, dmytro.kovalov@gmail.com

