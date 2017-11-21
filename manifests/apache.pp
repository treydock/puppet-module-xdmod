# Private class
class xdmod::apache {

  if $xdmod::manage_apache_vhost {
    include ::apache
    include ::apache::mod::php
    include ::apache::mod::ssl
    include ::apache::mod::alias

    ensure_resource('apache::listen', 80)
    ensure_resource('apache::listen', 443)

    ::apache::vhost::custom { 'xdmod':
      content => template('xdmod/xdmod_apache.erb'),
    }
  }

}
