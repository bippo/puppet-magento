# Bippo's (legacy, but works) way to deploy module/theme/translation to
# a Magento instance over SSH
define magento::deploy(
  $marker_file,       # Relative path to file or directory inside $magento_dir that marks if the extension is installed
  $git_url,           # Repository URI, read-only URI is recommended
  $git_name,          # Name of repository, e.g. jquery-magento
  $user        = 'magento',
  $git_dir     = '/home/magento/git',
  $subdir      = '',  # if the git repository contains multiple projects, provide the subdirectory path here
  $server_user = 'magento',
  $server_host = 'localhost',
  $server_port = 22,
  $magento_dir,       # MUST be an absolute path, will be used to check marker file existence also
) {
  exec { "clone ${git_name} to ${git_dir}":
    creates   => "${git_dir}/${git_name}",
    cwd       => $git_dir,
    command   => "git clone ${git_url} ${git_name}",
    path      => ['/usr/local/bin', '/usr/bin'],
    user      => $user,
  	logoutput => true,
  	require   => [ Package['git'], File[$git_dir] ],
  }

  exec { "deploy ${git_name}/${subdir} to ${magento_dir}":
    creates   => "${magento_dir}/${marker_file}",
    cwd       => "${git_dir}/${git_name}/${subdir}",
    command   => "ant deploy -Dserver.user='${server_user}' -Dserver.host='${server_host}' -Dserver.port='${server_port}' -Dserver.dir='${magento_dir}'",
    path      => ['/usr/local/bin', '/usr/bin'],
    user      => $user,
  	logoutput => true,
  	require   => [ Package['ant'], File['/usr/share/ant/lib/jsch.jar'], Exec["clone ${git_name} to ${git_dir}"] ],
  	notify    => [ Exec["magento compiler-compile ${magento_dir}"],
                   Exec["magento cache-clear ${magento_dir}"] ],
  }

}
