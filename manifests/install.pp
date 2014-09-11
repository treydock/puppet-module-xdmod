# == Class: xdmod::install
#
# Private class.
#
class xdmod::install {

  case $::osfamily {
    'RedHat': {
      include ::epel
      $package_require = Yumrepo['epel']
    }
    default: {
      # Do nothing
    }
  }

  package { 'xdmod':
    ensure    => $xdmod::package_ensure,
    name      => $xdmod::package_name,
    require   => $package_require,
  }

}
