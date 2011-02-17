class apache::params {
	$pkgname = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'apache2',
		/(?i)(RedHat|CentOS)/ => 'httpd'
	}
	
	$servicename = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'apache2',
		/(?i)(RedHat|CentOS)/ => 'httpd'
	}

	$rootdir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/var/www',
		/(?i)(RedHat|CentOS)/ => '/var/www/vhosts'
	}

	$user = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'www-data',
		/(?i)(RedHat|CentOS)/ => 'apache'
		
	}
	
	$group = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'www-data',
		/(?i)(RedHat|CentOS)/ => 'apache'
		
	}

	$confdir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/etc/apache2',
		/(?i)(RedHat|CentOS)/ => '/etc/httpd'
	}

	$cgidir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/usr/lib/cgi-bin',
		/(?i)(RedHat|CentOS)/ => '/var/www/cgi-bin'
	}

	$logdir = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/var/log/apache2',
		/(?i)(RedHat|CentOS)/ => '/var/log/httpd'
	}
	
	$distro_specific_sudo = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => "/usr/sbin/apache2ctl",
		/(?i)(RedHat|CentOS)/ => "/usr/sbin/apachectl, /sbin/service ${pkgname}"
	}
	
	$sudo_admin_user = $apache_sudo_admin_user ? {
		""      => false,
		default => $apache_sudo_admin_user
	}
	
	$sudo_admin_cmnd = $apache_sudo_admin_cmnd ? {
		""      => "/etc/init.d/${pkgname}, /bin/su ${user}, /bin/su - ${user}, ${distro_specific_sudo %>"
		default => $apache_sudo_admin_cmnd
	}
}
