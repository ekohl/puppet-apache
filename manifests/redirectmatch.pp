# 
# == Definition: apache::redirectmatch
# 
# Convenient way to declare a RedirectMatch directive in a virtualhost context.
# 
# Parameters:
# - *ensure*: present/absent.
# - *regex*: regular expression matching the part of the URL which should get
#   redirected. Mandatory.
# - *url*: destination URL the redirection should point to. Mandatory.
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
#   apache::redirectmatch { "example":
#     regex => "^/(foo|bar)",
#     url   => "http://foobar.example.com/",
#     vhost => "www.example.com",
#   }
# 
define apache::redirectmatch ($vhost,
															$regex,
															$url,
															$ensure   = present,
															$filename = '') {
	include apache::params

	$fname = $filename ? {
		''      => regsubst("${apache::params::rootdir}/${vhost}/conf/redirect-${fname}.conf", '\s', '_', 'G'),
		default => "${apache::params::rootdir}/${vhost}/conf/${filename}",
	}

	file { $fname:
		ensure  => $ensure,
		content => template('apache/redirectmatch.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
		require => Apache::Vhost[$vhost],
	}
}
