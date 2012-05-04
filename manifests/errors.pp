define magento::errors(
  $dir,
  $email
) {
  file { "${dir}/errors/local.xml":
  	ensure  => file,
  	owner   => magento,
  	group   => magento,
  	mode    => 0644,
  	content => template('magento/errors_local.xml.erb'),
  	notify    => Exec["magento cache-clear ${dir}"],
  }
}
