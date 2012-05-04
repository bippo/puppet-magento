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
define magento::install(
  # URI of Magento distribution package
  $dist_uri = 'http://33.33.33.1:8080/nexus/service/local/repositories/releases/content/id/co/bippo/commerce/magento-bippo/1.6.2.0_1/magento-bippo-1.6.2.0_1.tar.gz'
) {

  $root = '/home/magento/sites/berbatik'
  $mysql_host = 'localhost'
  $mysql_user = 'berbatik'
  $mysql_password = 'bippo'
  $mysql_dbname = 'berbatik_magento'
  $url = 'http://www.berbatik.com.vm/'
  $use_rewrites = 'yes'
  $secure_url = 'http://www.berbatik.com.vm/'
  $admin_firstname = 'Berbatik'
  $admin_lastname = 'Sysadmin'
  $admin_email = 'hendy+berbatik@soluvas.com' # admin@berbatik.com.vm is not valid email, WTF?
  $admin_username = 'sysadmin'
  $admin_password = 'admin123'

  file { '/home/magento/scripts':
  	ensure => directory,
  	owner  => magento,
    group  => magento,
    mode   => 0755,
  }
  file { '/home/magento/scripts/extract-magento.sh':
  	ensure  => file,
  	source  => 'puppet:///modules/magento/extract-magento.sh',
  	owner   => magento,
    group   => magento,
    mode    => 0755,
    require => File['/home/magento/scripts'],
  }

    # TODO: No download or install is need if Magento is already setup
  	file { magento-dist:
  	  name   => '/home/magento/dist',
  	  ensure => directory,
  	  owner  => magento,
  	  group  => magento,
  	}
  	exec { download-magento:
      cwd       => '/home/magento/dist',
      creates   => '/home/magento/dist/magento-bippo-1.6.2.0_1.tar.gz',
  	  command   => "wget '${dist_uri}'",
  	  path      => ['/usr/local/bin', '/usr/bin'],
  	  logoutput => true,
  	  user      => 'magento',
  	  require   => File['magento-dist'],
  	}
  	exec { extract-magento:
      creates     => '/home/magento/sites/berbatik',
  	  command     => '/home/magento/scripts/extract-magento.sh /home/magento/sites/berbatik',
  	  logoutput   => true,
  	  user        => 'magento',
  	  environment => ['HOME=/home/magento'],
  	  require     => [ Exec['download-magento'], File['/home/magento/scripts/extract-magento.sh'] ],
  	}

    exec { install-magento:
      cwd => $root,
      creates => "${root}/app/etc/local.xml",
  	  path      => ['/usr/local/bin', '/usr/bin'],
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
      require => [ Exec['extract-magento'] ],
      #require => [Exec["setting-permissions"], Exec["create-magentodb-db"]],
    }

    file { '/home/magento/sites/berbatik/app/etc/local.xml':
      ensure  => file,
      owner   => magento,
      group   => magento,
      mode    => 0400,
      require => Exec['install-magento'],
    }

}

# Refresh execs
define magento(
  $dir  = '/home/magento/sites/berbatik',
  $user = 'magento'
) {

  exec { "magento cache-clear ${dir}":
    cwd         => $dir,
    command     => "wiz cache-clear",
    path        => ['/usr/local/bin', '/usr/bin', '/bin'], # requires readlink, which is in /bin
    user        => $user,
    logoutput   => true,
    refreshonly => true,
    require     => Class['magento::wiz'],
  }

  exec { "magento compiler-compile ${dir}":
    cwd         => $dir,
    command     => "php shell/compiler.php compile",
    path        => ['/usr/local/bin', '/usr/bin', '/bin'],
    user        => $user,
    logoutput   => true,
    refreshonly => true,
  }

}
