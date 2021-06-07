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
# @param cron_times
#   The cron times for ondemand shred/ingest
#
class xdmod::ondemand (
  Optional[String] $geoip_userid = undef,
  Optional[String] $geoip_licensekey = undef,
  String $package_name = 'xdmod-ondemand',
  String $package_ensure = 'installed',
  Stdlib::HTTPSUrl $package_url  = 'https://github.com/ubccr/xdmod-ondemand/releases/download/9.5.0-rc1/xdmod-ondemand-9.5.0-1.0.rc.1.el7.noarch.rpm',
  Array[Integer, 2, 2] $cron_times = [0,7],
) {
  include xdmod

  if $geoip_userid and $geoip_licensekey {
    $geoip_directory = '/usr/share/GeoIP'
    class { 'geoip':
      config => {
        'userid'             => $geoip_userid,
        'licensekey'         => $geoip_licensekey,
        'database_directory' => $geoip_directory,
        'productids'         => ['GeoLite2-City'],
      },
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
    $package_subscribe = Package['xdmod-ondemand']
  } else {
    yum::install { $package_name:
      ensure  => 'present',
      source  => $package_url,
      require => $xdmod::_package_require,
    }
    $package_subscribe = Yum::Install[$package_name]
  }

  if $geoip_directory {
    exec { 'xmod-ondemand-enable-geoip-file':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => 'mv -f /etc/xdmod/etl/etl.d/ood.json.puppet-save /etc/xdmod/etl/etl.d/ood.json',
      onlyif      => 'test -f /etc/xdmod/etl/etl.d/ood.json.puppet-save',
      require     => $package_subscribe,
    }
  } else {
    exec { 'xmod-ondemand-disable-geoip-file':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => 'sed -i.puppet-save \'/"geoip_file":/d\' /etc/xdmod/etl/etl.d/ood.json',
      refreshonly => true,
      subscribe   => $package_subscribe,
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
