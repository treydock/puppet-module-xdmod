shared_examples_for "xdmod::config" do

  [
    'logger',
    'database',
    'datawarehouse',
    'shredder',
    'hpcdb',
  ].each do |section|
    it { should contain_xdmod_portal_setting("#{section}/host").with_value('localhost') }
    it { should contain_xdmod_portal_setting("#{section}/port").with_value('3306') }
    it { should contain_xdmod_portal_setting("#{section}/user").with_value('xdmod') }
    it { should contain_xdmod_portal_setting("#{section}/password").with_value('changeme') }
  end

  it do
    should contain_file('/etc/xdmod/portal_settings.ini').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    should contain_file('/etc/cron.d/xdmod').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/cron.d/xdmod', [
      '# Every morning at 3:00 AM -- run the report scheduler',
      '0 3 * * * root /usr/bin/php /usr/lib/xdmod/report_schedule_manager.php >/dev/null',
      '# Shred and ingest:',
      '0 1 * * * root /usr/bin/xdmod-slurm-helper --quiet && /usr/bin/xdmod-ingestor --quiet',
    ])
  end

  it do
    should contain_logrotate__rule('xdmod').with({
      :ensure        => 'present',
      :path          => '/var/log/xdmod/*.log',
      :rotate        => '4',
      :rotate_every  => 'week',
      :missingok     => 'true',
      :compress      => 'true',
      :dateext       => 'true',
    })
  end
end
