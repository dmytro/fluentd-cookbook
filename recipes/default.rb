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

directory '/etc/fluent/' do
  owner  'fluent'
  group  'fluent'
  mode   '0755'
  action :create
end

directory '/var/log/fluent/' do
  owner  'fluent'
  group  'fluent'
  mode   '0755'
  action :create
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
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/fluent/fluent.conf")
end

