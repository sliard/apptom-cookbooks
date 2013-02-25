
define :base_ppa, {
  :url => nil
} do
  base_ppa_params = params

  raise "base_ppa command is only available on ubuntu" if node['platform'] != "ubuntu"

  raise "Please specify url with base_ppa" unless base_ppa_params[:url]

  package "python-software-properties"

  execute "apt-get-update" do
    command "apt-get update"
    action :nothing
  end

  execute "ppa : #{base_ppa_params[:name]}" do
    command "add-apt-repository #{base_ppa_params[:url]} && apt-get update"
    not_if "ls /etc/apt/sources.list.d | grep #{base_ppa_params[:name]}"
    notifies :run, "execute[apt-get-update]", :immediately
  end

end