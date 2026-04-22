# @summary Manage XDMOD cron resources
#
# @api private
class xdmod::cron {
  assert_private()

  if $xdmod::manage_cron {
    $minute = sprintf('%02d', $xdmod::cron_times[0])
    $hour   = sprintf('%02d', $xdmod::cron_times[1])
    file { '/usr/local/bin/xdmod-cron.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('xdmod/xdmod_cron.erb'),
    }
    # Remove packaged cron job
    file { '/etc/cron.d/xdmod':
      ensure => 'absent',
    }
    systemd::timer_wrapper { 'xdmod-cron':
      ensure            => 'present',
      command           => '/usr/local/bin/xdmod-cron.sh',
      on_calendar       => "*-*-* ${hour}:${minute}:00",
      user              => 'xdmod',
      service_overrides => {
        'Group'            => 'xdmod',
        'SyslogIdentifier' => 'xdmod-cron',
      },
    }

    # Remove previous cron jobs
    $old_cron = [
      '/etc/cron.d/xdmod-storage',
      '/etc/cron.d/supremm',
      '/etc/cron.d/xdmod-ondemand',
    ]
    $old_cron.each |$f| {
      file { $f: ensure => 'absent' }
    }
  }
}
