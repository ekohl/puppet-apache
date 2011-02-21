class apache::svnserver inherits apache::ssl {
	include apache::module::dav
	include apache::module::dav_svn
}
