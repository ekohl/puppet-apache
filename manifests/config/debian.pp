# Class: apache::config::debian
#
#
class apache::config::debian {
	# directory not present in lenny
	file { "${apache::params::rootdir}/apache2-default":
		ensure => absent,
		force  => true,
	}

	file { "${apache::params::rootdir}/index.html":
		ensure => absent,
	}

 	file { "${apache::params::rootdir}/html":
		ensure  => directory,
	}

	file { "${apache::params::rootdir}/html/index.html":
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => "<html><body><h1>It works!</h1></body></html>\n",
	}

	file { "${apache::params::confdir}/conf.d/servername.conf":
		content => "ServerName ${fqdn}\n",
		notify  => Class['apache::service'],
	}

	file { "${apache::params::confdir}/sites-available/default-ssl":
		ensure => absent,
		force  => true,
	}
}
