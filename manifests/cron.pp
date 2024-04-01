# @summary Manage XDMOD cron resources
#
# @api private
class xdmod::cron {
  assert_private()

  if $xdmod::manage_cron {
    $minute = $xdmod::cron_times[0]
    $hour   = $xdmod::cron_times[1]
    file { '/usr/local/bin/xdmod-cron.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('xdmod/xdmod_cron.erb'),
    }
    file { '/etc/cron.d/xdmod':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => join([
          '# File managed by Puppet, DO NOT EDIT',
          "${minute} ${hour} * * * xdmod /usr/local/bin/xdmod-cron.sh",
          '',
      ], "\n"),
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
