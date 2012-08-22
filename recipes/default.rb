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

def conf_template(conf_name, args)
  template conf_name do
    owner "root"
    group "root"
    source "ssmtp.conf.erb"
    variables(
      :root_user          => args['root_user'],
      :mail_hub           => args['mail_hub'],
      :rewrite_domain     => args['rewrite_domain'],
      :hostname           => args['hostname'],
      :from_line_override => args['from_line_override'],
      :use_tls            => args['use_tls'],
      :use_starttls       => args['use_starttls'],
      :tls_cert           => args['tls_cert'],
      :auth_user          => args['auth_user'],
      :auth_pass          => args['auth_pass'],
      :auth_method        => args['auth_method'],
    )
  end
end

if Chef::DataBag.list.keys.include? "ssmtp"
  configs = data_bag("ssmtp")
  configs.each do |config|
    merged_config = Chef::Mixin::DeepMerge.merge(node['ssmtp'].to_hash, data_bag_item("ssmtp", config).to_hash)
    conf_template "/etc/ssmtp/#{merged_config['config_name']}", merged_config
  end
else
  conf_template "/etc/ssmtp/ssmtp.conf", node['ssmtp']
end

