#
# Cookbook Name:: chef-ssmtp
# Recipe:: default
#
# Copyright 2012, Morgan Nelson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package "ssmtp" do
  action :install
end

# detect databag if present
if Chef::DataBag.list.keys.include? "ssmtp"
  configs = data_bag("ssmtp")
  configs.each do |config|
    # iterate over databag items, merging options
    merged_config = node['ssmtp'].merge(config)
    ## create a conf file from a template
    template "/etc/ssmtp/#{merged_config.id}.conf" do
      owner "root"
      group "root"
      source "ssmtp.conf.erb"
      variables(
        :root_user          => merged_config['root_user'],
        :mail_hub           => merged_config['mail_hub'],
        :rewrite_domain     => merged_config['rewrite_domain'],
        :hostname           => merged_config['hostname'],
        :from_line_override => merged_config['from_line_override'],
        :use_tls            => merged_config['use_tls'],
        :use_starttls       => merged_config['use_starttls'],
        :tls_cert           => merged_config['tls_cert'],
        :auth_user          => merged_config['auth_user'],
        :auth_pass          => merged_config['auth_pass'],
        :auth_method        => merged_config['auth_method'],
      )
    end
  end
else
  template "/etc/ssmtp/ssmtp.conf" do
    owner "root"
    group "root"
    source "ssmtp.conf.erb"
    variables(
      :root_user          => node['ssmtp']['root_user'],
      :mail_hub           => node['ssmtp']['mail_hub'],
      :rewrite_domain     => node['ssmtp']['rewrite_domain'],
      :hostname           => node['ssmtp']['hostname'],
      :from_line_override => node['ssmtp']['from_line_override'],
      :use_tls            => node['ssmtp']['use_tls'],
      :use_starttls       => node['ssmtp']['use_starttls'],
      :tls_cert           => node['ssmtp']['tls_cert'],
      :auth_user          => node['ssmtp']['auth_user'],
      :auth_pass          => node['ssmtp']['auth_pass'],
      :auth_method        => node['ssmtp']['auth_method'],
    )
  end
end


