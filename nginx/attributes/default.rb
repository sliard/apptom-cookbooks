default[:nginx][:deploy_default_config] = true

default[:nginx][:default_root] = "/var/www/nginx-default";

default[:nginx][:default_vhost] = {
  :listen => '0.0.0.0:80',
  :virtual_host => nil,
  :enabled => true,
  :locations => [],
}

default[:nginx][:config] = {
  :worker_connections => 100000,
  :max_upload_size => '50m',
}

default[:nginx][:package_name] = "nginx"
