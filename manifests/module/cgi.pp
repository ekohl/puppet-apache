# Class: apache::module::cgi
#
#
class apache::module::cgi ($ensure = present) {
	apache::module { 'cgi':
		ensure => $ensure,
	}
}
