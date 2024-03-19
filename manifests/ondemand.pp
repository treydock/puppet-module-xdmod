# @summary Manage XDMoD OnDemand plugin
#
# @param geoip_userid
#   The MaxMind GeoIP user ID
#   Must be set if you wish to use GeoIP database
# @param geoip_licensekey
#   The MaxMind GeoIP license key
#   Must be set if you wish to use GeoIP database
# @param version
#   Version of XDMOD OnDemand to install
# @param package_name
#   The XDMOD OnDemand package name
# @param package_ensure
#   The state of XDMOD OnDemand package when using local repo
# @param package_url
#   The URL of the XDMOD OnDemand package when not using local repo
# @param log_format
#   Log format to use for parsing access logs
# @param cron_times
#   The cron times for ondemand shred/ingest
# @param manage_cron
#   Manage OnDemand cron files
#
class xdmod::ondemand (
  Optional[String] $geoip_userid = undef,
  Optional[String] $geoip_licensekey = undef,
  String $version   = $xdmod::params::xdmod_ondemand_version,
  String $package_name = 'xdmod-ondemand',
  String $package_ensure = 'installed',
  Stdlib::HTTPSUrl $package_url  = $xdmod::params::ondemand_package_url,
  String $log_format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"',
  Array[Integer, 2, 2] $cron_times = [0,7],
  Boolean $manage_cron = true,
) inherits xdmod::params {
  include xdmod

  if $geoip_userid and $geoip_licensekey {
    $geoip_directory = '/usr/share/GeoIP'
    $geoip_database = "${geoip_directory}/GeoLite2-City.mmdb"
    $update_timer_hour = sprintf('%02d', ($cron_times[1] - 1))
    class { 'geoip':
      config        => {
        'userid'             => $geoip_userid,
        'licensekey'         => $geoip_licensekey,
        'database_directory' => $geoip_directory,
        'productids'         => ['GeoLite2-City'],
      },
      update_timers => [
        "*-*-* ${update_timer_hour}:00:00",
      ],
    }
    File <| title == $geoip::config_path |> {
      show_diff => false,
    }
  } else {
    $geoip_database = ''
  }

  if $xdmod::local_repo_name {
    package { 'xdmod-ondemand':
      ensure  => $package_ensure,
      name    => $package_name,
      require => $xdmod::_package_require,
      before  => File['/etc/xdmod/portal_settings.d/ondemand.ini'],
      notify  => Exec['etl-bootstrap'],
    }
    $package_resource = Package['xdmod-ondemand']
  } else {
    $_package_url = regsubst($package_url, 'VERSION', $version, 'G')
    yum::install { $package_name:
      ensure  => 'present',
      source  => $_package_url,
      require => $xdmod::_package_require,
      before  => File['/etc/xdmod/portal_settings.d/ondemand.ini'],
      notify  => Exec['etl-bootstrap'],
    }
    $package_resource = Yum::Install[$package_name]
  }

  file { '/etc/xdmod/portal_settings.d/ondemand.ini':
    ensure => 'file',
    owner  => 'apache',
    group  => 'xdmod',
    mode   => '0440',
  }

  xdmod_ondemand_setting { 'ondemand-general/geoip_database': value => $geoip_database }
  xdmod_ondemand_setting { 'ondemand-general/webserver_format_str': value => $log_format }

  file { '/usr/local/bin/xdmod-ondemand-ingest.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('xdmod/ondemand/ingest.sh.erb'),
    before  => File['/etc/cron.d/xdmod-ondemand'],
  }
  if $manage_cron {
    file { '/etc/cron.d/xdmod-ondemand':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('xdmod/ondemand/cron.erb'),
    }
  }
}
