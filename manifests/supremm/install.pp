# Private class
class xdmod::supremm::install {

  package { 'supremm':
    ensure  => $xdmod::package_ensure,
    name    => $xdmod::supremm_package_name,
    require => $xdmod::_package_require,
  }

}