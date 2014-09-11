# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $package_ensure     = 'present'
  $database_host      = 'localhost'
  $database_port      = '3306'
  $database_user      = 'xdmod'
  $database_password  = 'changeme'

  case $::osfamily {
    'RedHat': {
      $package_name = 'xdmod'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
