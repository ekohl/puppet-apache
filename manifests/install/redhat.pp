# Class: apache::install::redhat
#
#
class apache::install::redhat {
	file { [ '/usr/local/sbin/a2ensite', '/usr/local/sbin/a2dissite', '/usr/local/sbin/a2enmod', '/usr/local/sbin/a2dismod' ]:
		ensure => present,
		owner  => 'root',
		group  => 'root',
		mode   => '0755',
		source => 'puppet:///modules/apache/usr/local/sbin/a2X.redhat'
	}
}
