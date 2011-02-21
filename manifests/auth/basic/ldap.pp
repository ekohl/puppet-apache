define apache::auth::basic::ldap ($ensure=present,  $authname="Private Area", $vhost, $location="/",
								  $authLDAPUrl, $authLDAPBindDN=false, $authLDAPBindPassword=false, $authLDAPCharsetConfig=false, $authLDAPCompareDNOnServer=false,
								  $authLDAPDereferenceAliases=false, $authLDAPGroupAttribute=false, $authLDAPGroupAttributeIsDN=false, $authLDAPRemoteUserAttribute=false,
								  $authLDAPRemoteUserIsDN=false, $authzLDAPAuthoritative=false, $authzRequire="valid-user") {
	include apache::params
	include apache::module::authnz_ldap
	include apache::module::ldap
	
	$fname = regsubst($name, "\s", "_", "G")

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
