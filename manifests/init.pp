# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $version                  = $xdmod::params::version,
  $database                 = true,
  $web                      = true,
  $akrr                     = false,
  $enable_appkernel         = false,
  $resource_name            = $xdmod::params::resource_name,
  $create_local_repo        = true,
  $local_repo_name          = 'xdmod-local',
  $package_ensure           = 'present',
  $package_name             = $xdmod::params::package_name,
  $package_url              = $xdmod::params::package_url,
  $appkernels_package_name  = $xdmod::params::appkernels_package_name,
  $appkernels_package_url   = $xdmod::params::appkernels_package_url,
  $database_host            = 'localhost',
  $database_port            = '3306',
  $database_user            = 'xdmod',
  $database_password        = 'changeme',
  $akrr_database_user       = 'akrr',
  $akrr_database_password   = 'changeme',
  $web_host                 = 'localhost',
  $scheduler                = 'slurm',
  $shredder_command         = undef,
  $enable_update_check      = true,
  $manage_apache_vhost      = true,
  $apache_vhost_name        = $xdmod::params::apache_vhost_name,
  $apache_port              = '80',
  $apache_ssl               = true,
  $apache_ssl_port          = '443',
  $apache_ssl_cert          = undef,
  $apache_ssl_key           = undef,
  $apache_ssl_chain         = undef,
  $portal_settings          = $xdmod::params::portal_settings,
  $hierarchies              = $xdmod::params::hierarchies,
  $group_to_hierarchy       = $xdmod::params::group_to_hierarchy,
  $user_pi_names            = $xdmod::params::user_pi_names,

  # AKRR Install
  $akrr_source_url          = $xdmod::params::akrr_source_url,
  $akrr_version             = $xdmod::params::akrr_version,
  $akrr_home                = undef,

  # AKRR User
  $manage_akrr_user         = true,
  $akrr_user                = 'akrr',
  $akrr_user_group          = 'akrr',
  $akrr_user_group_gid      = undef,
  $akrr_user_uid            = undef,
  $akrr_user_shell          = '/bin/bash',
  $akrr_user_home           = undef,
  $akrr_user_managehome     = true,
  $akrr_user_comment        = 'AKRR',
  $akrr_user_system         = true,

  # AKRR config
  $akrr_restapi_port        = '8091',
  $akrr_restapi_rw_password = $xdmod::params::akrr_restapi_rw_password,
  $akrr_restapi_ro_password = $xdmod::params::akrr_restapi_ro_password,
  $akrr_cron_mailto         = undef,
) inherits xdmod::params {

  validate_bool($database, $web, $akrr, $enable_appkernel, $create_local_repo, $enable_update_check, $apache_ssl, $manage_apache_vhost)

  validate_re($scheduler, ['^slurm$'])

  validate_hash($portal_settings, $group_to_hierarchy)

  validate_array($hierarchies, $user_pi_names)

  case $scheduler {
    'slurm': {
      $scheduler_shredder_command = "/usr/bin/xdmod-slurm-helper --quiet -r ${resource_name}"
    }
    'pbs': {
      $scheduler_shredder_command = "/usr/bin/xdmod-shredder --quiet -r ${resource_name} -f pbs -d /var/spool/pbs/server_priv/accounting"
    }
    'sge': {
      $scheduler_shredder_command = "/usr/bin/xdmod-shredder --quiet -r ${resource_name} -f sge -i /var/lib/gridengine/default/common/accounting"
    }
    default: {
      fail("Module ${module_name}: Supported scheduler value is either slurm, pbs or sge.")
    }
  }

  $shredder_command_real = pick($shredder_command, $scheduler_shredder_command)

  $_package_url = regsubst($package_url, 'VERSION', $version, 'G')
  $_appkernels_package_url = regsubst($appkernels_package_url, 'VERSION', $version, 'G')

  $__akrr_source_url = regsubst($akrr_source_url, 'AKRR_VERSION', $akrr_version)
  $_akrr_source_url = regsubst($__akrr_source_url, 'VERSION', $version)

  $_akrr_user_home = pick($akrr_user_home, "/home/${akrr_user}")
  $_akrr_home = pick($akrr_home, "${xdmod::_akrr_user_home}/akrr-${xdmod::akrr_version}")

  anchor { 'xdmod::start': }
  anchor { 'xdmod::end': }

  if $database and $web {
    include xdmod::install
    include xdmod::database
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::database']->
    Class['xdmod::config']->
    Class['xdmod::apache']->
    Anchor['xdmod::end']
  } elsif $database {
    include xdmod::database

    Anchor['xdmod::start']->
    Class['xdmod::database']->
    Anchor['xdmod::end']
  } elsif $web {
    include xdmod::install
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::config']->
    Class['xdmod::apache']->
    Anchor['xdmod::end']
  }

  if $akrr {
    anchor { 'xdmod::akrr::start': }
    anchor { 'xdmod::akrr::end': }

    include mysql::bindings
    include mysql::bindings::python
    include xdmod::akrr::user
    include xdmod::akrr::install
    include xdmod::akrr::config
    include xdmod::akrr::service

    Anchor['xdmod::akrr::start']->
    Class['mysql::bindings::python']->
    Class['xdmod::akrr::user']->
    Class['xdmod::akrr::install']->
    Class['xdmod::akrr::config']->
    Class['xdmod::akrr::service']->
    Anchor['xdmod::akrr::end']

    if $database {
      Class['xdmod::database']->Anchor['xdmod::akrr::start']
    }
  }

}
