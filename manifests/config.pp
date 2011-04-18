# Class: apache::config
#
#
class apache::config {
	# Setup concat module
	include concat::setup
	
	# Include default modules
	include apache::module::alias
	include apache::module::auth_basic
	include apache::module::authn_file
	include apache::module::authz_default
	include apache::module::authz_groupfile
	include apache::module::authz_host
	include apache::module::authz_user
	include apache::module::autoindex
	include apache::module::cgi
	include apache::module::dir
	include apache::module::env
	include apache::module::log_config
	include apache::module::mime
	include apache::module::negotiation
	include apache::module::rewrite
	include apache::module::setenvif
	include apache::module::status
	
	File {
		require => Class["apache::install"]
	}
	
	file { $apache::params::rootdir:
		ensure  => directory,
		mode    => 755,
		owner   => root,
		group   => root
	}

	file { $apache::params::cgidir:
		ensure  => directory,
		mode    => 755,
		owner   => root,
		group   => root
	}

	file { $apache::params::logdir:
		ensure  => directory,
		mode    => 755,
		owner   => root,
		group   => root
	}
	
	file { "/etc/logrotate.d/${apache::params::basename}":
		ensure  => present,
		owner   => root,
		group   => root,
		mode    => 644,
		source  => "puppet:///modules/apache/etc/logrotate.d/${basename}"
	}
	
	exec { "apache-graceful":
		command     => "${apache::params::apachectl} graceful",
		refreshonly => true,
		onlyif      => "${apache::params::apachectl} configtest"
	}
	
	# Setup node config file for concat module and include first fragment
	concat { "${apache::params::confdir}/ports.conf":
		owner   => root,
		group   => root,
		require => Class["apache::install"],
		notify  => Class["apache::service"]
	}
	
	concat::fragment { "apache-ports.conf-base":
		target  => "${apache::params::confdir}/ports.conf",
		order   => 10,
		content => "#file managed by puppet\n"
	}

	apache::listen {
		"80": ensure => present
	}
	
	apache::namevhost {
		"*:80": ensure => present
	}

	file { "default status module configuration":
		path    => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "${apache::params::confdir}/mods-available/status.conf",
			/(?i)(RedHat|CentOS)/ => "${apache::params::confdir}/conf.d/status.conf"
		},
		ensure  => present,
		owner   => root,
		group   => root,
		source  => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "puppet:///modules/apache/etc/apache2/mods-available/status.conf",
			/(?i)(RedHat|CentOS)/ => "puppet:///modules/apache/etc/httpd/conf/status.conf"
		},
		notify  => Exec["apache-graceful"],
		require => Class["apache::module::status"]
	}

	file { "default virtualhost":
		path    => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "${apache::params::confdir}/sites-available/default",
			/(?i)(RedHat|CentOS)/ => "${apache::params::confdir}/sites-available/default"
		},
		ensure  => present,
		content => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => template("apache/default-vhost.debian"),
			/(?i)(RedHat|CentOS)/ => template("apache/default-vhost.redhat")
		},
		mode    => 644,
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify  => Exec["apache-graceful"]
	}

	file { "/usr/local/bin/htgroup":
		ensure => present,
		owner  => root,
		group  => root,
		mode   => 755,
		source => "puppet:///modules/apache/usr/local/bin/htgroup"
	}
	
	case $operatingsystem {
		/(?i)(Debian|Ubuntu)/: {
			# directory not present in lenny
			file { "${apache::params::rootdir}/apache2-default":
				ensure => absent,
				force  => true
			}

			file { "${apache::params::rootdir}/index.html":
				ensure => absent
			}

		 	file { "${apache::params::rootdir}/html":
				ensure  => directory
			}

			file { "${apache::params::rootdir}/html/index.html":
				ensure  => present,
				owner   => root,
				group   => root,
				mode    => 644,
				content => "<html><body><h1>It works!</h1></body></html>\n"
			}

			file { "${apache::params::confdir}/conf.d/servername.conf":
				content => "ServerName ${fqdn}\n",
				notify  => Class["apache::service"]
			}

			file { "${apache::params::confdir}/sites-available/default-ssl":
				ensure => absent,
				force  => true
			}
		}
		/(?i)(RedHat|CentOS)/: {
			file { [ "${apache::params::confdir}/sites-available", "${apache::params::confdir}/sites-enabled", "${apache::params::confdir}/mods-enabled" ]:
				ensure  => directory,
				mode    => 644,
				owner   => root,
				group   => root,
				seltype => "httpd_config_t"
			}

			file { "${apache::params::confdir}/conf/httpd.conf":
				ensure  => present,
				content => template("apache/httpd.conf.erb"),
				seltype => "httpd_config_t",
				notify  => Class["apache::service"]
			}

			# the following command was used to generate the content of the directory:
			# egrep '(^|#)LoadModule' /etc/httpd/conf/httpd.conf | sed -r 's|#?(.+ (.+)_module .+)|echo "\1" > mods-available/redhat5/\2.load|' | sh
			# ssl.load was then changed to a template (see apache/module/ssl.pp)
			file { "${apache::params::confdir}/mods-available":
				ensure  => directory,
				source  => $lsbmajdistrelease ? {
					5 => "puppet:///modules/apache//etc/httpd/mods-available/redhat5/",
					6 => "puppet:///modules/apache//etc/httpd/mods-available/redhat5/"
				},
				recurse => true,
				mode    => 644,
				owner   => root,
				group   => root,
				seltype => "httpd_config_t"
			}

			# no idea why redhat choose to put this file there. apache fails if it's
			# present and mod_proxy isn't...
			file { "${apache::params::confdir}/conf.d/proxy_ajp.conf":
				ensure  => absent,
				notify  => Exec["apache-graceful"]
			}
		}
		default: { notice "Unsupported operatingsystem ${operatingsystem}" }
	}
}
