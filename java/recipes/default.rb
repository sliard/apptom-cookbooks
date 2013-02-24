
raise "Unknown java version #{node.java.default_version}, in #{node.java.versions.keys.join(" ")}" unless node.java.versions.keys.include? node.java.default_version

include_recipe "java::java_#{node.java.default_version}"

execute "set default java version" do
  command <<-EOF
  update-alternatives --set java /usr/lib/jvm/#{node.java.versions[node.java.default_version]}/bin/java &&
  update-alternatives --set javac /usr/lib/jvm/#{node.java.versions[node.java.default_version]}/bin/javac
  EOF
  not_if "readlink /etc/alternatives/java | grep #{node.java.versions[node.java.default_version]}"
end