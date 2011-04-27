# 
# == Definition: apache::proxypass
# 
# Simple way of defining a proxypass directive for a given virtualhost.
# 
# This definition will ensure all the required modules are loaded and will
# drop a configuration snippet in the virtualhost's conf/ directory.
# 
# Parameters:
# - *ensure*: present/absent.
# - *location*: path in virtualhost's context to pass through using the ProxyPass
#   directive.
# - *url*: destination to which the ProxyPass directive points to.
# - *params*: a table of key=value (min, max, timeout, retry, etc.) described
# 	in the ProxyPass Directive documentation http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass
# - *vhost*: the virtualhost to which this directive will apply. Mandatory.
# - *filename*: basename of the file in which the directive(s) will be put.
#   Useful in the case directive order matters: apache reads the files in conf/
#   in alphabetical order.
# 
# Requires:
# - Class["apache"]
# - matching Apache::Vhost[] instance
# 
# Example usage:
# 
#   apache::proxypass { "proxy legacy dir to legacy server":
#     ensure   => present,
#     location => "/legacy/",
#     url      => "http://legacyserver.example.com",
# 		params   => ["retry=5", "ttl=120"],
#     vhost    => "www.example.com",
#   }
# 
define apache::proxypass ($vhost,
													$ensure   = present,
													$location = '',
													$url      = '',
													$params   = [],
													$filename = '') {
	include apache::params
	include apache::module::proxy
	include apache::module::proxy_http

	$fname = $filename ? {
		''      => regsubst("${apache::params::rootdir}/${vhost}/conf/proxypass-${fname}.conf", '\s', '_', 'G'),
		default => "${apache::params::rootdir}/${vhost}/conf/${filename}",
	}

	file { $fname:
		ensure  => $ensure,
		content => template('apache/proxypass.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
		require => Apache::Vhost[$vhost],
	}
}
