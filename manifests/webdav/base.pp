class apache::webdav::base {
	include apache::module::dav
	include apache::module::dav_fs
	include apache::module::encoding
	include apache::module::headers
}
