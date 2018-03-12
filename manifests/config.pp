# Private class
class xdmod::config {

  create_resources('xdmod_portal_setting', $xdmod::portal_settings)

  Xdmod_portal_setting {
    before => [
      File['/etc/xdmod/hierarchy.csv'],
      File['/etc/xdmod/group-to-hierarchy.csv'],
      File['/etc/xdmod/names.csv'],
      Exec['acl-xdmod-management'],
    ]
  }

  file { '/etc/xdmod/portal_settings.ini':
    ensure => 'file',
    owner  => 'xdmod',
    group  => 'apache',
    mode   => '0640',
  }

  xdmod_portal_setting { 'general/site_address': value => "https://${xdmod::apache_vhost_name}/" }
  xdmod_portal_setting { 'general/user_manual': value => "https://${xdmod::apache_vhost_name}/user_manual/" }

  xdmod_portal_setting { 'mailer/sender_email': value => $xdmod::sender_email }

  xdmod_portal_setting { 'reporting/phantomjs_path': value => $::phantomjs::path }
  xdmod_portal_setting { 'reporting/java_path': value => '/usr/bin/java' }
  xdmod_portal_setting { 'reporting/javac_path': value => '/usr/bin/javac' }

  xdmod_portal_setting { 'logger/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'logger/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'logger/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'logger/pass': value => $xdmod::database_password, secret => true }

  xdmod_portal_setting { 'database/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'database/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'database/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'database/pass': value => $xdmod::database_password, secret => true }

  xdmod_portal_setting { 'datawarehouse/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'datawarehouse/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'datawarehouse/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'datawarehouse/pass': value => $xdmod::database_password, secret => true }

  xdmod_portal_setting { 'shredder/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'shredder/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'shredder/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'shredder/pass': value => $xdmod::database_password, secret => true }

  xdmod_portal_setting { 'hpcdb/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'hpcdb/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'hpcdb/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'hpcdb/pass': value => $xdmod::database_password, secret => true }

  $_appkernels = $xdmod::enable_appkernel ? {
    true  => 'on',
    false => 'off',
  }

  $_singlejobviewer = $xdmod::enable_supremm ? {
    true  => 'on',
    false => 'off',
  }

  xdmod_portal_setting { 'features/appkernels': value => $_appkernels }
  xdmod_portal_setting { 'features/singlejobviewer': value => $_singlejobviewer }

  if $xdmod::enable_appkernel {
    file { '/etc/xdmod/portal_settings.d/appkernels.ini':
      ensure => 'file',
      owner  => 'xdmod',
      group  => 'apache',
      mode   => '0640',
    }

    xdmod_appkernel_setting { 'features/appkernels': value => $_appkernels }
    xdmod_appkernel_setting { 'appkernel/host': value => $xdmod::database_host }
    xdmod_appkernel_setting { 'appkernel/port': value => $xdmod::database_port }
    xdmod_appkernel_setting { 'appkernel/user': value => $xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'appkernel/pass': value => $xdmod::akrr_database_password, secret => true }
    xdmod_appkernel_setting { 'akrr-db/host': value => $xdmod::database_host }
    xdmod_appkernel_setting { 'akrr-db/port': value => $xdmod::database_port }
    xdmod_appkernel_setting { 'akrr-db/user': value => $xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'akrr-db/pass': value => $xdmod::akrr_database_password, secret => true }
    xdmod_appkernel_setting { 'akrr/host': value => 'localhost' }
    xdmod_appkernel_setting { 'akrr/port': value => $xdmod::akrr_restapi_port }
    xdmod_appkernel_setting { 'akrr/username': value => 'rw' }
    xdmod_appkernel_setting { 'akrr/password': value => $xdmod::akrr_restapi_rw_password, secret => true }

    file { '/etc/cron.d/xdmod-appkernels':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('xdmod/xdmod-appkernels_cron.erb'),
    }
  }

  if $xdmod::enable_supremm {
    exec { 'xdmod-supremm-npm-install':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd     => '/usr/share/xdmod/etl/js',
      command => 'npm install && touch .npm-installed',
      creates => '/usr/share/xdmod/etl/js/.npm-installed',
    }

    file { '/etc/xdmod/portal_settings.d/supremm.ini':
      ensure => 'file',
      owner  => 'xdmod',
      group  => 'apache',
      mode   => '0640',
    }

    xdmod_supremm_setting { 'features/singlejobviewer': value => 'on' }
    xdmod_supremm_setting { 'jobsummarydb/db_engine': value => 'MongoDB' }
    xdmod_supremm_setting { 'jobsummarydb/uri': value => $xdmod::_supremm_mongodb_uri, secret => true }
    xdmod_supremm_setting { 'jobsummarydb/db': value => 'supremm' }

    $supremm_resources = $xdmod::supremm_resources.map |$r| {
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
      $d = {
        'resource'    => $r['resource'],
        'resource_id' => $r['resource_id'],
        'enabled'     => $enabled,
        'datasetmap'  => $datasetmap,
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

    if $xdmod::database_host != 'localhost' {
      exec { 'modw_supremm-schema':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "mysql ${xdmod::_mysql_remote_args} -D modw_supremm < /usr/share/xdmod/db/schema/modw_supremm.sql",
        onlyif  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
        unless  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^jobstatus$'",# lint:ignore:140chars
      }
      exec { 'modw_etl-schema':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "mysql ${xdmod::_mysql_remote_args} -D modw_etl < /usr/share/xdmod/db/schema/modw_etl.sql",
        onlyif  => [
          "mysql ${xdmod::_mysql_remote_args} -BN -e 'SHOW DATABASES' | egrep -q '^modw_etl$'",
          "mysql ${xdmod::_mysql_remote_args} -BN -e 'SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema=\"modw_etl\"' | egrep -q '^0$'",# lint:ignore:140chars
        ],
      }
    }
  }

  if $xdmod::database_host != 'localhost' {
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
      before  => Exec['acl-xdmod-management'],
    }
  }

  exec { 'acl-xdmod-management':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/usr/bin/acl-xdmod-management && touch /etc/xdmod/.acl-xdmod-management',
    creates => '/etc/xdmod/.acl-xdmod-management'
  }
  -> exec { 'acl-config':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/usr/bin/acl-config && touch /etc/xdmod/.acl-config',
    creates => '/etc/xdmod/.acl-config'
  }
  -> exec { 'acl-import':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => '/usr/bin/acl-import && touch /etc/xdmod/.acl-import',
    creates => '/etc/xdmod/.acl-import'
  }

  if $xdmod::organization_name and $xdmod::organization_abbrev {
    $organization = {
      'name'   => $xdmod::organization_name,
      'abbrev' => $xdmod::organization_abbrev
    }
    file { '/etc/xdmod/organization.json':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => to_json_pretty($organization),
      #content => join([
      #  '{',
      #  "    \"name\": \"${xdmod::organization_name}\",",
      #  "    \"abbrev\": \"${xdmod::organization_abbrev}\"",
      #  '}',
      #], "\n"),
    }
  }

  $resources = $xdmod::resources.map |$r| {
    $resource_type_id = $r['resource_type_id'] ? {
      Undef   => 1,
      default => $r['resource_type_id'],
    }
    $pi_column = $r['pi_column'] ? {
      Undef   => $xdmod::pi_column,
      default => $r['pi_column'],
    }
    delete_undef_values({
      'resource' => $r['resource'],
      'name' => $r['name'],
      'description' => $r['description'],
      'resource_type_id' => $resource_type_id,
      'pi_column' => $pi_column,
      'timezone' => $r['timezone'],
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
    content => to_json_pretty($xdmod::resource_specs),
  }

  # Template uses:
  # - $hierarchy_levels
  file { '/etc/xdmod/hierarchy.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/hierarchy.json.erb'),
  }

  if ! empty($xdmod::hierarchies) {
    $hierarchies_content = template('xdmod/hierarchy.csv.erb')

    exec { 'xdmod-import-csv-hierarchy':
      path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
      refreshonly => true,
      subscribe   => File['/etc/xdmod/hierarchy.csv'],
    }
    if ! empty($xdmod::group_to_hierarchy) {
      Exec['xdmod-import-csv-hierarchy'] -> Exec['xdmod-import-csv-group-to-hierarchy']
    }
  } else {
    $hierarchies_content = undef
  }

  file { '/etc/xdmod/hierarchy.csv':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $hierarchies_content,
  }

  if ! empty($xdmod::group_to_hierarchy) {
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
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $group_to_hierarchy_content,
  }

  if ! empty($xdmod::user_pi_names) {
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
    owner   => 'root',
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

  logrotate::rule { 'xdmod':
    ensure       => 'present',
    path         => '/var/log/xdmod/*.log',
    rotate       => 4,
    rotate_every => 'week',
    missingok    => true,
    compress     => true,
    dateext      => true,
    su_owner     => 'apache',
    su_group     => 'apache',
    create       => true,
    create_mode  => '0640',
    create_owner => 'apache',
    create_group => 'apache',
  }

}
