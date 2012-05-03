# Git clones wiz from
# git://github.com/bippo/wiz.git
# Puts it in /usr/share/wiz
# And creates a symlink in /usr/bin/wiz
class magento::wiz {

	exec { clone-wiz:
		creates   => '/usr/share/wiz',
		cwd       => '/usr/share',
		command   => 'git clone git://github.com/bippo/wiz.git',
		path      => ['/usr/local/bin', '/usr/bin'],
		logoutput => true,
		require   => Package['git'],
	}
	file { '/usr/bin/wiz':
		ensure => '/usr/share/wiz/wiz',
	}
	file { '/etc/bash_completion.d/wiz':
		ensure => '/usr/share/wiz/wiz.bash_completion.sh',
	}

}
