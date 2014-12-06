# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $domain_split       = split($::domain, '[.]')
  $resource_name      = $domain_split[0]
  $apache_vhost_name  = "xdmod.${::domain}"
  $portal_settings    = hiera('xdmod_portal_settings', {})
  $hierarchies        = hiera('xdmod_hierarchies', [])
  $group_to_hierarchy = hiera('xdmod_group_to_hierarchy', {})

  case $::osfamily {
    'RedHat': {
      $package_name = 'xdmod'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
