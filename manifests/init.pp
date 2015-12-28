# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $version                  = $xdmod::params::version,

  # Roles
  $database                 = true,
  $web                      = true,
  $akrr                     = false,
  $supremm                  = false,
  $supremm_database         = false,
  $compute                  = false,

  $enable_appkernel         = false,
  $enable_supremm           = false,
  $resource_name            = $xdmod::params::resource_name,
  $create_local_repo        = true,
  $local_repo_name          = 'xdmod-local',
  $package_ensure           = 'present',
  $package_name             = $xdmod::params::package_name,
  $package_url              = $xdmod::params::package_url,
  $appkernels_package_name  = $xdmod::params::appkernels_package_name,
  $appkernels_package_url   = $xdmod::params::appkernels_package_url,
  $xdmod_supremm_package_name = $xdmod::params::xdmod_supremm_package_name,
  $xdmod_supremm_package_url  = $xdmod::params::xdmod_supremm_package_url,
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

  # SUPReMM install
  $supremm_version              = $xdmod::params::supremm_version,
  $supremm_package_url          = $xdmod::params::supremm_package_url,

  # SUPReMM config
  $supremm_mongodb_password = 'changeme',
  $supremm_mongodb_host     = 'localhost',
  $resource_short_name      = undef,
  $resource_long_name       = undef,
  $resource_id              = '1',
  $job_scripts_dir          = undef,

  # SUPReMM compute
  $use_pcp                      = true,
  $pcp_declare_method           = 'resource',
  $pcp_log_base_dir             = undef,
  $pcp_log_dir                  = undef,
  $pcp_pmlogger_config_template = 'xdmod/supremm/compute/pcp/pmlogger-supremm.config.erb',
  $pcp_pmlogger_config_source   = undef,
  $pcp_logging_static_freq      = '1 hour',
  $pcp_logging_standard_freq    = '30 sec',
  $pcp_static_metrics           = $xdmod::params::supremm_pcp_static_metrics,
  $pcp_standard_metrics         = $xdmod::params::supremm_pcp_standard_metrics,
  $pcp_environ_metrics          = $xdmod::params::supremm_pcp_environ_metrics,
  $pcp_install_pmie_config      = true,
  $pcp_pmie_config_template     = 'xdmod/supremm/compute/pcp/pmie-supremm.config.erb',
  $pcp_pmie_config_source       = undef,
) inherits xdmod::params {

  validate_bool(
    $database,
    $web,
    $akrr,
    $supremm,
    $supremm_database,
    $enable_appkernel,
    $enable_supremm,
    $create_local_repo,
    $enable_update_check,
    $apache_ssl,
    $manage_apache_vhost,
    $use_pcp,
    $pcp_install_pmie_config
  )

  validate_array(
    $pcp_static_metrics,
    $pcp_standard_metrics,
    $pcp_environ_metrics
  )

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

  if $compute or $supremm {
    if $use_pcp {
      if ! $pcp_log_base_dir {
        fail("Module ${module_name}: pcp_log_base_dir must be defined.")
      }
    }
  }

  $shredder_command_real = pick($shredder_command, $scheduler_shredder_command)

  $_package_url = regsubst($package_url, 'VERSION', $version, 'G')
  $_appkernels_package_url = regsubst($appkernels_package_url, 'VERSION', $version, 'G')
  $_xdmod_supremm_package_url = regsubst($xdmod_supremm_package_url, 'VERSION', $version, 'G')

  $_akrr_source_url = regsubst($akrr_source_url, 'AKRR_VERSION', $akrr_version, 'G')

  $_akrr_user_home = pick($akrr_user_home, "/home/${akrr_user}")
  $_akrr_home = pick($akrr_home, "${xdmod::_akrr_user_home}/akrr-${xdmod::akrr_version}")

  $_supremm_package_url = regsubst($supremm_package_url, 'SUPREMM_VERSION', $supremm_version, 'G')

  if $create_local_repo {
    $_package_require = [Yumrepo[$xdmod::local_repo_name], Yumrepo['epel']]
  } else  {
    if defined(Yumrepo[$xdmod::local_repo_name]) {
      $_package_require = [Yumrepo[$xdmod::local_repo_name], Yumrepo['epel']]
    } else {
      $_package_require = Yumrepo['epel']
    }
  }

  $_resource_short_name = pick($resource_short_name, $resource_name)
  $_resource_long_name  = pick($resource_long_name, capitalize($resource_name))
  $_mysql_remote_args = "-h ${database_host} -u ${database_user} -p${database_password}"

  anchor { 'xdmod::start': }
  anchor { 'xdmod::end': }

  if $database and $web {
    include xdmod::repo
    include xdmod::install
    include xdmod::database
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::repo']->
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
    include xdmod::repo
    include xdmod::install
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::repo']->
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

  if $supremm_database {
    include xdmod::supremm::database
  }

  if $supremm {
    include mysql::client
    include mongodb::client
    include xdmod::repo
    include xdmod::supremm::install
    include xdmod::supremm::config

    Anchor['xdmod::start']->
    Class['xdmod::repo']->
    Class['xdmod::supremm::install']->
    Class['xdmod::supremm::config']->
    Anchor['xdmod::end']

    if $web {
      $_supremm_mysql_access = 'include'
      Class['xdmod::supremm::config']->Class['xdmod::config']
    } else {
      $_supremm_mysql_access = 'defaultsfile'
    }

    if $database {
      Class['xdmod::database']->Class['xdmod::supremm::config']
    }

    if $supremm_database {
      Class['xdmod::supremm::database']->Class['xdmod::supremm::install']
    }
  }

  if $compute {
    if $use_pcp {
      $_pcp_log_dir = pick($pcp_log_dir, "${pcp_log_base_dir}/${::hostname}")

      validate_re($pcp_declare_method, ['^include$', '^resource$'], 'pcp_declare_method only supports include and resource')

      include xdmod::supremm::compute::pcp

      Anchor['xdmod::start']->
      Class['xdmod::supremm::compute::pcp']->
      Anchor['xdmod::end']
    }
  }

}
