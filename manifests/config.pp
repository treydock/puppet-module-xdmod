# Private class
class xdmod::config {

  create_resources('xdmod_portal_setting', $xdmod::portal_settings)

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

  #[features]
  #xsede = "off"
  #+appkernels = "off"
  #+singlejobviewer = "off"

  #+[rest]
  #+base = "/rest/"
  #+version = "v1"

  #+[auto_login]
  #+; tabs is a comma delimmited list of tab ids that will trigger the login
  #+; page to show up if presented in an non-authenticated state.
  #+tabs = "app_kernels"

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
    xdmod_appkernel_setting { 'appkernel/user': value => $xdmod::database_user }
    xdmod_appkernel_setting { 'appkernel/pass': value => $xdmod::database_password }
  }

  file { '/etc/xdmod/portal_settings.ini':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
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

  file { '/root/xdmod-database-setup.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('xdmod/xdmod-database-setup.sh.erb'),
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
