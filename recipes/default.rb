#
# Cookbook Name:: letsencrypt
# Recipe:: default
#
# Copyright 2016, Kenji Akiyama
#
# All rights reserved - Do Not Redistribute
#

cache_path = Chef::Config[:file_cache_path]
repository_path = cache_path + '/' + node['letsencrypt']['repository']['local']
http_service_name = node['letsencrypt']['http_service']['name']
urls = node['letsencrypt']['urls']


bash 'clone_repository' do
  cwd cache_path
  code <<-EOH
git clone #{node['letsencrypt']['repository']['remote']}
EOH
  not_if { File::exists? "#{repository_path}" }
end

urls.each do |url|
  bash 'create_cert_file' do
    cwd repository_path
    code <<-EOH
./letsencrypt-auto certonly \
-m #{node['letsencrypt']['email']}
-d #{url} \
--agree-tos
EOH
    not_if { File::exists? "/etc/letsencrypt/live/#{url}" }
  end
end

template "/var/chef/cache/letsencrypt-update.sh" do
  source "update.sh.erb"
  mode "0755"
  variables (
    {
      repository_path: repository_path,
      http_service_name: http_service_name,
    }
  )
end

template "/etc/cron.d/letsencrypt" do
  source "cron.erb"
  mode "0644"
end
