# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $version            = '5.0.0'
  $domain_split       = split($::domain, '[.]')
  $resource_name      = $domain_split[0]
  $apache_vhost_name  = "xdmod.${::domain}"
  $portal_settings    = hiera('xdmod_portal_settings', {})
  $hierarchies        = hiera('xdmod_hierarchies', [])
  $group_to_hierarchy = hiera('xdmod_group_to_hierarchy', {})
  $user_pi_names      = hiera('xdmod_user_pi_names', [])
  $akrr_restapi_rw_password = fqdn_rand_string(16, undef, 'rw')
  $akrr_restapi_ro_password = fqdn_rand_string(16, undef, 'ro')
  $akrr_version             = '1.0.0'
  $akrr_source_url          = 'http://downloads.sourceforge.net/project/xdmod/xdmod/VERSION/akrr-AKRR_VERSION.tar.gz'

  case $::osfamily {
    'RedHat': {
      $package_name             = 'xdmod'
      $package_url              = 'http://downloads.sourceforge.net/project/xdmod/xdmod/VERSION/xdmod-VERSION-1.0.el6.noarch.rpm'
      $appkernels_package_name  = 'xdmod-appkernels'
      $appkernels_package_url   = 'http://downloads.sourceforge.net/project/xdmod/xdmod/VERSION/xdmod-appkernels-VERSION-1.0.el6.noarch.rpm'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
