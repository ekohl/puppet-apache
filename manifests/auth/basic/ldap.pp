define apache::auth::basic::ldap ($ensure=present,  $authname="Private Area", $vhost, $location="/",
								  $authLDAPUrl, $authLDAPBindDN=false, $authLDAPBindPassword=false, $authLDAPCharsetConfig=false, $authLDAPCompareDNOnServer=false,
								  $authLDAPDereferenceAliases=false, $authLDAPGroupAttribute=false, $authLDAPGroupAttributeIsDN=false, $authLDAPRemoteUserAttribute=false,
								  $authLDAPRemoteUserIsDN=false, $authzLDAPAuthoritative=false, $authzRequire="valid-user") {
	include apache::params

	$fname = regsubst($name, "\s", "_", "G")

	if !defined(Apache::Module["ldap"]) {
		apache::module {"ldap": }
	}

	if !defined(Apache::Module["authnz_ldap"]) {
		apache::module {"authnz_ldap": }
	}

	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-ldap-${fname}.conf":
		ensure  => $ensure,
		content => template("apache/auth/basic/ldap.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify => Exec["apache-graceful"]
	}
}
