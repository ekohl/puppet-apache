define apache::env ($vhost,
										$envhash,
										$ensure = present) {
  include apache::params

	$fname = regsubst($name, '\s', '_', 'G')

  file { "${apache::params::root}/${vhost}/conf/env-${fname}.conf":
		ensure  => $ensure,
		content => template('apache/env.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
  }
}
