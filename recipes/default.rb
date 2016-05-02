#
# Cookbook Name:: letsencrypt
# Recipe:: default
#
# Copyright 2016, Kenji Akiyama
#
# All rights reserved - Do Not Redistribute
#

parent_path = node['letsencrypt']['repository']['local']['parent_path']
repository_path = parent_path + '/' + node['letsencrypt']['repository']['local']['name']
update_script_path = node['letsencrypt']['script']['parent_path'] + '/letsencrypt-update.sh'
http_service_name = node['letsencrypt']['http_service']['name']
urls = node['letsencrypt']['urls']


bash 'clone_repository' do
  cwd parent_path
  code <<-EOH
git clone #{node['letsencrypt']['repository']['remote']}
EOH
  not_if { File::exists? "#{repository_path}" }
end

urls.each do |url|
  bash 'create_cert_file' do
    cwd repository_path
    code <<-EOH
./letsencrypt-auto certonly --non-interactive --standalone \
-m #{node['letsencrypt']['email']} \
-d #{url} \
--agree-tos
EOH
    not_if { File::exists? "/etc/letsencrypt/live/#{url}" }
  end
end

template update_script_path do
  source "update.sh.erb"
  mode "0755"
  variables (
    {
      repository_path: repository_path,
      http_service_name: http_service_name,
      cdn: node['letsencrypt']['cdn'],
    }
  )
end

template "/etc/cron.d/#{node['letsencrypt']['repository']['local']['name']}" do
  source "cron.erb"
  mode "0644"
  variables (
    {
      script_path: update_script_path,
    }
  )
end
