# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $shredder_commands  = {
    'slurm' => '/usr/bin/xdmod-slurm-helper --quiet',
  }

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
