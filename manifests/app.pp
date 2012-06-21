define magento::app(
  $dir,
  $install_date,
  $crypt_key,
  $table_prefix     = '',
  $db_host          = 'localhost',
  $db_user,
  $db_password,
  $db_name,
  $session_save,
  $user             = 'magento',
  $group            = 'magento'
) {
  file { "${dir}/app/etc/local.xml":
  	ensure  => file,
  	owner   => $user,
  	group   => $group,
  	mode    => 0400,
  	content => template('magento/app_local.xml.erb'),
  	notify    => Exec["magento cache-clear ${dir}"],
  }
}
