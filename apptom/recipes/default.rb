
template "/tmp/deep_thought.txt" do
  source "deep_thought.txt.erb"
  variables :deep_thought => node['deep_thought']
  action :create
end