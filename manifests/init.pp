import "classes/*.pp"
import "definitions/*.pp"

/*

== Class: apache

Installs apache, ensures a few useful modules are installed (see apache::base),
ensures that the service is running and the logs get rotated.

By including subclasses where distro specific stuff is handled, it ensure that
the apache class behaves the same way on diffrent distributions.

Example usage:

  include apache

*/
class apache {
  case $operatingsystem {
    Debian,Ubuntu:  { include apache::debian}
    RedHat,CentOS:  { include apache::redhat}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}

/*

== Class: apache::ssl

This class basically does the same thing the "apache" class does + enable
mod_ssl.

Class variables:

Example usage:

  include apache::ssl

*/
class apache::ssl inherits apache {
  case $operatingsystem {
    Debian,Ubuntu:  { include apache::ssl::debian}
    RedHat,CentOS:  { include apache::ssl::redhat}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}

class apache::webdav::ssl inherits apache::ssl {
  case $operatingsystem {
    Debian,Ubuntu:  { include apache::webdav::ssl::debian}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
