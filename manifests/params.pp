# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $package_ensure = 'present'

  case $::osfamily {
    'RedHat': {
      $package_name = 'xdmod'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
