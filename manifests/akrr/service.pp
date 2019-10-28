# @summary Manage XDMoD AKRR service
# @api private
class xdmod::akrr::service {

  $_base_cmd  = "runuser -l ${::xdmod::akrr_user} -c"
  $_start_cmd = "${_base_cmd} '${::xdmod::_akrr_home}/bin/akrr.sh start'"
  $_stop_cmd  = "${_base_cmd} '${::xdmod::_akrr_home}/bin/akrr.sh stop'"

  exec { 'start akrr':
    cwd     => $::xdmod::_akrr_home,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => $::xdmod::akrr_user,
    command => "${::xdmod::_akrr_home}/bin/akrr.sh start",
    unless  => "pgrep -u ${::xdmod::akrr_user} -f 'akrrscheduler.py.*start'",
    returns => [0,1], # Work around since akrr.sh errors out when executed from Puppet - but service runs fine despite error
  }

  exec { 'restart akrr':
    cwd         => $::xdmod::_akrr_home,
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    user        => $::xdmod::akrr_user,
    command     => "${::xdmod::_akrr_home}/bin/akrr.sh stop && ${::xdmod::_akrr_home}/bin/akrr.sh start",
    onlyif      => "pgrep -u ${::xdmod::akrr_user} -f 'akrrscheduler.py.*start'",
    refreshonly => true,
    returns     => [0,1], # Work around since akrr.sh errors out when executed from Puppet - but service runs fine despite error
  }

#  service { 'akrr':
#    ensure     => 'running',
    #enable     => true,
#    hasrestart => false,
#    hasstatus  => false,
#    start      => $_start_cmd,
#    stop       => $_stop_cmd,
#    status     => "pgrep -u ${::xdmod::akrr_user} -f 'akrrscheduler.py startd'",
    #pattern    => 'akrrscheduler.py start',
#    provider   => 'base',
#  }

}
