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
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
	}

	file { $apache::params::cgidir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
	}

	file { $apache::params::logdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
	}
	
	file { "/etc/logrotate.d/${apache::params::basename}":
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		source  => "puppet:///modules/apache/etc/logrotate.d/${apache::params::basename}",
	}
	
	exec { 'apache-graceful':
		command     => "${apache::params::apachectl} graceful",
		onlyif      => "${apache::params::apachectl} configtest",
		refreshonly => true,
	}
	
	# Setup node config file for concat module and include first fragment
	concat { "${apache::params::confdir}/ports.conf":
		owner   => 'root',
		group   => 'root',
		require => Class['apache::install'],
		notify  => Class['apache::service'],
	}
	
	concat::fragment { 'apache-ports.conf-base':
		target  => "${apache::params::confdir}/ports.conf",
		order   => 10,
		content => '#file managed by puppet\n',
	}

	apache::listen { '80':
		ensure => present,
	}
	
	apache::namevhost { '*:80':
		ensure => present,
	}

	$status_mod_config_file = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => "${apache::params::confdir}/mods-available/status.conf",
		/(?i)(RedHat|CentOS)/ => "${apache::params::confdir}/conf.d/status.conf",
	}
	
	$status_mod_config_source = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'puppet:///modules/apache/etc/apache2/mods-available/status.conf',
		/(?i)(RedHat|CentOS)/ => 'puppet:///modules/apache/etc/httpd/conf/status.conf',
	}
	
	file { $status_mod_config_file:
		ensure  => present,
		owner   => root,
		group   => root,
		source  => $status_mod_config_source,
		notify  => Exec['apache-graceful'],
		require => Class['apache::module::status'],
	}

	$default_vhost_file = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => "${apache::params::confdir}/sites-available/default",
		/(?i)(RedHat|CentOS)/ => "${apache::params::confdir}/sites-available/default",
	}
	
	file { $default_vhost_file:
		ensure  => present,
		content => template("apache/default-vhost.${apache::params::os_suffix}"),
		mode    => '0644',
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful']
	}

	file { '/usr/local/bin/htgroup':
		ensure => present,
		owner  => 'root',
		group  => 'root',
		mode   => '0755',
		source => 'puppet:///modules/apache/usr/local/bin/htgroup'
	}
	
	include "apache::config::${apache::params::os_suffix}"
}
