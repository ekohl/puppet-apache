class apache::params {
	# TODO: refactor this var to a common module and make other module use it
	$os_suffix = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'debian',
		/(?i)(RedHat|CentOS)/ => 'redhat',
	}
	
	$basename = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'apache2',
		/(?i)(RedHat|CentOS)/ => 'httpd',
	}
	
	$pkgname     = $basename
	$servicename = $basename

	$rootdir = $apache_rootdir ? {
		'' => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => '/var/www',
			/(?i)(RedHat|CentOS)/ => '/var/www/vhosts',
		},
		default => $apache_rootdir,
	}

	$user = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'www-data',
		/(?i)(RedHat|CentOS)/ => 'apache',
	}
	
	$user_shell = $apache_user_shell ? {
		''      => '/bin/sh',
		default => $apache_user_shell,
	}
	
	$group = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'www-data',
		/(?i)(RedHat|CentOS)/ => 'apache',
	}

	$confdir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/etc/apache2',
		/(?i)(RedHat|CentOS)/ => '/etc/httpd',
	}

	$cgidir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/usr/lib/cgi-bin',
		/(?i)(RedHat|CentOS)/ => '/var/www/cgi-bin',
	}

	$logdir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/var/log/apache2',
		/(?i)(RedHat|CentOS)/ => '/var/log/httpd',
	}
	
	$apachectl = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'apache2ctl',
		/(?i)(RedHat|CentOS)/ => 'apachectl',
	}
	
	$seltype = $operatingsystem ? {
		/(?i)(RedHat|CentOS)/ => 'httpd_config_t',
		default               => undef,
	}
	
	# This is for Debian/Ubuntu only
	$mpm_package = $apache_mpm_type ? {
		''      => 'apache2-mpm-prefork',
		default => "apache2-mpm-${apache_mpm_type}",
	}
	
	$distro_specific_sudo = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/usr/sbin/apache2ctl',
		/(?i)(RedHat|CentOS)/ => '/usr/sbin/apachectl, /sbin/service httpd',
	}
	
	$sudo_admin_user = $apache_sudo_admin_user ? {
		""      => false,
		default => $apache_sudo_admin_user,
	}
	
	$sudo_admin_cmnd = $apache_sudo_admin_cmnd ? {
		""      => "/etc/init.d/${pkgname}, /bin/su ${user}, /bin/su - ${user}, ${distro_specific_sudo}",
		default => $apache_sudo_admin_cmnd,
	}
}
