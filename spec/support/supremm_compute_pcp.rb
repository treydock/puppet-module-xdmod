shared_examples_for 'xdmod::supremm::compute::pcp' do |facts|

  it do
    should contain_pcp__pmda('proc').with({
      :has_package    => 'false',
      :config_path    => '/var/lib/pcp/pmdas/proc/hotproc.conf',
    })
  end

  it do
    config_content = catalogue.resource('pcp::pmda', 'proc').send(:parameters)[:config_content]
    expect(config_content).to match(/( (uname != "root") && (uname != "rpc") && (uname != "rpcuser") && (uname != "dbus") && (uname != "avahi") && (uname != "munge") && (uname != "ntp") && (uname != "nagios") && (uname != "zabbix") && (uname != "postfix") && (uname != "pcp") && (uname != "libstoragemgmt") && (uname != "chrony") && (uname != "polkitd") && (uname != "haldaemon") ) || cpuburn > 0.1/)
  end

end
