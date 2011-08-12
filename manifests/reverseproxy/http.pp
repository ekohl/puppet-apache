define apache::reverseproxy::http ($vhost,
																	 $ensure = present,
																	 $location = '/',
																	 $proxy = 'http://localhost:8080/') {
	include apache::params
	include apache::module::proxy
	include apache::module::proxy_http
	
	$fname = regsubst($name, '\s', '_', 'G')

	file { "${apache::params::root}/${vhost}/conf/reverseproxy-http-${fname}.conf":
		ensure  => $ensure,
		content => template('apache/reverseproxy/http.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
		require => [ Class['apache::module::proxy'], Class['apache::module::proxy_http'] ],
  }
}