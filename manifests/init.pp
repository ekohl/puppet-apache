# 
# == Class: apache
# 
# Installs apache, ensures a few useful modules are installed (see apache::base),
# ensures that the service is running and the logs get rotated.
# 
# By including subclasses where distro specific stuff is handled, it ensure that
# the apache class behaves the same way on diffrent distributions.
# 
# Example usage:
# 
#   include apache
# 
class apache {
	require apache::params
	
	include apache::install, apache::config, apache::service
}
