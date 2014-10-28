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
    it { should contain_xdmod_portal_setting("#{section}/pass").with_value('changeme') }
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
    should contain_file('/etc/xdmod/hierarchy.csv').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :notify  => 'Exec[xdmod-import-csv-hierarchy]',
    })
  end

  it do
    verify_exact_contents(catalogue, '/etc/xdmod/hierarchy.csv', [])
  end

  it do
    should contain_exec('xdmod-import-csv-hierarchy').with({
      :path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      :command     => 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
      :refreshonly => 'true',
    })
  end

  it do
    should contain_file('/etc/xdmod/group-to-hierarchy.csv').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :notify  => 'Exec[xdmod-import-csv-group-to-hierarchy]',
    })
  end

  it do
    verify_exact_contents(catalogue, '/etc/xdmod/group-to-hierarchy.csv', [])
  end

  it do
    should contain_exec('xdmod-import-csv-group-to-hierarchy').with({
      :path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      :command     => 'xdmod-import-csv -t group-to-hierarchy -i /etc/xdmod/group-to-hierarchy.csv',
      :refreshonly => 'true',
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

  context 'when hierarchies defined' do
    let(:params) do
      {
        :hierarchies => [
          'ou1,Unit 1,',
          '"ou2","Unit 2",""',
          'div1,Division 1,ou1',
          '"div2","Division 2","ou2"',
          'dept1,Department 1,div1',
          '"dept2","Department 2","div2"',
        ]
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/hierarchy.csv', [
        '"ou1","Unit 1",""',
        '"ou2","Unit 2",""',
        '"div1","Division 1","ou1"',
        '"div2","Division 2","ou2"',
        '"dept1","Department 1","div1"',
        '"dept2","Department 2","div2"',
      ])
    end
  end

  context 'when group_to_hierarchy defined' do
    let(:params) do
      {
        :group_to_hierarchy => {
          'group1' => 'dept1',
          'group2' => 'dept1',
          'group3' => 'dept2',
        }
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/group-to-hierarchy.csv', [
        '"group1","dept1"',
        '"group2","dept1"',
        '"group3","dept2"',
      ])
    end
  end
end
