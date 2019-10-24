# @summary Manage XDMoD
#
# @param version
#   Version of XDMoD to install
# @param xdmod_appkernels_version
#   Version of XDMoD AppKernels to install
# @param xdmod_supremm_version
#   Version of XDMoD SUPReMM to install
# @param database
#   Sets database role
# @param web
#   Sets web role
# @param akrr
#   Sets akrr role
# @param supremm
#   Sets supremm role
# @param supremm_database
#   Sets supremm database role
# @param compute
#   Sets compute role
# @param enable_appkernel
#   Enable XDMoD AppKernel support
# @param enable_supremm
#   Enable XDMod SUPReMM support
# @param local_repo_name
#   Name of yum repo hosting RPMs
# @param manage_epel
#   Boolean that sets if EPEL should be managed
# @param package_ensure
#   XDMoD package ensure property
# @param xdmod_supremm_package_ensure
#   XDMoD supremm package ensure property
# @param xdmod_appkernels_package_ensure
#   XDMoD appkernels package ensure property
# @param package_name
#   XDMoD package name
# @param package_url
#   XDMoD package RPM URL, not used if `local_repo_name` is defined
# @param appkernels_package_name
#   XDMoD appkernels package name
# @param appkernels_package_url
#   XDMoD appkernels package RPM URL, not used if `local_repo_name` is defined
# @param xdmod_supremm_package_name
#   XDMoD supremm package name
# @param xdmod_supremm_package_url
#   XDMoD supremm package RPM URL, not used if `local_repo_name` is defined
# @param database_host
#   XDMoD database host
# @param database_port
#   XDMoD database port
# @param database_user
#   XDMoD database user
# @param database_password
#   XDMoD database password
# @param akrr_database_user
#   AKRR database user
# @param akrr_database_password
#   AKRR database password
# @param web_host
#   FQDN of web host
# @param akrr_host
#   FQDN of AKRR host
# @param scheduler
#   Scheduler to shred, used to define default shred commands and PI column
# @param shredder_command
#   Shred command(s)
# @param shred_hour_start
#   The numeric hour to start shredding
# @param shred_minutes
#   Time in minutes between shred operations if multiple shred commands
# @param ingest_hour
#   The numeric hour to start ingest
# @param enable_update_check
#   Enable XDMoD update check
# @param manage_apache_vhost
#   Manage the XMDoD Apache Virtual Host
# @param apache_vhost_name
#   The Apache Virtual Host name
# @param apache_ssl_cert
#   Path to SSL cert used by Apache
# @param apache_ssl_key
#   Path to SSL private key used by Apache
# @param apache_ssl_chain
#   Path to SSL chain used by Apache
# @param portal_settings
#   Hash of portal_settings.ini settings to pass to `xdmod_portal_setting` resources
# @param hierarchy_levels
#   Hierarchy levels used when defining hierarchies
# @param hierarchies
#   Hierarchy lines, see XDMoD docs
# @param group_to_hierarchy
#   Group to Hierarchy mappings, see XDMoD docs
# @param user_pi_names
#   User and PI names, see XDMoD docs
# @param organization_name
#   Organization name for XDMoD instance
# @param organization_abbrev
#   Organization abbreviation for XDMoD instance
# @param resources
#   Resources to define resources.json
# @param resource_specs
#   Resource specs for resource_specs.json
# @param sender_email
#   Configure sender for EMail
# @param debug_recipient
#   Configure email addres to receive debug information
# @param php_timezone
#   PHP Timezone
# @param center_logo_source
#   Source to image that will be used as center logo in XDMoD
# @param center_logo_width
#   The width of file from `center_logo_source`
# @param user_dashboard
#   The value for `user_dashboard` in portal_settings.ini
# @param manage_user
#   Boolean that sets if managing XMDoD user
# @param user_uid
#   XMDoD user UID
# @param group_gid
#   XDMoD user group GID
# @param manage_simplesamlphp
#   Boolean that sets if managing simplesamlphp
# @param simplesamlphp_config_content
#   The content for simplesamlphp config
# @param simplesamlphp_config_source
#   The source for simplesamlphp config
# @param simplesamlphp_authsources_content
#   The content for simplesaml php authsources
# @param simplesamlphp_authsources_source
#   The source for simplesaml php authsources
# @param simplesamlphp_metadata_content
#   The simplesamlphp metadata content
# @param simplesamlphp_metadata_source
#   The simplesamlphp metadata source
# @param simplesamlphp_cert_country
#   The simplesamlphp cert country
# @param simplesamlphp_cert_organization
#   The simplesamlphp cert organization
# @param simplesamlphp_cert_commonname
#   The simplesamlphp cert commonname
# @param akrr_source_url
#   The AKRR source URL
# @param akrr_version
#   The AKRR version. This version is used to build default `akrr_source_url`.
# @param akrr_home
#   AKRR home path
# @param manage_akrr_user
#   Boolean to manage AKRR user
# @param akrr_user
#   AKRR username
# @param akrr_user_group
#   AKRR user group name
# @param akrr_user_group_gid
#   AKRR user gropu GID
# @param akrr_user_uid
#   AKRR user UID
# @param akrr_user_shell
#   AKRR user shell
# @param akrr_user_home
#   AKRR user home
# @param akrr_user_managehome
#   AKRR user managehome property
# @param akrr_user_comment
#   AKRR user comment
# @param akrr_user_system
#   AKRR user system property
# @param akrr_restapi_port
#   AKRR restapi port
# @param akrr_restapi_rw_password
#   AKRR restapi RW password
# @param akrr_restapi_ro_password
#   AKRR restapi RO password
# @param akrr_cron_mailto
#   AKRR cron MAILTO
# @param akrr_ingestor_cron_times
#   AKRR ingestor cron times
# @param appkernel_reports_manager_cron_times
#   AppKernel report manager cron times
# @param supremm_version
#   Version of SUPReMM to install, builds `supremm_package_url` if not defined
# @param supremm_package_ensure
#   SUPReMM package ensure property
# @param supremm_package_url
#   The URL to download SUPReMM RPM from
# @param supremm_package_name
#   SUPReMM RPM package name
# @param supremm_mongodb_password
#   SUPReMM mongodb password
# @param supremm_mongodb_host
#   SUPReMM mongodb host
# @param supremm_mongodb_uri
#   SUPReMM mongodb URI
# @param supremm_mongodb_replica_set
#   SUPReMM mongodb replica set
# @param supremm_resources
#   SUPReMM resources
# @param supremm_update_cron_times
#   The cron times to run supremm_update
# @param ingest_jobscripts_cron_times
#   The cron times to ingest job scripts
# @param aggregate_supremm_cron_times
#   The cron times to run supremm aggregation
# @param supremm_archive_out_dir
#   The path to supremm archive out
# @param use_pcp
#   Boolean that PCP should be used for compute environment
# @param pcp_declare_method
#   Should pcp class be included or declared like a resource
# @param pcp_resource
#   PCP resource name
# @param pcp_pmlogger_path_suffix
#   PCP pmlogger path suffix
# @param pcp_pmlogger_config_template
#   Template for pmlogger config
# @param pcp_pmlogger_config_source
#   Source for pmlogger config
# @param pcp_logging_static_freq
#   Frequency for PCP logging static metrics
# @param pcp_logging_standard_freq
#   Frequency for PCP logging standard metrics
# @param pcp_static_metrics
#   PCP static metrics
# @param pcp_standard_metrics
#   PCP standard metrics
# @param pcp_environ_metrics
#   PCP environment metrics
# @param pcp_merge_metrics
#   Boolean that PCP metrics should be merged with defaults
# @param pcp_hotproc_exclude_users
#   Users to exclude from PCP hotproc
# @param storage_roles_source
#   The source of storage roles.json
# @param storage_cron_times
#   The cron times for storage shred/ingest
#
class xdmod (
  String $version                  = $xdmod::params::version,
  String $xdmod_appkernels_version = $xdmod::params::xdmod_appkernels_version,
  String $xdmod_supremm_version    = $xdmod::params::xdmod_supremm_version,

  # Roles
  Boolean $database                 = true,
  Boolean $web                      = true,
  Boolean $akrr                     = false,
  Boolean $supremm                  = false,
  Boolean $supremm_database         = false,
  Boolean $compute                  = false,

  Boolean $enable_appkernel                     = false,
  Boolean $enable_supremm                       = false,
  Optional[String] $local_repo_name             = undef,
  Boolean $manage_epel                          = true,
  String $package_ensure                        = 'present',
  String $xdmod_supremm_package_ensure          = 'present',
  String $xdmod_appkernels_package_ensure       = 'present',
  String $package_name                          = $xdmod::params::package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $package_url                                = $xdmod::params::package_url,
  String $appkernels_package_name               = $xdmod::params::appkernels_package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $appkernels_package_url                     = $xdmod::params::appkernels_package_url,
  String $xdmod_supremm_package_name            = $xdmod::params::xdmod_supremm_package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $xdmod_supremm_package_url                  = $xdmod::params::xdmod_supremm_package_url,
  String $database_host                   = 'localhost',
  Integer $database_port                   = 3306,
  String $database_user                         = 'xdmod',
  String $database_password                     = 'changeme',
  String $akrr_database_user                    = 'akrr',
  String $akrr_database_password                = 'changeme',
  String $web_host                        = 'localhost',
  String $akrr_host                       = 'localhost',
  Enum['slurm','torque','pbs','sge'] $scheduler = 'slurm',
  Optional[Variant[String, Array]]
    $shredder_command                           = undef,
  Integer[0,23] $shred_hour_start               = 1,
  Integer $shred_minutes                        = 5,
  Optional[Integer[0,23]] $ingest_hour          = undef,
  Boolean $enable_update_check                  = true,
  Boolean $manage_apache_vhost                  = true,
  String $apache_vhost_name               = $xdmod::params::apache_vhost_name,
  Stdlib::Unixpath $apache_ssl_cert             = '/etc/pki/tls/certs/localhost.crt',
  Stdlib::Unixpath $apache_ssl_key              = '/etc/pki/tls/private/localhost.key',
  Optional[Stdlib::Unixpath] $apache_ssl_chain  = undef,
  Hash $portal_settings                         = $xdmod::params::portal_settings,
  Xdmod::Hierarchy_Levels $hierarchy_levels     = $xdmod::params::hierarchy_levels,
  Array $hierarchies                            = $xdmod::params::hierarchies,
  Hash $group_to_hierarchy                      = $xdmod::params::group_to_hierarchy,
  Array $user_pi_names                          = $xdmod::params::user_pi_names,
  Optional[String] $organization_name           = undef,
  Optional[String] $organization_abbrev         = undef,
  Array[Xdmod::Resource] $resources             = [],
  Array[Xdmod::Resource_Spec] $resource_specs   = [],
  String $sender_email                          = $xdmod::params::sender_email,
  String $debug_recipient                       = '',
  Optional[String] $php_timezone                = undef,
  Optional[String] $center_logo_source          = undef,
  Optional[Integer] $center_logo_width          = undef,
  Enum['on','off'] $user_dashboard              = 'off',

  # XDMoD user/group
  Boolean $manage_user = true,
  Optional[Integer] $user_uid = undef,
  Optional[Integer] $group_gid = undef,

  # Batch export
  Stdlib::Absolutepath $data_warehouse_export_directory = '/var/spool/xdmod/export',
  Integer $data_warehouse_export_retention_duration_days = 30,
  String $data_warehouse_export_hash_salt = sha256($::fqdn),
  Array[Integer, 2 ,2] $batch_export_cron_times = [0,4],

  # simplesamlphp
  Boolean $manage_simplesamlphp = false,
  Optional[String] $simplesamlphp_config_content = undef,
  Optional[String] $simplesamlphp_config_source = undef,
  Optional[String] $simplesamlphp_authsources_content = undef,
  Optional[String] $simplesamlphp_authsources_source = undef,
  Optional[String] $simplesamlphp_metadata_content = undef,
  Optional[String] $simplesamlphp_metadata_source = undef,
  String $simplesamlphp_cert_country = 'US',
  Optional[String] $simplesamlphp_cert_organization = undef,
  Optional[String] $simplesamlphp_cert_commonname = undef,

  # AKRR Install
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $akrr_source_url                    = $xdmod::params::akrr_source_url,
  String $akrr_version                  = $xdmod::params::akrr_version,
  Optional[Stdlib::Unixpath] $akrr_home = undef,

  # AKRR User
  Boolean $manage_akrr_user                   = true,
  String $akrr_user                           = 'akrr',
  String $akrr_user_group                     = 'akrr',
  Optional[Integer] $akrr_user_group_gid      = undef,
  Optional[Integer] $akrr_user_uid            = undef,
  Stdlib::Unixpath $akrr_user_shell           = '/bin/bash',
  Optional[Stdlib::Unixpath] $akrr_user_home  = undef,
  Boolean $akrr_user_managehome               = true,
  String $akrr_user_comment                   = 'AKRR',
  Boolean $akrr_user_system                   = true,

  # AKRR config
  Integer $akrr_restapi_port     = 8091,
  String $akrr_restapi_rw_password    = $xdmod::params::akrr_restapi_rw_password,
  String $akrr_restapi_ro_password    = $xdmod::params::akrr_restapi_ro_password,
  Optional[String] $akrr_cron_mailto  = undef,
  Array[Integer, 2, 2] $akrr_ingestor_cron_times = [0,5],
  Array[Integer, 2, 2] $appkernel_reports_manager_cron_times = [0,6],

  # SUPReMM install
  String $supremm_version         = $xdmod::params::supremm_version,
  String $supremm_package_ensure  = 'present',
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $supremm_package_url          = $xdmod::params::supremm_package_url,
  String $supremm_package_name    = 'supremm',

  # SUPReMM config
  String $supremm_mongodb_password              = 'changeme',
  String $supremm_mongodb_host            = 'localhost',
  Optional[String] $supremm_mongodb_uri         = undef,
  Optional[String] $supremm_mongodb_replica_set = undef,
  Array[Xdmod::Supremm_Resource] $supremm_resources = [],
  Array[Integer, 2, 2] $supremm_update_cron_times = [0,2],
  Array[Integer, 2, 2] $ingest_jobscripts_cron_times = [0,3],
  Array[Integer, 2, 2] $aggregate_supremm_cron_times = [0,4],
  Stdlib::Absolutepath $supremm_archive_out_dir = '/dev/shm/supremm_test',

  # SUPReMM compute
  Boolean $use_pcp                                = true,
  Enum['include', 'resource'] $pcp_declare_method = 'resource',
  Optional[String] $pcp_resource                  = undef,
  Optional[String] $pcp_pmlogger_path_suffix      = undef,
  String $pcp_pmlogger_config_template            = 'xdmod/supremm/compute/pcp/pmlogger-supremm.config.erb',
  Optional[String] $pcp_pmlogger_config_source    = undef,
  String $pcp_logging_static_freq                 = '1 hour',
  String $pcp_logging_standard_freq               = '30 sec',
  Array $pcp_static_metrics                       = $xdmod::params::supremm_pcp_static_metrics,
  Array $pcp_standard_metrics                     = $xdmod::params::supremm_pcp_standard_metrics,
  Array $pcp_environ_metrics                      = $xdmod::params::supremm_pcp_environ_metrics,
  Boolean $pcp_merge_metrics                      = true,
  Array $pcp_hotproc_exclude_users                = $xdmod::params::supremm_pcp_hotproc_exclude_users,

  # Storage
  String $storage_roles_source = 'puppet:///modules/xdmod/roles.d/storage.json',
  Array[Integer, 2, 2] $storage_cron_times = [0,5],
) inherits xdmod::params {

  case $scheduler {
    'slurm': {
      $scheduler_shredder_command = '/usr/bin/xdmod-slurm-helper --quiet -r RESOURCE'
      $pi_column = 'account_name'
    }
    'pbs': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/pbs/server_priv/accounting'
      $pi_column = 'account'
    }
    'torque': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/torque/server_priv/accounting'
      $pi_column = 'account'
    }
    'sge': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f sge -i /var/lib/gridengine/default/common/accounting'
      $pi_column = undef
    }
    default: {
      fail("Module ${module_name}: Supported scheduler value is either slurm, pbs, torque or sge.")
    }
  }

  if $compute {
    if $use_pcp {
      if ! $pcp_resource {
        fail("Module ${module_name}: pcp_resource must be defined.")
      }
    }
  }

  $storage_resources = $resources.filter |$r| { $r['resource_type'] == 'Disk' }

  $shredder_command_default = $resources.map |$r| {
    regsubst($scheduler_shredder_command, 'RESOURCE', $r['resource'], 'G')
  }
  $shredder_command_real = pick($shredder_command, $shredder_command_default)

  $_package_url = regsubst($package_url, 'VERSION', $version, 'G')
  $_appkernels_package_url = regsubst($appkernels_package_url, 'VERSION', $xdmod_appkernels_version, 'G')
  $_xdmod_supremm_package_url = regsubst($xdmod_supremm_package_url, 'VERSION', $xdmod_supremm_version, 'G')

  $_akrr_source_url = regsubst($akrr_source_url, 'AKRR_VERSION', $akrr_version, 'G')

  $_akrr_user_home = pick($akrr_user_home, "/home/${akrr_user}")
  $_akrr_home = pick($akrr_home, "${_akrr_user_home}/akrr-${akrr_version}")

  $_supremm_package_url = regsubst($supremm_package_url, 'SUPREMM_VERSION', $supremm_version, 'G')
  $_supremm_mongodb_host = $supremm_mongodb_host ? {
    Array   => join($supremm_mongodb_host, ','),
    default => $supremm_mongodb_host,
  }
  if $supremm_mongodb_replica_set {
    $mongodb_uri_replica_set = "?replicaSet=${supremm_mongodb_replica_set}"
    $mongodb_args_replica_set = "${supremm_mongodb_replica_set}/"
  } else {
    $mongodb_uri_replica_set = ''
    $mongodb_args_replica_set = ''
  }
  $_supremm_mongodb_uri = pick($supremm_mongodb_uri, "mongodb://supremm:${supremm_mongodb_password}@${_supremm_mongodb_host}/supremm${mongodb_uri_replica_set}")
  $supremm_mongo_args = "-u supremm -p ${supremm_mongodb_password} --host ${mongodb_args_replica_set}${_supremm_mongodb_host} supremm"

  if $manage_epel {
    $epel = [Yumrepo['epel']]
    include ::epel
  } else {
    $epel = []
  }

  if $local_repo_name {
    $_package_require = [Yumrepo[$local_repo_name]] + $epel
  } else  {
    $_package_require = $epel
  }

  $_mysql_remote_args = "-h ${database_host} -u ${database_user} -p${database_password}"

  if $xdmod::params::compute_only and ($web or $database or $akrr or $supremm or $supremm_database) {
    fail('This operating system is only supported for compute resources.')
  }

  if $database and $web {
    include ::phantomjs
    contain xdmod::user
    contain xdmod::install
    contain xdmod::database
    contain xdmod::config
    contain xdmod::config::simplesamlphp
    include xdmod::apache

    Class['::phantomjs']
    -> Class['xdmod::user']
    -> Class['xdmod::install']
    -> Class['xdmod::database']
    -> Class['xdmod::config']
    -> Class['xdmod::config::simplesamlphp']
    -> Class['xdmod::apache']
  } elsif $database {
    contain xdmod::database
  } elsif $web {
    include ::phantomjs
    contain xdmod::user
    contain xdmod::install
    contain xdmod::config
    contain xdmod::config::simplesamlphp
    contain xdmod::apache

    Class['::phantomjs']
    -> Class['xdmod::user']
    -> Class['xdmod::install']
    -> Class['xdmod::config']
    -> Class['xdmod::config::simplesamlphp']
    -> Class['xdmod::apache']
  }

  if $akrr {
    include mysql::bindings
    include mysql::bindings::python
    contain xdmod::akrr::user
    contain xdmod::akrr::install
    contain xdmod::akrr::config
    contain xdmod::akrr::service

    Class['mysql::bindings::python']
    -> Class['xdmod::akrr::user']
    -> Class['xdmod::akrr::install']
    -> Class['xdmod::akrr::config']
    -> Class['xdmod::akrr::service']

    if $database {
      Class['xdmod::database']->Class['xdmod::akrr::user']
    }
  }

  if $supremm_database {
    contain xdmod::supremm::database
  }

  if $supremm {
    if $web {
      $supremm_mysql_access = 'include'
      Class['xdmod::supremm::config']->Class['xdmod::config']
    } else {
      $supremm_mysql_access = 'defaultsfile'
    }

    include mysql::client
    include mongodb::client
    contain xdmod::supremm::install
    contain xdmod::supremm::config

    case $xdmod::pcp_declare_method {
      'include': {
        include ::pcp
      }
      'resource': {
        class { '::pcp':
          ensure      => 'stopped',
          manage_repo => $xdmod::params::pcp_manage_repo,
        }
      }
      default: {
        # Do nothing
      }
    }

    if $manage_epel {
      Yumrepo['epel']->Package['mongodb_client']
    }

    Class['::pcp']
    -> Class['xdmod::supremm::install']
    -> Class['xdmod::supremm::config']

    if $database {
      Class['xdmod::database']->Class['xdmod::supremm::config']
    }

    if $supremm_database {
      Class['xdmod::supremm::database']->Class['xdmod::supremm::install']
    }
  }

  if $compute {
    if $use_pcp {
      contain xdmod::supremm::compute::pcp
    }
  }

}
