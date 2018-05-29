shared_examples_for 'xdmod::supremm::compute::pcp' do |facts|

  it do
    should contain_pcp__pmlogger('supremm').with({
      :ensure       => 'present',
      :hostname     => 'LOCALHOSTNAME',
      :primary      => 'true',
      :socks        => 'false',
      :log_dir      => '/data/pcp-data/example/LOCALHOSTNAME',
      :args         => '-r',
      :config_path  => '/etc/pcp/pmlogger/pmlogger-supremm.config',
    })
  end

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

  context 'pcp_pmlogger_date_path => true' do
    let(:params) { default_params.merge({:pcp_pmlogger_path_suffix => '$(date +%Y/%m/%d)'}) }
    it do
      should contain_pcp__pmlogger('supremm').with_log_dir('/data/pcp-data/example/LOCALHOSTNAME/$(date +%Y/%m/%d)')
    end
  end

end
