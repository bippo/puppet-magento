# Class: magento
#
# This module manages magento
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
define magento(
  $install = false
) {

  $root = '/home/magento/sites/berbatik'
  $mysql_host = 'localhost'
  $mysql_user = 'berbatik_magento'
  $mysql_password = 'bippo'
  $mysql_dbname = 'berbatik_magento'
  $url = 'http://www.berbatik.com.vm/'
  $secure_url = 'http://www.berbatik.com.vm/'
  $admin_firstname = 'Berbatik'
  $admin_lastname = 'Sysadmin'
  $admin_email = 'admin@berbatik.com.vm'
  $admin_username = 'sysadmin'
  $admin_password = 'admin123'

  if $install {
    exec { install-magento:
      cwd => $root,
      creates => "${root}/app/etc/local.xml",
      path => '/usr/bin',
      command => "php -f install.php -- \
        --license_agreement_accepted \"yes\" \
        --locale \"id_ID\" \
        --timezone \"Asia/Bangkok\" \
        --default_currency \"IDR\" \
        --db_host \"${mysql_host}\" \
        --db_name \"${mysql_dbname}\" \
        --db_user \"${mysql_user}\" \
        --db_pass \"${mysql_password}\" \
        --url \"${url}\" \
        --use_rewrites \"${use_rewrites}\" \
        --use_secure \"no\" \
        --secure_base_url \"${secure_url}\" \
        --use_secure_admin \"no\" \
        --skip_url_validation \"yes\" \
        --admin_firstname \"${admin_firstname}\" \
        --admin_lastname \"${admin_lastname}\" \
        --admin_email \"${admin_email}\" \
        --admin_username \"${admin_username}\" \
        --admin_password \"${admin_password}\"",
      logoutput => true,
      user => 'magento',
      require => [Exec["setting-permissions"], Exec["create-magentodb-db"]],
    }
  }

}
