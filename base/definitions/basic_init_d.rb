
define :basic_init_d, {
  :daemon => nil,
  :options => "",
  :user => nil,
  :make_pidfile => true,
  :background => true,
  :file_check => [],
  :executable_check => [],
  :directory_check => [],
  :vars_to_unset => [],
  :auto_start => true,
  :working_directory => nil,
  :log_file => nil,
  :pid_directory => "/var/run",
  :code => '',
  :check_start => {
    :initial_delay => 0.5,
    :loop_delay => 0.2,
    :max_delay => 5,
  },
} do
  basic_init_d_params = params

  raise "Please specify daemon with basic_init_d" unless basic_init_d_params[:daemon]

  start_options = ""
  start_options += " -m" if basic_init_d_params[:make_pidfile]
  start_options += " -b" if basic_init_d_params[:background]
  start_options += " -c #{basic_init_d_params[:user]}" if basic_init_d_params[:user]
  start_options += " -d #{basic_init_d_params[:working_directory]}" if basic_init_d_params[:working_directory]

  su_command = '"'
  su_command += "cd #{basic_init_d_params[:working_directory]} &&" if basic_init_d_params[:working_directory]
  su_command = "su #{basic_init_d_params[:user]} -c " + su_command if basic_init_d_params[:user]

  end_of_command = ""
  end_of_command = "2>&1 | tee #{basic_init_d_params[:log_file]}" if basic_init_d_params[:log_file]

  post_start = ""
  post_start += "chown #{basic_init_d_params[:user]} $PID_FILE" if basic_init_d_params[:make_pidfile]

  template "/etc/init.d/#{basic_init_d_params[:name]}" do
    cookbook "base"
    source "basic_init_d.erb"
    mode '0755'
    variables({
      :daemon => basic_init_d_params[:daemon],
      :name => basic_init_d_params[:name],
      :pid_file => "#{basic_init_d_params[:pid_directory]}/#{basic_init_d_params[:name]}.pid",
      :options => basic_init_d_params[:options],
      :file_check => basic_init_d_params[:file_check],
      :directory_check => basic_init_d_params[:directory_check],
      :executable_check => basic_init_d_params[:executable_check] + ["$DAEMON"],
      :start_options => start_options,
      :end_of_command => end_of_command,
      :post_start => post_start,
      :su_command => su_command,
      :vars_to_unset => basic_init_d_params[:vars_to_unset],
      :code => basic_init_d_params[:code],
      :check_start => basic_init_d_params[:check_start],
      })
  end

  if basic_init_d_params[:auto_start]

    service basic_init_d_params[:name] do
      supports :status => true, :restart => true
      action auto_compute_action
    end

  end

end