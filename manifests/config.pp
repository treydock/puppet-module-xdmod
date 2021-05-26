# @summary Manage XDMoD configs
# @api private
class xdmod::config {

  Xdmod_portal_setting {
    before => [
      File['/etc/xdmod/hierarchy.csv'],
      File['/etc/xdmod/group-to-hierarchy.csv'],
      File['/etc/xdmod/names.csv'],
      Exec['acl-config'],
    ]
  }

  $::xdmod::portal_settings.each |$name, $data| {
    xdmod_portal_setting { $name: * => $data }
  }

  file { '/etc/xdmod/portal_settings.ini':
    ensure => 'file',
    owner  => 'apache',
    group  => 'xdmod',
    mode   => '0440',
  }

  xdmod_portal_setting { 'general/site_address': value => "https://${::xdmod::apache_vhost_name}/" }
  xdmod_portal_setting { 'general/user_manual': value => "https://${::xdmod::apache_vhost_name}/user_manual/" }
  xdmod_portal_setting { 'general/debug_recipient': value => $::xdmod::debug_recipient }

  xdmod_portal_setting { 'features/user_dashboard': value => $::xdmod::user_dashboard }

  xdmod_portal_setting { 'mailer/sender_email': value => $::xdmod::sender_email }

  xdmod_portal_setting { 'cors/domains': value => join($xdmod::cors_domains, ',') }

  xdmod_portal_setting { 'logger/host': value => $::xdmod::database_host }
  xdmod_portal_setting { 'logger/port': value => $::xdmod::database_port }
  xdmod_portal_setting { 'logger/user': value => $::xdmod::database_user }
  xdmod_portal_setting { 'logger/pass': value => $::xdmod::database_password, secret => true }

  xdmod_portal_setting { 'database/host': value => $::xdmod::database_host }
  xdmod_portal_setting { 'database/port': value => $::xdmod::database_port }
  xdmod_portal_setting { 'database/user': value => $::xdmod::database_user }
  xdmod_portal_setting { 'database/pass': value => $::xdmod::database_password, secret => true }

  xdmod_portal_setting { 'datawarehouse/host': value => $::xdmod::database_host }
  xdmod_portal_setting { 'datawarehouse/port': value => $::xdmod::database_port }
  xdmod_portal_setting { 'datawarehouse/user': value => $::xdmod::database_user }
  xdmod_portal_setting { 'datawarehouse/pass': value => $::xdmod::database_password, secret => true }

  xdmod_portal_setting { 'shredder/host': value => $::xdmod::database_host }
  xdmod_portal_setting { 'shredder/port': value => $::xdmod::database_port }
  xdmod_portal_setting { 'shredder/user': value => $::xdmod::database_user }
  xdmod_portal_setting { 'shredder/pass': value => $::xdmod::database_password, secret => true }

  xdmod_portal_setting { 'hpcdb/host': value => $::xdmod::database_host }
  xdmod_portal_setting { 'hpcdb/port': value => $::xdmod::database_port }
  xdmod_portal_setting { 'hpcdb/user': value => $::xdmod::database_user }
  xdmod_portal_setting { 'hpcdb/pass': value => $::xdmod::database_password, secret => true }

  xdmod_portal_setting { 'data_warehouse_export/export_directory': value => $::xdmod::data_warehouse_export_directory }
  xdmod_portal_setting { 'data_warehouse_export/retention_duration_days': value => $::xdmod::data_warehouse_export_retention_duration_days }
  xdmod_portal_setting { 'data_warehouse_export/hash_salt': value => $::xdmod::data_warehouse_export_hash_salt }

  if $::xdmod::center_logo_source {
    file { '/etc/xdmod/logo.png':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $::xdmod::center_logo_source,
    }
    $center_logo = '/etc/xdmod/logo.png'
  } else {
    $center_logo = ''
  }
  xdmod_portal_setting { 'general/center_logo': value => $center_logo }
  if $::xdmod::center_logo_width {
    xdmod_portal_setting { 'general/center_logo_width': value => $::xdmod::center_logo_width }
  }

  $_appkernels = $::xdmod::enable_appkernel ? {
    true  => 'on',
    false => 'off',
  }

  $_singlejobviewer = $::xdmod::enable_supremm ? {
    true  => 'on',
    false => 'off',
  }

  xdmod_portal_setting { 'features/appkernels': value => $_appkernels }

  if $::xdmod::enable_appkernel {
    file { '/etc/xdmod/portal_settings.d/appkernels.ini':
      ensure => 'file',
      owner  => 'xdmod',
      group  => 'apache',
      mode   => '0640',
    }

    xdmod_appkernel_setting { 'features/appkernels': value => $_appkernels }
    xdmod_appkernel_setting { 'appkernel/host': value => $::xdmod::database_host }
    xdmod_appkernel_setting { 'appkernel/port': value => $::xdmod::database_port }
    xdmod_appkernel_setting { 'appkernel/user': value => $::xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'appkernel/pass': value => $::xdmod::akrr_database_password, secret => true }
    xdmod_appkernel_setting { 'akrr-db/host': value => $::xdmod::database_host }
    xdmod_appkernel_setting { 'akrr-db/port': value => $::xdmod::database_port }
    xdmod_appkernel_setting { 'akrr-db/user': value => $::xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'akrr-db/pass': value => $::xdmod::akrr_database_password, secret => true }
    xdmod_appkernel_setting { 'akrr/host': value => 'localhost' }
    xdmod_appkernel_setting { 'akrr/port': value => $::xdmod::akrr_restapi_port }
    xdmod_appkernel_setting { 'akrr/username': value => 'rw' }
    xdmod_appkernel_setting { 'akrr/password': value => $::xdmod::akrr_restapi_rw_password, secret => true }

    file { '/etc/cron.d/xdmod-appkernels':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('xdmod/xdmod-appkernels_cron.erb'),
    }
  }

  if $::xdmod::enable_supremm {
    file { '/etc/xdmod/portal_settings.d/supremm.ini':
      ensure => 'file',
      owner  => 'xdmod',
      group  => 'apache',
      mode   => '0640',
    }

    xdmod_supremm_setting { 'jobsummarydb/db_engine': value => 'MongoDB' }
    xdmod_supremm_setting { 'jobsummarydb/uri': value => $::xdmod::_supremm_mongodb_uri, secret => true }
    xdmod_supremm_setting { 'jobsummarydb/db': value => 'supremm' }

    $supremm_resources = $::xdmod::supremm_resources.map |$r| {
      $enabled = $r['enabled'] ? {
        Undef   => true,
        default => $r['enabled'],
      }
      $datasetmap = $r['datasetmap'] ? {
        Undef   => 'pcp',
        default => $r['datasetmap'],
      }
      if $r['hardware'] {
        $hardware = $r['hardware']
      } else {
        $hardware = {'gpfs' => ''}
      }
      if $r['datasetmap_source'] {
        $datasetmap_name = basename($r['datasetmap_source'], '.js')
        ensure_resource('file', "/usr/share/xdmod/etl/js/config/supremm/dataset_maps/${datasetmap_name}.js", {
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => $r['datasetmap_source'],
        })
        if ! $r['datasetmap'] {
          $_datasetmap = $datasetmap_name
        } else {
          $_datasetmap = $datasetmap
        }
      } else {
        $_datasetmap = $datasetmap
      }
      $d = {
        'resource'    => $r['resource'],
        'resource_id' => $r['resource_id'],
        'enabled'     => $enabled,
        'datasetmap'  => $_datasetmap,
        'hardware'    => $hardware,
      }
    }

    file { '/etc/xdmod/supremm_resources.json':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => to_json_pretty({'resources' => $supremm_resources}),
    }

    exec { 'modw_supremm-schema':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "mysql ${::xdmod::_mysql_remote_args} -D modw_supremm < /usr/share/xdmod/db/schema/modw_supremm.sql",
      onlyif  => "mysql -BN ${::xdmod::_mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
      unless  => "mysql -BN ${::xdmod::_mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^job_name$'",# lint:ignore:140chars
    }
    exec { 'modw_etl-schema':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "mysql ${::xdmod::_mysql_remote_args} -D modw_etl < /usr/share/xdmod/db/schema/modw_etl.sql",
      onlyif  => [
        "mysql ${::xdmod::_mysql_remote_args} -BN -e 'SHOW DATABASES' | egrep -q '^modw_etl$'",
        "mysql ${::xdmod::_mysql_remote_args} -BN -e 'SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema=\"modw_etl\"' | egrep -q '^0$'",# lint:ignore:140chars
      ],
    }
  }

  if ! empty($::xdmod::storage_resources) {
    $storage_file_ensure = 'file'
  } else {
    $storage_file_ensure = 'absent'
  }
  file { '/etc/xdmod/roles.d/storage.json':
    ensure => $storage_file_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $::xdmod::storage_roles_source,
    notify => Exec['acl-refresh'],
  }
  file { '/usr/local/bin/xdmod-storage-ingest.sh':
    ensure  => $storage_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('xdmod/storage/ingest.sh.erb'),
    before  => File['/etc/cron.d/xdmod-storage'],
  }

  if $::xdmod::php_timezone and $::xdmod::web {
    ini_setting { 'php-timezone':
      ensure  => 'present',
      path    => '/etc/php.ini',
      section => 'Date',
      setting => 'date.timezone',
      value   => $::xdmod::php_timezone,
      before  => Exec['etl-bootstrap'],
    }
    if $::xdmod::manage_apache_vhost {
      Ini_setting['php-timezone'] ~> Service['httpd']
    }
  }

  file { '/root/xdmod-database-setup.sh':
    ensure    => 'file',
    owner     => 'root',
    group     => 'root',
    mode      => '0700',
    content   => template('xdmod/xdmod-database-setup.sh.erb'),
    show_diff => false,
  }

  exec { 'xdmod-database-setup.sh':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/root/xdmod-database-setup.sh && touch /etc/xdmod/.database-setup',
    creates => '/etc/xdmod/.database-setup',
    require => File['/root/xdmod-database-setup.sh'],
    before  => Exec['etl-bootstrap'],
  }

  exec { 'etl-bootstrap':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/usr/share/xdmod/tools/etl/etl_overseer.php -p xdb-bootstrap -p jobs-xdw-bootstrap -p xdw-bootstrap-storage -p shredder-bootstrap -p staging-bootstrap -p hpcdb-bootstrap -v debug && touch /etc/xdmod/.etl-bootstrap', # lint:ignore:140chars
    creates => '/etc/xdmod/.etl-bootstrap',
  }
  -> exec { 'acl-config':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/usr/bin/acl-config && touch /etc/xdmod/.acl-config',
    creates => '/etc/xdmod/.acl-config'
  }
  exec { 'acl-refresh':
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    command     => '/usr/bin/acl-config',
    logoutput   => true,
    refreshonly => true,
    require     => Exec['acl-config'],
  }

  if $::xdmod::organization_name and $::xdmod::organization_abbrev {
    $organization = {
      'name'   => $::xdmod::organization_name,
      'abbrev' => $::xdmod::organization_abbrev
    }
    file { '/etc/xdmod/organization.json':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => to_json_pretty($organization),
      #content => join([
      #  '{',
      #  "    \"name\": \"${::xdmod::organization_name}\",",
      #  "    \"abbrev\": \"${::xdmod::organization_abbrev}\"",
      #  '}',
      #], "\n"),
    }
  }

  $resources = $::xdmod::resources.map |$r| {
    $resource_type = $r['resource_type'] ? {
      Undef   => 'HPC',
      default => $r['resource_type'],
    }
    $pi_column = $r['pi_column'] ? {
      Undef   => $::xdmod::pi_column,
      default => $r['pi_column'],
    }
    delete_undef_values({
      'resource' => $r['resource'],
      'name' => $r['name'],
      'description' => $r['description'],
      'resource_type' => $resource_type,
      'pi_column' => $pi_column,
      'timezone' => $r['timezone'],
      'shared_jobs' => $r['shared_jobs'],
    })
  }

  file { '/etc/xdmod/resources.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => to_json_pretty($resources),
  }
  file { '/etc/xdmod/resource_specs.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => to_json_pretty($::xdmod::resource_specs),
  }

  $hierarchy_levels = $::xdmod::params::hierarchy_levels + $::xdmod::hierarchy_levels
  # Template uses:
  # - $hierarchy_levels
  file { '/etc/xdmod/hierarchy.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/hierarchy.json.erb'),
  }

  if ! empty($::xdmod::hierarchies) {
    $hierarchies_content = template('xdmod/hierarchy.csv.erb')

    exec { 'xdmod-import-csv-hierarchy':
      path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
      refreshonly => true,
      subscribe   => File['/etc/xdmod/hierarchy.csv'],
    }
    if ! empty($::xdmod::group_to_hierarchy) {
      Exec['xdmod-import-csv-hierarchy'] -> Exec['xdmod-import-csv-group-to-hierarchy']
    }
  } else {
    $hierarchies_content = undef
  }

  file { '/etc/xdmod/hierarchy.csv':
    ensure  => 'file',
    owner   => 'xdmod',
    group   => 'root',
    mode    => '0644',
    content => $hierarchies_content,
  }

  if ! empty($::xdmod::group_to_hierarchy) {
    $group_to_hierarchy_content = template('xdmod/group-to-hierarchy.csv.erb')

    exec { 'xdmod-import-csv-group-to-hierarchy':
      path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'xdmod-import-csv -t group-to-hierarchy -i /etc/xdmod/group-to-hierarchy.csv',
      refreshonly => true,
      subscribe   => File['/etc/xdmod/group-to-hierarchy.csv'],
    }
  } else {
    $group_to_hierarchy_content = undef
  }

  file { '/etc/xdmod/group-to-hierarchy.csv':
    ensure  => 'file',
    owner   => 'xdmod',
    group   => 'root',
    mode    => '0644',
    content => $group_to_hierarchy_content,
  }

  if ! empty($::xdmod::user_pi_names) {
    $user_pi_names_content = template('xdmod/names.csv.erb')

    exec { 'xdmod-import-csv-names':
      path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'xdmod-import-csv -t names -i /etc/xdmod/names.csv',
      refreshonly => true,
      subscribe   => File['/etc/xdmod/names.csv'],
    }
  } else {
    $user_pi_names_content = undef
  }

  file { '/etc/xdmod/names.csv':
    ensure  => 'file',
    owner   => 'xdmod',
    group   => 'root',
    mode    => '0644',
    content => $user_pi_names_content,
  }

  file { '/etc/cron.d/xdmod':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/xdmod_cron.erb'),
  }
  file { '/etc/cron.d/xdmod-storage':
    ensure  => $storage_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/storage/cron.erb'),
  }

  exec { "mkdir-p ${::xdmod::data_warehouse_export_directory}":
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mkdir -p ${::xdmod::data_warehouse_export_directory}",
    creates => $::xdmod::data_warehouse_export_directory,
  }
  -> file { $::xdmod::data_warehouse_export_directory:
    ensure => 'directory',
    owner  => 'apache',
    group  => 'xdmod',
    mode   => '0570',
  }

  $logrotate_defaults = {
    'ensure'       => 'present',
    'rotate'       => 4,
    'rotate_every' => 'week',
    'compress'     => true,
    'missingok'    => true,
    'ifempty'      => false,
    'dateext'      => true,
  }

  logrotate::rule { 'xdmod':
    path         => ['/var/log/xdmod/query.log', '/var/log/xdmod/exceptions.log'],
    su           => true,
    su_user      => 'apache',
    su_group     => 'xdmod',
    create       => true,
    create_mode  => '0660',
    create_owner => 'apache',
    create_group => 'xdmod',
    *            => $logrotate_defaults,
  }

  logrotate::rule { 'xdmod-session_manager':
    path         => '/var/log/xdmod/session_manager.log',
    su           => true,
    su_user      => 'apache',
    su_group     => 'apache',
    create       => true,
    create_mode  => '0640',
    create_owner => 'apache',
    create_group => 'apache',
    *            => $logrotate_defaults,
  }

}
