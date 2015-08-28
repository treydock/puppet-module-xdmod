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

  xdmod_portal_setting { 'features/appkernels': value => $_appkernels }

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
