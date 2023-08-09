# @summary XDMoD module defaults
# @api private
class xdmod::params {
  $version                  = '10.0.3'
  $xdmod_appkernels_version = '10.0.0'
  $xdmod_supremm_version    = '10.0.0'
  $xdmod_ondemand_version   = '10.0.0'
  $sender_email       = "xdmod@xdmod.${facts['networking']['domain']}"
  $apache_vhost_name  = "xdmod.${facts['networking']['domain']}"
  $portal_settings    = {}
  $hierarchy_levels  = {
    'top'     => { 'label' => 'Hierarchy Top Level', 'info' => '' },
    'middle'  => { 'label' => 'Hierarchy Middle Level', 'info' => '' },
    'bottom'  => { 'label' => 'Hierarchy Bottom Level', 'info' => '' },
  }
  $hierarchies        = []
  $group_to_hierarchy = {}
  $user_pi_names      = []
  $akrr_restapi_rw_password = fqdn_rand_string(16, undef, 'rw')
  $akrr_restapi_ro_password = fqdn_rand_string(16, undef, 'ro')
  $akrr_version             = '1.0.0'
  $akrr_source_url          = 'https://github.com/ubccr/akrr/releases/download/vAKRR_VERSION/akrr-AKRR_VERSION.tar.gz'
  $supremm_version          = '1.4.1'

  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['release']['major'] {
        '7': {
          $rpm_release = 'el7'
          $supremm_rpm_release = 'el7'
          $compute_only = false
          $pcp_package_ensure = undef
          $package_url = "https://github.com/ubccr/xdmod/releases/download/vVERSION/xdmod-VERSION-1.0.${rpm_release}.noarch.rpm"
        }
        '8': {
          $rpm_release = 'beta1.el8'
          $supremm_rpm_release = 'beta1.el8'
          $compute_only = false
          $pcp_package_ensure = undef
          $package_url = 'https://github.com/ubccr/xdmod/releases/download/vVERSION-el8/xdmod-VERSION-1.0.el8.noarch.rpm'
        }
        default: {
          fail("Unsupported operatingsystemmajrelease: ${facts['os']['release']['major']}, module ${module_name} only supports 7 and 8")
        }
      }
      $package_name               = 'xdmod'
      $appkernels_package_name    = 'xdmod-appkernels'
      $appkernels_package_url     = "https://github.com/ubccr/xdmod-appkernels/releases/download/vVERSION/xdmod-appkernels-VERSION-1.0.${rpm_release}.noarch.rpm"
      $xdmod_supremm_package_name = 'xdmod-supremm'
      $xdmod_supremm_package_url  = "https://github.com/ubccr/xdmod-supremm/releases/download/vVERSION/xdmod-supremm-VERSION-1.0.${rpm_release}.noarch.rpm"
      $supremm_package_url        = "https://github.com/ubccr/supremm/releases/download/SUPREMM_VERSION/supremm-SUPREMM_VERSION-1.${supremm_rpm_release}.x86_64.rpm"
      $ondemand_package_url       = "https://github.com/ubccr/xdmod-ondemand/releases/download/vVERSION/xdmod-ondemand-VERSION-1.0.${rpm_release}.noarch.rpm"

    }

    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}, module ${module_name} only support osfamily RedHat")
    }
  }

  $supremm_pcp_static_metrics = [
    "# we don't hardware list very often, just to ensure they don't go missing",
    'hinv.physmem',
    'hinv.pagesize',
    'hinv.ncpu',
    'hinv.ndisk',
    'hinv.nfilesys',
    'hinv.machine',
    'hinv.map.scsi',
    'hinv.map.cpu_num',
    'hinv.map.cpu_node',
    'hinv.cpu.clock',
    'hinv.cpu.vendor',
    'hinv.cpu.model',
    'hinv.cpu.stepping',
    'hinv.cpu.cache',
    'hinv.cpu.bogomips',
    '',
    'kernel.all.uptime',
    '',
    'mem.physmem',
    '',
    '#infiniband.hca.type',
    '#infiniband.hca.ca_type',
    '#infiniband.hca.numports',
    '#infiniband.hca.fw_ver',
    '#infiniband.hca.hw_ver',
    '#infiniband.hca.node_guid',
    '#infiniband.hca.system_guid',
    '#infiniband.port.guid',
    '#infiniband.port.gid_prefix',
    '#infiniband.port.lid',
    '#infiniband.port.rate',
    '#infiniband.port.capabilities',
    '#infiniband.port.linkspeed',
    '#infiniband.port.linkwidth',
    '#infiniband.control.query_timeout',
    '#infiniband.control.hiwat',
    '',
    '#nvidia.numcards',
    '#nvidia.gpuid',
    '#nvidia.cardname',
    '#nvidia.busid',
    '#nvidia.memtotal',
    '',
    '#perfevent.version',
  ]

  $supremm_pcp_standard_metrics = [
    'kernel.all.cpu.user',
    'kernel.all.cpu.sys',
    'kernel.all.cpu.irq.soft',
    'kernel.all.cpu.irq.hard',
    'kernel.all.cpu.intr',
    'kernel.all.cpu.wait.total',
    'kernel.all.cpu.idle',
    'kernel.all.cpu.nice',
    'kernel.all.load',
    '',
    'disk.dev.avactive',
    'disk.dev.aveq	',
    'disk.dev.read',
    'disk.dev.read_bytes',
    'disk.dev.read_merge',
    'disk.dev.read_rawactive',
    'disk.dev.total',
    'disk.dev.write',
    'disk.dev.write_bytes',
    'disk.dev.write_merge',
    'disk.dev.write_rawactive',
    '',
    'disk.all.avactive',
    'disk.all.aveq	',
    'disk.all.read',
    'disk.all.read_bytes',
    'disk.all.read_merge',
    'disk.all.read_rawactive',
    'disk.all.total',
    'disk.all.write',
    'disk.all.write_bytes',
    'disk.all.write_merge',
    'disk.all.write_rawactive',
    '',
    'swap.free',
    'swap.pagesin',
    'swap.pagesout',
    '',
    'kernel.percpu.cpu.user',
    'kernel.percpu.cpu.sys',
    'kernel.percpu.cpu.irq.soft',
    'kernel.percpu.cpu.irq.hard',
    'kernel.percpu.cpu.intr',
    'kernel.percpu.cpu.wait.total',
    'kernel.percpu.cpu.idle',
    'kernel.percpu.cpu.nice',
    '',
    'mem.freemem',
    'mem.util.used',
    'mem.util.free',
    'mem.util.shared',
    'mem.util.bufmem',
    'mem.util.cached',
    'mem.util.other',
    'mem.util.swapCached',
    'mem.util.active',
    'mem.util.inactive',
    'mem.numa.alloc.foreign',
    'mem.numa.alloc.hit',
    'mem.numa.alloc.interleave_hit',
    'mem.numa.alloc.local_node',
    'mem.numa.alloc.miss',
    'mem.numa.alloc.other_node',
    'mem.numa.util.active',
    'mem.numa.util.active_anon',
    'mem.numa.util.active_file',
    'mem.numa.util.anonpages',
    'mem.numa.util.bounce',
    'mem.numa.util.dirty',
    'mem.numa.util.filePages',
    'mem.numa.util.free',
    'mem.numa.util.hugepagesFree',
    'mem.numa.util.hugepagesTotal',
    'mem.numa.util.inactive',
    'mem.numa.util.inactive_anon',
    'mem.numa.util.inactive_file',
    'mem.numa.util.mapped',
    'mem.numa.util.NFS_unstable',
    'mem.numa.util.pageTables',
    'mem.numa.util.slab',
    'mem.numa.util.used',
    'mem.numa.util.writeback',
    '',
    'network.interface.collisions',
    'network.interface.in.bytes',
    'network.interface.in.compressed',
    'network.interface.in.drops',
    'network.interface.in.errors',
    'network.interface.in.fifo',
    'network.interface.in.frame',
    'network.interface.in.mcasts',
    'network.interface.in.packets',
    'network.interface.out.bytes',
    'network.interface.out.carrier',
    'network.interface.out.compressed',
    'network.interface.out.drops',
    'network.interface.out.errors',
    'network.interface.out.fifo',
    'network.interface.out.packets',
    'network.interface.total.bytes',
    'network.interface.total.drops',
    'network.interface.total.errors',
    'network.interface.total.mcasts',
    'network.interface.total.packets',
    '',
    'nfs.client.calls',
    'nfs.client.reqs',
    'nfs3.client.calls',
    'nfs3.client.reqs',
    'nfs4.client.calls',
    'nfs4.client.reqs',
    '',
    'nfsclient.bytes.write.server',
    'nfsclient.bytes.write.direct',
    'nfsclient.bytes.write.normal',
    'nfsclient.bytes.read.server',
    'nfsclient.bytes.read.direct',
    'nfsclient.bytes.read.normal',
    '',
    '# Hotproc ',
    '#',
    'hotproc.nprocs',
    'hotproc.id.uid_nm',
    'hotproc.id.uid',
    'hotproc.schedstat.cpu_time',
    'hotproc.psinfo.utime',
    'hotproc.psinfo.stime',
    'hotproc.psinfo.cgroups',
    'hotproc.psinfo.cpusallowed',
    'hotproc.psinfo.vsize',
    'hotproc.psinfo.rss',
    'hotproc.psinfo.delayacct_blkio_time',
    'hotproc.psinfo.vctxsw',
    'hotproc.psinfo.nvctxsw',
    'hotproc.psinfo.session',
    'hotproc.psinfo.pgrp',
    'hotproc.psinfo.ppid',
    'hotproc.psinfo.cmd',
    'hotproc.psinfo.pid',
    'hotproc.psinfo.processor',
    'hotproc.psinfo.threads',
    'hotproc.psinfo.psargs',
    'hotproc.io.read_bytes',
    'hotproc.io.write_bytes',
    '',
    '#Aggregate hotproc metrics',
    '#',
    'hotproc.total.cpuidle',
    'hotproc.total.cpuburn',
    'hotproc.total.cpuother.transient',
    'hotproc.total.cpuother.not_cpuburn',
    'hotproc.total.cpuother.total',
    '',
    '# cgroup overview metrics',
    'cgroup.mounts.count',
    'cgroup.mounts.subsys',
    'cgroup.subsys.count',
    'cgroup.subsys.hierarchy',
    '',
    '# cgroup group metrics',
    'cgroup.cpuset.cpus',
    'cgroup.memory.usage',
    'cgroup.memory.limit',
    'cgroup.memory.stat.total.rss',
    'cgroup.memory.stat.total.swap',
    'cgroup.memory.stat.total.mapped_file',
    'cgroup.memory.stat.total.cache',
    '',
    '#infiniband.port.state',
    '#infiniband.port.phystate',
    '#infiniband.port.switch.in.bytes',
    '#infiniband.port.switch.in.packets',
    '#infiniband.port.switch.out.bytes',
    '#infiniband.port.switch.out.packets',
    '#infiniband.port.switch.total.bytes',
    '#infiniband.port.switch.total.packets',
    '#infiniband.port.in.errors.drop',
    '#infiniband.port.in.errors.filter',
    '#infiniband.port.in.errors.local',
    '#infiniband.port.in.errors.remote',
    '#infiniband.port.out.errors.drop',
    '#infiniband.port.out.errors.filter',
    '#infiniband.port.total.errors.drop',
    '#infiniband.port.total.errors.filter',
    '#infiniband.port.total.errors.link',
    '#infiniband.port.total.errors.recover',
    '#infiniband.port.total.errors.integrity',
    '#infiniband.port.total.errors.vl15',
    '#infiniband.port.total.errors.overrun',
    '#infiniband.port.total.errors.symbol',
    '',
    '# Nvidia GPU stuff',
    '#nvidia.fanspeed',
    '#nvidia.gpuactive',
    '#nvidia.memactive',
    '#nvidia.memused',
    '#nvidia.perfstate',
    '#nvidia.temp',
    '',
    '# perf_event hardware counter metrics',
    '#perfevent.active',
    '#perfevent.hwcounters',
    '',
    '# gpfs',
    '#gpfs.fsios',
    '',
    '# slurm',
    '#slurm.node',
    '',
    '# Intel MIC cards',
    '#mic',
    '',
    '# PMCD pmda status',
    'pmcd.agent.status',
  ]

  $supremm_pcp_environ_metrics = [
    'hotproc.psinfo.environ',
  ]

  $supremm_pcp_hotproc_exclude_users = [
    'root',
    'rpc',
    'rpcuser',
    'dbus',
    'avahi',
    'munge',
    'ntp',
    'nagios',
    'zabbix',
    'postfix',
    'pcp',
    'libstoragemgmt',
    'chrony',
    'polkitd',
    'haldaemon',
    'nobody',
    'ganglia',
  ]
}
