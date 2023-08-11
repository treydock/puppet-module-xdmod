# @summary Manage XDMoD Apache configs
# @api private
class xdmod::apache {
  if $xdmod::manage_apache_vhost {
    include apache
    include apache::mod::php
    include apache::mod::ssl
    include apache::mod::alias
    include apache::mod::headers

    ensure_resource('apache::listen', 80)
    ensure_resource('apache::listen', 443)

    apache::vhost::custom { 'xdmod':
      content => template('xdmod/xdmod_apache.erb'),
    }
  }
}
