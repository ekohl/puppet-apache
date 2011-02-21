# Class: apache::module::encoding
#
#
class apache::module::encoding ($ensure=present) {
	package {"libapache2-mod-encoding":
		ensure => $ensure
	}
	
	apache::module { "encoding":
		ensure  => $ensure,
		require => Package["libapache2-mod-encoding"]
	}
}
