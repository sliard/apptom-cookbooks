
jdk_version = node['java']['jdk_version'].to_i
java_home = node['java']['java_home']
java_home_parent = ::File.dirname java_home
jdk_home = ""

pkgs = value_for_platform(
    ["centos","redhat","fedora","scientific","amazon"] => {
        "default" => ["java-1.#{jdk_version}.0-openjdk","java-1.#{jdk_version}.0-openjdk-devel"]
    },
    ["debian","ubuntu"] => {
        "default" => ["openjdk-#{jdk_version}-jdk","default-jre-headless"]
    },
    ["arch","freebsd"] => {
        "default" => ["openjdk#{jdk_version}"]
    },
    "default" => ["openjdk-#{jdk_version}-jdk"]
)

# done by special request for rberger
ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
  not_if { ENV["JAVA_HOME"] == java_home }
end

file "/etc/profile.d/jdk.sh" do
  content <<-EOS
    export JAVA_HOME=#{node['java']['java_home']}
  EOS
  mode 0755
end

package "openjdk-6-jdk" do
    action :install
end
