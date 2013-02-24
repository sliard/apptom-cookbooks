
define :nginx_add_default_location, {
  :upstream => nil,
  :content => nil,
} do
  nginx_add_default_location_params = params

  raise "Please specify content with nginx_add_default_location" unless nginx_add_default_location_params[:content]

  node.set[:nginx][:default_vhost][:enabled] = true
  node.set[:nginx][:default_vhost][:locations] = node.nginx.default_vhost.locations + [nginx_add_default_location_params]

end
