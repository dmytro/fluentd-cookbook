#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2013, Dmytro Kovalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
group 'fluent' do
  group_name 'fluent'
  gid        403
  action     [:create]
end

user 'fluent' do
  comment  'fluent'
  uid      403
  group    'fluent'
  home     '/var/run/fluent'
  shell    '/bin/false'
  password nil
  supports :manage_home => true
  action   [:create, :manage]
end


%w{ /etc/fluent/ /etc/fluent/config.d/ /var/log/fluent/ }.each do |dir|
  directory dir do
    owner  'fluent'
    group  'fluent'
    mode   '0755'
    action :create
  end
end

template "/etc/fluent/fluent.conf" do
  mode "0644"
  source "fluent.conf.erb"
end

template "/etc/init.d/fluent" do
  mode "0755"
  source "fluent.init_d.erb"
end

gem_package "fluentd"

service "fluent" do
  action :nothing
  supports [ :enable, :start, :restart ]
end

node[:fluentd][:plugins].each do |plugin|
  gem_package "fluent-plugin-#{plugin}"
end

#
# Handle sources and matches configuration
#
if node[:fluentd][:configs]
  node[:fluentd][:configs][:source].each do |config|
    template "#{config[:tag]}" do
      path      "/etc/fluent/config.d/source_#{config[:tag]}.conf"
      source    "plugin_source.conf.erb"
      variables config
      notifies :restart, "service[fluent]", :delayed
    end
  end

  node[:fluentd][:configs][:match].each do |config|
    cfg = config.dup
    template "#{cfg[:match]}" do
      path      "/etc/fluent/config.d/match_#{cfg[:match]}.conf"
      source    "plugin_match.conf.erb"
      variables({ :match => cfg.delete(:match), :type => cfg.delete(:type), :attributes => cfg })
      notifies :restart, "service[fluent]", :delayed
    end
  end
end
