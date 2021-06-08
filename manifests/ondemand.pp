# @summary Manage XDMoD OnDemand plugin
#
# @param geoip_userid
#   The MaxMind GeoIP user ID
#   Must be set if you wish to use GeoIP database
# @param geoip_licensekey
#   The MaxMind GeoIP license key
#   Must be set if you wish to use GeoIP database
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
#
class xdmod::ondemand (
  Optional[String] $geoip_userid = undef,
  Optional[String] $geoip_licensekey = undef,
  String $package_name = 'xdmod-ondemand',
  String $package_ensure = 'installed',
  Stdlib::HTTPSUrl $package_url  = 'https://github.com/ubccr/xdmod-ondemand/releases/download/9.5.0-rc1/xdmod-ondemand-9.5.0-1.0.rc.1.el7.noarch.rpm',
  String $log_format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"',
  Array[Integer, 2, 2] $cron_times = [0,7],
) {
  include xdmod

  if $geoip_userid and $geoip_licensekey {
    $geoip_directory = '/usr/share/GeoIP'
    $update_timer_hour = sprintf('%02d', ($cron_times[1] - 1))
    class { 'geoip':
      packages      => ['geoipupdate'],
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
    Systemd::Unit_file <| title == "${geoip::service_name}.service" |> {
      content => epp('xdmod/ondemand/geoip_service_unit.epp'),
    }
  } else {
    $geoip_directory = undef
  }

  if $xdmod::local_repo_name {
    package { 'xdmod-ondemand':
      ensure  => $package_ensure,
      name    => $package_name,
      require => $xdmod::_package_require,
    }
    $package_resource = Package['xdmod-ondemand']
  } else {
    yum::install { $package_name:
      ensure  => 'present',
      source  => $package_url,
      require => $xdmod::_package_require,
    }
    $package_resource = Yum::Install[$package_name]
  }

  augeas { 'xdmod-ondemand-log_format':
    incl    => '/etc/xdmod/etl/etl.d/ood.json',
    lens    => 'Json.lns',
    changes => [
      "set dict/entry[. = \"log-ingestion\"]/array/dict/entry[. = \"endpoints\"]/dict/entry/dict/entry[. = \"handler\"]/dict/entry[. = \"log_format\"]/string \'${log_format}'",
    ],
    require => $package_resource,
  }

  if $geoip_directory {
    augeas { 'xdmod-ondemand-geoip_file':
      incl    => '/etc/xdmod/etl/etl.d/ood.json',
      lens    => 'Json.lns',
      changes => [
        'set dict/entry[. = "log-ingestion"]/array/dict/entry[. = "endpoints"]/dict/entry/dict/entry[. = "handler"]/dict/entry[last()+1] "geoip_file"',
        'set dict/entry[. = "log-ingestion"]/array/dict/entry[. = "endpoints"]/dict/entry/dict/entry[. = "handler"]/dict/entry[. = "geoip_file"]/string "${GEOIP_FILE_PATH}"',
      ],
      onlyif  => 'match dict/entry[. = "log-ingestion"]/array/dict/entry[. = "endpoints"]/dict/entry/dict/entry[. = "handler"]/dict/entry[. = "geoip_file"] size == 0',
      require => $package_resource,
    }
  } else {
    augeas { 'xdmod-ondemand-rm-geoip_file':
      incl    => '/etc/xdmod/etl/etl.d/ood.json',
      lens    => 'Json.lns',
      changes => [
        'rm dict/entry[. = "log-ingestion"]/array/dict/entry[. = "endpoints"]/dict/entry/dict/entry[. = "handler"]/dict/entry[. = "geoip_file"]',
      ],
      require => $package_resource,
    }
  }

  file { '/usr/local/bin/xdmod-ondemand-ingest.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('xdmod/ondemand/ingest.sh.erb'),
    before  => File['/etc/cron.d/xdmod-ondemand'],
  }
  file { '/etc/cron.d/xdmod-ondemand':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/ondemand/cron.erb'),
  }
}
