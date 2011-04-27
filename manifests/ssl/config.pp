# Class: apache::ssl::config
#
#
class apache::ssl::config {
	include apache::module::ssl
	
	apache::listen { '443':
		ensure => present,
	}
	
	apache::namevhost { '*:443':
		ensure => present,
	}

	file { '/usr/local/sbin/generate-ssl-cert.sh':
		source => 'puppet:///modules/apache/generate-ssl-cert.sh',
		mode   => '0755',
	}
}
