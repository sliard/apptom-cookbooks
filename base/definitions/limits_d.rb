
define :limits_d, {
  :content => nil
} do
  limits_d_params = params

  raise "Please specify content with limits_d" unless limits_d_params[:content]

  if node['platform'] == 'debian'

    execute "active limits in pam common-session" do
      command 'echo -e "session required pam_limits.so" >> /etc/pam.d/common-session'
      not_if 'grep pam_limits.so /etc/pam.d/common-session'
    end

  end

  file "/etc/security/limits.d/#{limits_d_params[:name]}.conf" do
    content limits_d_params[:content] + "\n"
  end

end