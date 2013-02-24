
template "/tmp/deep_thought.txt" do
  source "deep_thought.txt.erb"
  variables :deep_thought => node['platform_family']
  action :create
end