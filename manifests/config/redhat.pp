# Class: apache::config::redhat
#
#
class apache::config::redhat {
	file { [ "${apache::params::confdir}/sites-available", "${apache::params::confdir}/sites-enabled", "${apache::params::confdir}/mods-enabled" ]:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		seltype => $apache::params::seltype,
	}

	file { "${apache::params::confdir}/conf/httpd.conf":
		ensure  => present,
		content => template('apache/httpd.conf.erb'),
		seltype => $apache::params::seltype,
		notify  => Class['apache::service'],
	}

	# the following command was used to generate the content of the directory:
	# egrep '(^|#)LoadModule' /etc/httpd/conf/httpd.conf | sed -r 's|#?(.+ (.+)_module .+)|echo "\1" > mods-available/redhat5/\2.load|' | sh
	# ssl.load was then changed to a template (see apache/module/ssl.pp)
	file { "${apache::params::confdir}/mods-available":
		ensure  => directory,
		source  => "puppet:///modules/apache//etc/httpd/mods-available/redhat${lsbmajdistrelease}/",
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		recurse => true,
		seltype => $apache::params::seltype,
	}

	# no idea why redhat choose to put this file there. apache fails if it's
	# present and mod_proxy isn't...
	file { "${apache::params::confdir}/conf.d/proxy_ajp.conf":
		ensure  => absent,
		notify  => Exec['apache-graceful'],
	}
}
