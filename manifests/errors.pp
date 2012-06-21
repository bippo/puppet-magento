define magento::errors(
  $dir,
  $email,
  $user  = 'magento',
  $group = 'magento'
) {
  file { "${dir}/errors/local.xml":
  	ensure  => file,
  	owner   => $user,
  	group   => $group,
  	mode    => 0644,
  	content => template('magento/errors_local.xml.erb'),
  	notify    => Exec["magento cache-clear ${dir}"],
  }
}
