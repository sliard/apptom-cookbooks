
define :java_from_warp, {

} do

  jdk = node.java.versions[params[:name]]

  warp_file = "#{jdk}_`arch`.warp"

  execute "install #{jdk}" do
    command "cd /tmp && curl --location #{node.warp.warp_src}/#{warp_file} -o #{warp_file} && sh #{warp_file} && rm #{warp_file}"
    not_if "[ -d /usr/lib/jvm/#{jdk} ]"
  end

  execute "update alternative #{jdk}" do
    command <<-EOF
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/#{jdk}/bin/java 1 &&
    update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/#{jdk}/bin/javac 1
    EOF
    not_if "update-alternatives --list java | grep #{jdk}"
  end

end