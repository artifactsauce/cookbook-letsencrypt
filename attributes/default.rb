default['letsencrypt']['repository']['remote'] = "https://github.com/letsencrypt/letsencrypt"
default['letsencrypt']['repository']['local']['name'] = "letsencrypt"
default['letsencrypt']['repository']['local']['parent_path'] = Chef::Config[:file_cache_path]
default['letsencrypt']['script']['parent_path'] = Chef::Config[:file_cache_path]
default['letsencrypt']['http_service']['name'] = "nginx"
default['letsencrypt']['email'] = "anonyous@example.com"
default['letsencrypt']['cdn']['enabled'] = false
default['letsencrypt']['cdn']['provider'] = nil
