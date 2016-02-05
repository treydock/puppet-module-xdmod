# Private class
class xdmod::config {

  create_resources('xdmod_portal_setting', $xdmod::portal_settings)

  Xdmod_portal_setting {
    before => [
      File['/etc/xdmod/hierarchy.csv'],
      File['/etc/xdmod/group-to-hierarchy.csv'],
      File['/etc/xdmod/names.csv'],
    ]
  }

  xdmod_portal_setting { 'logger/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'logger/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'logger/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'logger/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'database/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'database/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'database/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'database/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'datawarehouse/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'datawarehouse/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'datawarehouse/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'datawarehouse/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'shredder/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'shredder/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'shredder/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'shredder/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'hpcdb/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'hpcdb/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'hpcdb/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'hpcdb/pass': value => $xdmod::database_password }

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

  xdmod_portal_setting { 'reporting/java_path': value => '/usr/bin/java' }

  if $xdmod::enable_appkernel {
    file { '/etc/xdmod/portal_settings.d/appkernels.ini':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    xdmod_appkernel_setting { 'features/appkernels': value => $_appkernels }
    xdmod_appkernel_setting { 'appkernel/host': value => $xdmod::database_host }
    xdmod_appkernel_setting { 'appkernel/port': value => $xdmod::database_port }
    xdmod_appkernel_setting { 'appkernel/user': value => $xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'appkernel/pass': value => $xdmod::akrr_database_password }
    xdmod_appkernel_setting { 'akrr-db/host': value => $xdmod::database_host }
    xdmod_appkernel_setting { 'akrr-db/port': value => $xdmod::database_port }
    xdmod_appkernel_setting { 'akrr-db/user': value => $xdmod::akrr_database_user }
    xdmod_appkernel_setting { 'akrr-db/pass': value => $xdmod::akrr_database_password }
    xdmod_appkernel_setting { 'akrr/host': value => 'localhost' }
    xdmod_appkernel_setting { 'akrr/port': value => $xdmod::akrr_restapi_port }
    xdmod_appkernel_setting { 'akrr/username': value => 'rw' }
    xdmod_appkernel_setting { 'akrr/password': value => $xdmod::akrr_restapi_rw_password }

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
      command => 'npm install',
      unless  => [
        'test -d /usr/share/xdmod/etl/js/node_modules/cloneextend',
        'test -d /usr/share/xdmod/etl/js/node_modules/ini',
        'test -d /usr/share/xdmod/etl/js/node_modules/minimist',
        'test -d /usr/share/xdmod/etl/js/node_modules/mongodb',
        'test -d /usr/share/xdmod/etl/js/node_modules/mysql',
        'test -d /usr/share/xdmod/etl/js/node_modules/winston',
        'test -d /usr/share/xdmod/etl/js/node_modules/winston-mysql-transport',
      ],
      before  => Exec['generate-etl-config'],
    }

    file { '/etc/xdmod/portal_settings.d/supremm.ini':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    xdmod_supremm_setting { 'features/singlejobviewer': value => $_singlejobviewer }

    $_configure_etl_cmd = [
      'sed -i',
      "-e 's|<MONGO_HOSTNAME>|${xdmod::supremm_mongodb_host}|g'",
      "-e 's|<MONGO_COLLECTION_NAME>|resource_${xdmod::resource_id}|g'",
      "-e 's|<SHORT_NAME>|${xdmod::_resource_short_name}|g'",
      "-e 's|<LONG_NAME>|${xdmod::_resource_long_name}|g'",
      "-e 's|<ID>|${xdmod::resource_id}|g'",
      '/usr/share/xdmod/etl/js/config/supremm/etl.profile.js'
    ]

    exec { 'configure-etl':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => join($_configure_etl_cmd, ' '),
      onlyif  => 'egrep -v "^\*|^\s+\*"  /usr/share/xdmod/etl/js/config/supremm/etl.profile.js | egrep "<MONGO_HOSTNAME>|<SHORT_NAME>|<LONG_NAME>|<ID>|<MONGO_COLLECTION_NAME>"',
      notify  => Exec['generate-etl-config'],
    }

    exec { 'generate-etl-config':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      cwd         => '/usr/share/xdmod/etl/js',
      command     => 'node etl.cli.js -i',
      refreshonly => true,
    }

    if $xdmod::database_host != 'localhost' {
      exec { 'modw_supremm-schema':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "mysql ${xdmod::_mysql_remote_args} -D modw_supremm < /usr/share/xdmod/db/schema/modw_supremm.sql",
        onlyif  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
        unless  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^jobstatus$'",
      }
      exec { 'modw_etl-schema':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "mysql ${xdmod::_mysql_remote_args} -D modw_etl < /usr/share/xdmod/db/schema/modw_etl.sql",
        onlyif  => [
          "mysql ${xdmod::_mysql_remote_args} -BN -e 'SHOW DATABASES' | egrep -q '^modw_etl$'",
          "mysql ${xdmod::_mysql_remote_args} -BN -e 'SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema=\"modw_etl\"' | egrep -q '^0$'",
        ],
      }
    }
  }

  file { '/etc/xdmod/portal_settings.ini':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $xdmod::database_host != 'localhost' {
    file { '/root/xdmod-database-setup.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      content => template('xdmod/xdmod-database-setup.sh.erb'),
    }

    exec { 'xdmod-database-setup.sh':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => '/root/xdmod-database-setup.sh && touch /etc/xdmod/.database-setup',
      creates => '/etc/xdmod/.database-setup',
    }
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

  file { '/etc/xdmod/hierarchy.csv':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/hierarchy.csv.erb'),
    notify  => Exec['xdmod-import-csv-hierarchy'],
  }

  exec { 'xdmod-import-csv-hierarchy':
    path        => '/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
    refreshonly => true,
    before      => Exec['xdmod-import-csv-group-to-hierarchy'],
  }

  file { '/etc/xdmod/group-to-hierarchy.csv':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/group-to-hierarchy.csv.erb'),
    notify  => Exec['xdmod-import-csv-group-to-hierarchy'],
  }

  exec { 'xdmod-import-csv-group-to-hierarchy':
    path        => '/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'xdmod-import-csv -t group-to-hierarchy -i /etc/xdmod/group-to-hierarchy.csv',
    refreshonly => true,
  }

  file { '/etc/xdmod/names.csv':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/names.csv.erb'),
    notify  => Exec['xdmod-import-csv-names'],
  }

  exec { 'xdmod-import-csv-names':
    path        => '/sbin:/bin:/usr/sbin:/usr/bin',
    command     => 'xdmod-import-csv -t names -i /etc/xdmod/names.csv',
    refreshonly => true,
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
    rotate       => '4',
    rotate_every => 'week',
    missingok    => true,
    compress     => true,
    dateext      => true,
  }

}
