# Class: apache::module::dav_svn
#
#
class apache::module::dav_svn ($ensure=present) {
	package { "libapache2-svn":
		ensure => $ensure
	}
	
	apache::module { "dav_svn":
		ensure  => $ensure,
		require => Package["libapache2-svn"]
	}
}
