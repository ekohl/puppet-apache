class apache::params {
	$pkg = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'apache2',
		/(?i)(RedHat|CentOS)/ => 'httpd'
	}

	$root = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/var/www',
		/(?i)(RedHat|CentOS)/ => '/var/www/vhosts'
	}

	$user = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'www-data',
		/(?i)(RedHat|CentOS)/ => 'apache'
		
	}

	$conf = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/etc/apache2',
		/(?i)(RedHat|CentOS)/ => '/etc/httpd'
	}

	$cgi = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/usr/lib/cgi-bin',
		/(?i)(RedHat|CentOS)/ => '/var/www/cgi-bin'
	}

	$log = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => '/var/log/apache2',
		/(?i)(RedHat|CentOS)/ => '/var/log/httpd'
	}
}
