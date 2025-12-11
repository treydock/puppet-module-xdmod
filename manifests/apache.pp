# @summary Manage XDMoD Apache configs
# @api private
class xdmod::apache () inherits xdmod::params {
  if $xdmod::manage_apache_vhost {
    include apache
    include apache::mod::php
    if $xdmod::params::ssl {
      include apache::mod::ssl
      ensure_resource('apache::listen', 443)
    }
    include apache::mod::alias
    include apache::mod::headers

    ensure_resource('apache::listen', 80)

    apache::vhost::custom { 'xdmod':
      content => template('xdmod/xdmod_apache.erb'),
    }
  }
}
