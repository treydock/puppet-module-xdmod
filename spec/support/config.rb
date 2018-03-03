shared_examples_for "xdmod::config" do |facts|

  [
    'logger',
    'database',
    'datawarehouse',
    'shredder',
    'hpcdb',
  ].each do |section|
    it do
      should contain_xdmod_portal_setting("#{section}/host").with({
        :value  => 'localhost',
        :before => [
          'File[/etc/xdmod/hierarchy.csv]',
          'File[/etc/xdmod/group-to-hierarchy.csv]',
          'File[/etc/xdmod/names.csv]',
          'Exec[acl-xdmod-management]',
        ]
      })
    end
    it do
      should contain_xdmod_portal_setting("#{section}/port").with({
        :value  => '3306',
        :before => [
          'File[/etc/xdmod/hierarchy.csv]',
          'File[/etc/xdmod/group-to-hierarchy.csv]',
          'File[/etc/xdmod/names.csv]',
          'Exec[acl-xdmod-management]',
        ]
      })
    end
    it do
      should contain_xdmod_portal_setting("#{section}/user").with({
        :value  => 'xdmod',
        :before => [
          'File[/etc/xdmod/hierarchy.csv]',
          'File[/etc/xdmod/group-to-hierarchy.csv]',
          'File[/etc/xdmod/names.csv]',
          'Exec[acl-xdmod-management]',
        ]
      })
    end
    it do
      should contain_xdmod_portal_setting("#{section}/pass").with({
        :value  => 'changeme',
        :secret => 'true',
        :before => [
          'File[/etc/xdmod/hierarchy.csv]',
          'File[/etc/xdmod/group-to-hierarchy.csv]',
          'File[/etc/xdmod/names.csv]',
          'Exec[acl-xdmod-management]',
        ]
      })
    end
  end

  it { should contain_xdmod_portal_setting('features/appkernels').with_value('off') }
  it { should contain_xdmod_portal_setting('reporting/java_path').with_value('/usr/bin/java') }
  it { should_not contain_file('/etc/xdmod/portal_settings.d/appkernels.ini') }
  it { should_not contain_xdmod_appkernel_setting('features/appkernels') }
  it { should_not contain_xdmod_appkernel_setting('appkernel/host') }
  it { should_not contain_xdmod_appkernel_setting('appkernel/port') }
  it { should_not contain_xdmod_appkernel_setting('appkernel/user') }
  it { should_not contain_xdmod_appkernel_setting('appkernel/pass') }
  it { should_not contain_xdmod_appkernel_setting('akrr-db/host') }
  it { should_not contain_xdmod_appkernel_setting('akrr-db/port') }
  it { should_not contain_xdmod_appkernel_setting('akrr-db/user') }
  it { should_not contain_xdmod_appkernel_setting('akrr-db/pass') }
  it { should_not contain_xdmod_appkernel_setting('akrr/host') }
  it { should_not contain_xdmod_appkernel_setting('akrr/port') }
  it { should_not contain_xdmod_appkernel_setting('akrr/username') }
  it { should_not contain_xdmod_appkernel_setting('akrr/password') }
  it { should_not contain_file('/etc/cron.d/xdmod-appkernels') }

  it do
    should contain_file('/etc/xdmod/portal_settings.ini').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    should contain_file('/etc/xdmod/hierarchy.json').with({
      :ensure   => 'file',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_exact_contents(catalogue, '/etc/xdmod/hierarchy.json', [
      '{',
      '    "top_level_label": "Hierarchy Top Level",',
      '    "top_level_info": "",',
      '    "middle_level_label": "Hierarchy Middle Level",',
      '    "middle_level_info": "",',
      '    "bottom_level_label": "Hierarchy Bottom Level",',
      '    "bottom_level_info": ""',
      '}',
    ])
  end

  it do
    should contain_file('/etc/xdmod/hierarchy.csv').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :content => nil,
    })
  end

  it do
    should_not contain_exec('xdmod-import-csv-hierarchy')
  end

  it do
    should contain_file('/etc/xdmod/group-to-hierarchy.csv').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :content => nil,
    })
  end

  it do
    should_not contain_exec('xdmod-import-csv-group-to-hierarchy')
  end

  it do
    should contain_file('/etc/xdmod/names.csv').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :content => nil,
    })
  end

  it do
    should_not contain_exec('xdmod-import-csv-names')
  end

  it do
    should contain_file('/etc/xdmod/portal_settings.ini').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it { should_not contain_file('/root/xdmod-database-setup.sh') }
  it { should_not contain_exec('xdmod-database-setup.sh') }


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
      '0 3 * * * xdmod /usr/bin/php /usr/lib64/xdmod/report_schedule_manager.php >/dev/null',
      '# Shred and ingest:',
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

  context 'when resources defined' do
    let(:params) do
      {
        :resources => [
          {'resource' => 'example', 'name' => 'Example'}
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [{
        "resource" => "example",
        "resource_type_id" => 1,
        "name" => "Example",
        "pi_column" => "account_name",
      }]
      expect(value).to eq(expected)
    end

    it do
      verify_contents(catalogue, '/etc/cron.d/xdmod', [
        '# Every morning at 3:00 AM -- run the report scheduler',
        '0 3 * * * xdmod /usr/bin/php /usr/lib64/xdmod/report_schedule_manager.php >/dev/null',
        '# Shred and ingest:',
        '0 1 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example && /usr/bin/xdmod-ingestor --quiet'
      ])
    end
  end

  context 'when multiple resources defined' do
    let(:params) do
      {
        :resources => [
          {'resource' => 'example1', 'name' => 'Example1'},
          {'resource' => 'example2', 'name' => 'Example2'},
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [
        {
          "resource" => "example1",
          "resource_type_id" => 1,
          "name" => "Example1",
          "pi_column" => "account_name",
        },
        {
          "resource" => "example2",
          "resource_type_id" => 1,
          "name" => "Example2",
          "pi_column" => "account_name",
        },
      ]
      expect(value).to eq(expected)
    end

    it do
      verify_contents(catalogue, '/etc/cron.d/xdmod', [
        '# Every morning at 3:00 AM -- run the report scheduler',
        '0 3 * * * xdmod /usr/bin/php /usr/lib64/xdmod/report_schedule_manager.php >/dev/null',
        '# Shred and ingest:',
        '0 1 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example1 && /usr/bin/xdmod-ingestor --quiet',
        '0 2 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example2 && /usr/bin/xdmod-ingestor --quiet',
      ])
    end
  end

  context 'when resource_specs defined' do
    let(:params) do
      {
        :resource_specs => [
          {'resource' => 'example', 'processors' => 2, 'nodes' => 1, 'ppn' => 2}
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resource_specs.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [
        "resource" => "example",
        "processors" => 2,
        "nodes" => 1,
        "ppn" => 2,
      ]
      expect(value).to eq(expected)
    end
  end

  context 'when shredder_command defined as String' do
    let(:params) do
      {
        :shredder_command => '/usr/bin/xdmod-slurm-helper --quiet -r example'
      }
    end

    it do
      verify_contents(catalogue, '/etc/cron.d/xdmod', [
        '# Every morning at 3:00 AM -- run the report scheduler',
        '0 3 * * * xdmod /usr/bin/php /usr/lib64/xdmod/report_schedule_manager.php >/dev/null',
        '# Shred and ingest:',
        '0 1 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example && /usr/bin/xdmod-ingestor --quiet'
      ])
    end
  end

  context 'when shredder_command defined as Array' do
    let(:params) do
      {
        :shredder_command => [
          '/usr/bin/xdmod-slurm-helper --quiet -r example1',
          '/usr/bin/xdmod-slurm-helper --quiet -r example2',
        ]
      }
    end

    it do
      verify_contents(catalogue, '/etc/cron.d/xdmod', [
        '# Every morning at 3:00 AM -- run the report scheduler',
        '0 3 * * * xdmod /usr/bin/php /usr/lib64/xdmod/report_schedule_manager.php >/dev/null',
        '# Shred and ingest:',
        '0 1 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example1 && /usr/bin/xdmod-ingestor --quiet',
        '0 2 * * * xdmod /usr/bin/xdmod-slurm-helper --quiet -r example2 && /usr/bin/xdmod-ingestor --quiet',
      ])
    end
  end

  context 'when database_host => host.domain' do
    let(:params) {{ :database_host => 'host.domain' }}

    it do
      should contain_file('/root/xdmod-database-setup.sh').with({
        :ensure    => 'file',
        :owner     => 'root',
        :group     => 'root',
        :mode      => '0700',
        :show_diff => 'false',
      })
    end

    #TODO: Test content of /root/xdmod-database-setup.sh

    it do
      should contain_exec('xdmod-database-setup.sh').with({
        :path     => '/usr/bin:/bin:/usr/sbin:/sbin',
        :command  => '/root/xdmod-database-setup.sh && touch /etc/xdmod/.database-setup',
        :creates  => '/etc/xdmod/.database-setup',
      })
    end
  end

  context 'when enable_appkernel => true' do
    let(:params) {{ :enable_appkernel => true }}

    it { should contain_xdmod_portal_setting('features/appkernels').with_value('on') }

    it do
      should contain_file('/etc/xdmod/portal_settings.d/appkernels.ini').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      })
    end

    it { should contain_xdmod_appkernel_setting('features/appkernels').with_value('on') }
    it { should contain_xdmod_appkernel_setting('appkernel/host').with_value('localhost') }
    it { should contain_xdmod_appkernel_setting('appkernel/port').with_value('3306') }
    it { should contain_xdmod_appkernel_setting('appkernel/user').with_value('akrr') }
    it { should contain_xdmod_appkernel_setting('appkernel/pass').with_value('changeme').with_secret('true') }
    it { should contain_xdmod_appkernel_setting('akrr-db/host').with_value('localhost') }
    it { should contain_xdmod_appkernel_setting('akrr-db/port').with_value('3306') }
    it { should contain_xdmod_appkernel_setting('akrr-db/user').with_value('akrr') }
    it { should contain_xdmod_appkernel_setting('akrr-db/pass').with_value('changeme').with_secret('true') }
    it { should contain_xdmod_appkernel_setting('akrr/host').with_value('localhost') }
    it { should contain_xdmod_appkernel_setting('akrr/port').with_value('8091') }
    it { should contain_xdmod_appkernel_setting('akrr/username').with_value('rw') }
    it { should contain_xdmod_appkernel_setting('akrr/password').with_value(/.*/).with_secret('true') }

    it do
      should contain_file('/etc/cron.d/xdmod-appkernels').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      })
    end
  end

  context 'when enable_supremm => true' do
    let(:params) do
      {
        :enable_supremm => true,
        :supremm_resources => [{'resource' => 'example', 'resource_id' => 1, 'pcp_log_dir' => '/dne'}],
      }
    end

    it do
      is_expected.to contain_exec('xdmod-supremm-npm-install')
    end

    it do
      is_expected.to contain_file('/etc/xdmod/portal_settings.d/supremm.ini')
    end

    it do
      is_expected.to contain_xdmod_supremm_setting('features/singlejobviewer').with_value('on')
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/supremm_resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = {
        "resources" => [
          "resource"    => "example",
          "resource_id" => 1,
          "enabled"     => true,
          "datasetmap"  => "pcp",
          "hardware"    => {"gpfs" => ""},
        ]
      }
      expect(value).to eq(expected)
    end

    context 'when database_host => dbhost' do
      let(:params) {{ :enable_supremm => true, :database_host => 'dbhost' }}

      it do
        is_expected.to contain_exec('modw_supremm-schema').with({
          :command  => 'mysql -h dbhost -u xdmod -pchangeme -D modw_supremm < /usr/share/xdmod/db/schema/modw_supremm.sql',
          :onlyif   => "mysql -BN -h dbhost -u xdmod -pchangeme -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
          :unless   => "mysql -BN -h dbhost -u xdmod -pchangeme -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^jobstatus$'",
        })
      end

      it do
        is_expected.to contain_exec('modw_etl-schema').with({
          :command  => 'mysql -h dbhost -u xdmod -pchangeme -D modw_etl < /usr/share/xdmod/db/schema/modw_etl.sql',
          :onlyif   => [
            "mysql -h dbhost -u xdmod -pchangeme -BN -e 'SHOW DATABASES' | egrep -q '^modw_etl$'",
            "mysql -h dbhost -u xdmod -pchangeme -BN -e 'SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema=\"modw_etl\"' | egrep -q '^0$'",
          ],
        })
      end
    end
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

    it do
      should contain_exec('xdmod-import-csv-hierarchy').with({
        :path        => '/sbin:/bin:/usr/sbin:/usr/bin',
        :command     => 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
        :refreshonly => 'true',
        :subscribe   => 'File[/etc/xdmod/hierarchy.csv]',
      })
    end

    context 'when group_to_hierarchy defined' do
      let(:params) do
        {
          :hierarchies => [
            'ou1,Unit 1,',
            '"ou2","Unit 2",""',
            'div1,Division 1,ou1',
            '"div2","Division 2","ou2"',
            'dept1,Department 1,div1',
            '"dept2","Department 2","div2"',
          ],
          :group_to_hierarchy => {
            'group1' => 'dept1',
            'group2' => 'dept1',
            'group3' => 'dept2',
          }
        }
      end
      it { should contain_exec('xdmod-import-csv-hierarchy').that_comes_before('Exec[xdmod-import-csv-group-to-hierarchy]') }
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

    it do
      should contain_exec('xdmod-import-csv-group-to-hierarchy').with({
        :path        => '/sbin:/bin:/usr/sbin:/usr/bin',
        :command     => 'xdmod-import-csv -t group-to-hierarchy -i /etc/xdmod/group-to-hierarchy.csv',
        :refreshonly => 'true',
        :subscribe   => 'File[/etc/xdmod/group-to-hierarchy.csv]',
      })
    end
  end

  context 'when user_pi_names defined' do
    let(:params) do
      {
        :user_pi_names => [
          'jdoe,John,Doe',
          'mygroup,,"My Group"',
        ]
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/names.csv', [
        'jdoe,John,Doe',
        'mygroup,,"My Group"',
      ])
    end

    it do
      should contain_exec('xdmod-import-csv-names').with({
        :path        => '/sbin:/bin:/usr/sbin:/usr/bin',
        :command     => 'xdmod-import-csv -t names -i /etc/xdmod/names.csv',
        :refreshonly => 'true',
        :subscribe   => 'File[/etc/xdmod/names.csv]',
      })
    end
  end
end
