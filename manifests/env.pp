define apache::env ($ensure = present, $vhost, $envhash) {
  include apache::params

  file { "${apache::params::root}/${vhost}/conf/env-${fname}.conf":
		ensure => $ensure,
		content => template('apache/env.erb'),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => 'httpd_config_t',
			default               => undef,
		},
		notify => Exec['apache-graceful']
  }
}
