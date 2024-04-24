# frozen_string_literal: true

shared_examples_for 'xdmod::config' do |_facts|
  [
    'logger',
    'database',
    'datawarehouse',
    'shredder',
    'hpcdb'
  ].each do |section|
    it do
      is_expected.to contain_xdmod_portal_setting("#{section}/host").with(value: '127.0.0.1',
                                                                          before: [
                                                                            'File[/etc/xdmod/hierarchy.csv]',
                                                                            'File[/etc/xdmod/group-to-hierarchy.csv]',
                                                                            'File[/etc/xdmod/names.csv]',
                                                                            'Exec[etl-bootstrap]',
                                                                            'Exec[etl-bootstrap-supremm]',
                                                                            'Exec[acl-config]'
                                                                          ])
    end

    it do
      is_expected.to contain_xdmod_portal_setting("#{section}/port").with(value: '3306',
                                                                          before: [
                                                                            'File[/etc/xdmod/hierarchy.csv]',
                                                                            'File[/etc/xdmod/group-to-hierarchy.csv]',
                                                                            'File[/etc/xdmod/names.csv]',
                                                                            'Exec[etl-bootstrap]',
                                                                            'Exec[etl-bootstrap-supremm]',
                                                                            'Exec[acl-config]'
                                                                          ])
    end

    it do
      is_expected.to contain_xdmod_portal_setting("#{section}/user").with(value: 'xdmod',
                                                                          before: [
                                                                            'File[/etc/xdmod/hierarchy.csv]',
                                                                            'File[/etc/xdmod/group-to-hierarchy.csv]',
                                                                            'File[/etc/xdmod/names.csv]',
                                                                            'Exec[etl-bootstrap]',
                                                                            'Exec[etl-bootstrap-supremm]',
                                                                            'Exec[acl-config]'
                                                                          ])
    end

    it do
      is_expected.to contain_xdmod_portal_setting("#{section}/pass").with(value: 'changeme',
                                                                          secret: 'true',
                                                                          before: [
                                                                            'File[/etc/xdmod/hierarchy.csv]',
                                                                            'File[/etc/xdmod/group-to-hierarchy.csv]',
                                                                            'File[/etc/xdmod/names.csv]',
                                                                            'Exec[etl-bootstrap]',
                                                                            'Exec[etl-bootstrap-supremm]',
                                                                            'Exec[acl-config]'
                                                                          ])
    end
  end

  it { is_expected.to contain_xdmod_portal_setting('features/appkernels').with_value('off') }
  it { is_expected.to contain_xdmod_portal_setting('cors/domains').with_value('') }
  it { is_expected.not_to contain_file('/etc/xdmod/portal_settings.d/appkernels.ini') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('features/appkernels') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('appkernel/host') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('appkernel/port') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('appkernel/user') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('appkernel/pass') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr-db/host') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr-db/port') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr-db/user') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr-db/pass') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr/host') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr/port') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr/username') }
  it { is_expected.not_to contain_xdmod_appkernel_setting('akrr/password') }
  it { is_expected.not_to contain_file('/etc/cron.d/xdmod-appkernels') }

  it do
    is_expected.to contain_file('/etc/xdmod/portal_settings.ini').with(ensure: 'file',
                                                                       owner: 'apache',
                                                                       group: 'xdmod',
                                                                       mode: '0440')
  end

  it do
    is_expected.to contain_file('/etc/xdmod/hierarchy.json').with(ensure: 'file',
                                                                  owner: 'root',
                                                                  group: 'root',
                                                                  mode: '0644')
  end

  it { is_expected.to contain_file_line('etl_overseer-db-log') }

  it do
    expected_cmd = [
      '/usr/share/xdmod/tools/etl/etl_overseer.php',
      '-p supremm.bootstrap', '-p jobefficiency.bootstrap'
    ]
    is_expected.to contain_exec('etl-bootstrap-supremm').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: expected_cmd.join(' '),
      logoutput: true,
      refreshonly: true,
      notify: 'Exec[acl-config]',
    )
  end

  it do
    expected_cmd = [
      '/usr/share/xdmod/tools/etl/etl_overseer.php',
      '-p xdb-bootstrap', '-p jobs-xdw-bootstrap', '-p xdw-bootstrap-storage',
      '-p shredder-bootstrap', '-p staging-bootstrap', '-p hpcdb-bootstrap',
      '-p acls-xdmod-management', '-p logger-bootstrap'
    ]
    is_expected.to contain_exec('etl-bootstrap').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: expected_cmd.join(' '),
      logoutput: true,
      refreshonly: true,
      notify: 'Exec[acl-config]',
    )
  end

  it do
    is_expected.to contain_exec('acl-config').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: '/usr/bin/acl-config',
      logoutput: true,
      refreshonly: true,
    )
  end

  it do
    verify_exact_contents(catalogue, '/etc/xdmod/hierarchy.json', [
                            '{',
                            '  "top_level_label": "Hierarchy Top Level",',
                            '  "top_level_info": "",',
                            '  "middle_level_label": "Hierarchy Middle Level",',
                            '  "middle_level_info": "",',
                            '  "bottom_level_label": "Hierarchy Bottom Level",',
                            '  "bottom_level_info": ""',
                            '}'
                          ])
  end

  it do
    is_expected.to contain_file('/etc/xdmod/hierarchy.csv').with(ensure: 'file',
                                                                 owner: 'xdmod',
                                                                 group: 'root',
                                                                 mode: '0644',
                                                                 content: nil)
  end

  it do
    is_expected.not_to contain_exec('xdmod-import-csv-hierarchy')
  end

  it do
    is_expected.to contain_file('/etc/xdmod/group-to-hierarchy.csv').with(ensure: 'file',
                                                                          owner: 'xdmod',
                                                                          group: 'root',
                                                                          mode: '0644',
                                                                          content: nil)
  end

  it do
    is_expected.not_to contain_exec('xdmod-import-csv-group-to-hierarchy')
  end

  it do
    is_expected.to contain_file('/etc/xdmod/names.csv').with(ensure: 'file',
                                                             owner: 'xdmod',
                                                             group: 'root',
                                                             mode: '0644',
                                                             content: nil)
  end

  it do
    is_expected.not_to contain_exec('xdmod-import-csv-names')
  end

  it { is_expected.to contain_file('/etc/xdmod/roles.d/storage.json').with_ensure('absent') }
  it { is_expected.to contain_file('/usr/local/bin/xdmod-storage-ingest.sh').with_ensure('absent') }

  it do
    is_expected.to contain_logrotate__rule('xdmod').with(ensure: 'present',
                                                         path: ['/var/log/xdmod/query.log', '/var/log/xdmod/exceptions.log'],
                                                         su_user: 'apache',
                                                         su_group: 'xdmod',
                                                         create: 'true',
                                                         create_mode: '0660',
                                                         create_owner: 'apache',
                                                         create_group: 'xdmod',
                                                         rotate: '4',
                                                         rotate_every: 'week',
                                                         missingok: 'true',
                                                         compress: 'true',
                                                         dateext: 'true')
  end

  it do
    is_expected.to contain_logrotate__rule('xdmod-session_manager').with(ensure: 'present',
                                                                         path: '/var/log/xdmod/session_manager.log',
                                                                         su_user: 'apache',
                                                                         su_group: 'apache',
                                                                         create: 'true',
                                                                         create_mode: '0640',
                                                                         create_owner: 'apache',
                                                                         create_group: 'apache',
                                                                         rotate: '4',
                                                                         rotate_every: 'week',
                                                                         missingok: 'true',
                                                                         compress: 'true',
                                                                         dateext: 'true')
  end

  context 'when php_timezone defined' do
    let(:params) { { php_timezone: 'America/New_York' } }

    it { is_expected.to contain_ini_setting('php-timezone').with_value('America/New_York') }
  end

  context 'when cors_domains defined' do
    let(:params) { { cors_domains: ['foo.example.com', 'bar.example.com'] } }

    it { is_expected.to contain_xdmod_portal_setting('cors/domains').with_value('foo.example.com,bar.example.com') }
  end

  context 'when resources defined' do
    let(:params) do
      {
        resources: [
          { 'resource' => 'example', 'name' => 'Example' }
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [{
        'resource' => 'example',
        'resource_type' => 'HPC',
        'name' => 'Example',
        'pi_column' => 'account_name'
      }]
      expect(value).to eq(expected)
    end
  end

  context 'when multiple resources defined' do
    let(:params) do
      {
        resources: [
          { 'resource' => 'example1', 'name' => 'Example1' },
          { 'resource' => 'example2', 'name' => 'Example2' }
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [
        {
          'resource' => 'example1',
          'resource_type' => 'HPC',
          'name' => 'Example1',
          'pi_column' => 'account_name'
        },
        {
          'resource' => 'example2',
          'resource_type' => 'HPC',
          'name' => 'Example2',
          'pi_column' => 'account_name'
        }
      ]
      expect(value).to eq(expected)
    end
  end

  context 'when resource_specs defined' do
    let(:params) do
      {
        resource_specs: [
          { 'resource' => 'example', 'processors' => 2, 'nodes' => 1, 'ppn' => 2 }
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resource_specs.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [
        'resource' => 'example',
        'processors' => 2,
        'nodes' => 1,
        'ppn' => 2
      ]
      expect(value).to eq(expected)
    end
  end

  context 'when enable_appkernel => true' do
    let(:params) { { enable_appkernel: true } }

    it { is_expected.to contain_xdmod_portal_setting('features/appkernels').with_value('on') }

    it do
      is_expected.to contain_file('/etc/xdmod/portal_settings.d/appkernels.ini').with(ensure: 'file',
                                                                                      owner: 'xdmod',
                                                                                      group: 'apache',
                                                                                      mode: '0640')
    end

    it { is_expected.to contain_xdmod_appkernel_setting('features/appkernels').with_value('on') }
    it { is_expected.to contain_xdmod_appkernel_setting('appkernel/host').with_value('127.0.0.1') }
    it { is_expected.to contain_xdmod_appkernel_setting('appkernel/port').with_value('3306') }
    it { is_expected.to contain_xdmod_appkernel_setting('appkernel/user').with_value('akrr') }
    it { is_expected.to contain_xdmod_appkernel_setting('appkernel/pass').with_value('changeme').with_secret('true') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr-db/host').with_value('127.0.0.1') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr-db/port').with_value('3306') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr-db/user').with_value('akrr') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr-db/pass').with_value('changeme').with_secret('true') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr/host').with_value('localhost') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr/port').with_value('8091') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr/username').with_value('rw') }
    it { is_expected.to contain_xdmod_appkernel_setting('akrr/password').with_value(%r{.*}).with_secret('true') }

    it do
      is_expected.to contain_file('/etc/cron.d/xdmod-appkernels').with(ensure: 'file',
                                                                       owner: 'root',
                                                                       group: 'root',
                                                                       mode: '0644')
    end
  end

  context 'when enable_supremm => true' do
    let(:params) do
      {
        enable_supremm: true,
        supremm_resources: [{ 'resource' => 'example', 'resource_id' => 1, 'pcp_log_dir' => '/dne' }]
      }
    end

    it do
      is_expected.to contain_file('/etc/xdmod/portal_settings.d/supremm.ini')
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/supremm_resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = {
        'resources' => [
          'resource' => 'example',
          'resource_id' => 1,
          'enabled' => true,
          'datasetmap' => 'pcp',
          'hardware' => { 'gpfs' => '' }
        ]
      }
      expect(value).to eq(expected)
    end

    context 'with supremm resource using datasetmap_source' do
      let(:params) do
        {
          enable_supremm: true,
          supremm_resources: [
            { 'resource' => 'example', 'resource_id' => 1, 'pcp_log_dir' => '/dne', 'datasetmap_source' => 'puppet:///modules/site/pcp-test.js' },
            { 'resource' => 'foo', 'resource_id' => 2, 'pcp_log_dir' => '/dne', 'datasetmap_source' => 'puppet:///modules/site/pcp-test.js' }
          ]
        }
      end

      it do
        is_expected.to contain_file('/usr/share/xdmod/etl/js/config/supremm/dataset_maps/pcp-test.js').with(
          'ensure' => 'file',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
          'source' => 'puppet:///modules/site/pcp-test.js',
        )
      end

      it do
        content = catalogue.resource('file', '/etc/xdmod/supremm_resources.json').send(:parameters)[:content]
        value = JSON.parse(content)
        expected = {
          'resources' => [
            {
              'resource' => 'example',
              'resource_id' => 1,
              'enabled' => true,
              'datasetmap' => 'pcp-test',
              'hardware' => { 'gpfs' => '' }
            },
            {
              'resource' => 'foo',
              'resource_id' => 2,
              'enabled' => true,
              'datasetmap' => 'pcp-test',
              'hardware' => { 'gpfs' => '' }
            }
          ]
        }
        expect(value).to eq(expected)
      end
    end
  end

  context 'with partial hierarchy levels defined' do
    let(:params) do
      {
        hierarchy_levels: {
          'top' => { 'label' => 'Top', 'info' => 'Top' },
          'middle' => { 'label' => 'Middle', 'info' => 'Middle' }
        }
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/hierarchy.json', [
                              '{',
                              '  "top_level_label": "Top",',
                              '  "top_level_info": "Top",',
                              '  "middle_level_label": "Middle",',
                              '  "middle_level_info": "Middle",',
                              '  "bottom_level_label": "Hierarchy Bottom Level",',
                              '  "bottom_level_info": ""',
                              '}'
                            ])
    end
  end

  context 'when hierarchies defined' do
    let(:params) do
      {
        hierarchies: [
          'ou1,Unit 1,',
          '"ou2","Unit 2",""',
          'div1,Division 1,ou1',
          '"div2","Division 2","ou2"',
          'dept1,Department 1,div1',
          '"dept2","Department 2","div2"'
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
                              '"dept2","Department 2","div2"'
                            ])
    end

    it do
      is_expected.to contain_exec('xdmod-import-csv-hierarchy').with(path: '/sbin:/bin:/usr/sbin:/usr/bin',
                                                                     command: 'xdmod-import-csv -t hierarchy -i /etc/xdmod/hierarchy.csv',
                                                                     refreshonly: 'true',
                                                                     subscribe: 'File[/etc/xdmod/hierarchy.csv]')
    end

    context 'when group_to_hierarchy defined' do
      let(:params) do
        {
          hierarchies: [
            'ou1,Unit 1,',
            '"ou2","Unit 2",""',
            'div1,Division 1,ou1',
            '"div2","Division 2","ou2"',
            'dept1,Department 1,div1',
            '"dept2","Department 2","div2"'
          ],
          group_to_hierarchy: {
            'group1' => 'dept1',
            'group2' => 'dept1',
            'group3' => 'dept2'
          }
        }
      end

      it { is_expected.to contain_exec('xdmod-import-csv-hierarchy').that_comes_before('Exec[xdmod-import-csv-group-to-hierarchy]') }
    end
  end

  context 'when group_to_hierarchy defined' do
    let(:params) do
      {
        group_to_hierarchy: {
          'group1' => 'dept1',
          'group2' => 'dept1',
          'group3' => 'dept2'
        }
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/group-to-hierarchy.csv', [
                              '"group1","dept1"',
                              '"group2","dept1"',
                              '"group3","dept2"'
                            ])
    end

    it do
      is_expected.to contain_exec('xdmod-import-csv-group-to-hierarchy').with(path: '/sbin:/bin:/usr/sbin:/usr/bin',
                                                                              command: 'xdmod-import-csv -t group-to-hierarchy -i /etc/xdmod/group-to-hierarchy.csv',
                                                                              refreshonly: 'true',
                                                                              subscribe: 'File[/etc/xdmod/group-to-hierarchy.csv]')
    end
  end

  context 'when user_pi_names defined' do
    let(:params) do
      {
        user_pi_names: [
          'jdoe,John,Doe',
          'mygroup,,"My Group"'
        ]
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/xdmod/names.csv', [
                              'jdoe,John,Doe',
                              'mygroup,,"My Group"'
                            ])
    end

    it do
      is_expected.to contain_exec('xdmod-import-csv-names').with(path: '/sbin:/bin:/usr/sbin:/usr/bin',
                                                                 command: 'xdmod-import-csv -t names -i /etc/xdmod/names.csv',
                                                                 refreshonly: 'true',
                                                                 subscribe: 'File[/etc/xdmod/names.csv]')
    end
  end

  context 'when storage resources defined' do
    let(:params) do
      {
        resources: [
          { resource: 'home', name: 'Home', resource_type: 'Disk', shred_directory: '/shared/quotas/home' }
        ]
      }
    end

    it { is_expected.to contain_file('/etc/xdmod/roles.d/storage.json').with_ensure('file') }
    it { is_expected.to contain_file('/usr/local/bin/xdmod-storage-ingest.sh').with_ensure('file') }

    it 'has storage ingest contents' do
      verify_contents(catalogue, '/usr/local/bin/xdmod-storage-ingest.sh', [
                        '  xdmod-shredder -f storage -r home -d /shared/quotas/home'
                      ])
    end
  end

  context 'when ondemand resources defined' do
    let(:params) do
      {
        resources: [
          { 'resource' => 'ondemand', 'name' => 'OnDemand', 'resource_type' => 'Gateway' }
        ],
        resource_specs: [
          { 'resource' => 'example', 'processors' => 2, 'nodes' => 1, 'ppn' => 2 }
        ]
      }
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resources.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [{
        'resource' => 'ondemand',
        'resource_type' => 'Gateway',
        'name' => 'OnDemand'
      }]
      expect(value).to eq(expected)
    end

    it do
      content = catalogue.resource('file', '/etc/xdmod/resource_specs.json').send(:parameters)[:content]
      value = JSON.parse(content)
      expected = [{
        'resource' => 'example',
        'processors' => 2,
        'nodes' => 1,
        'ppn' => 2
      },
                  {
                    'resource' => 'ondemand',
                    'processors' => 1,
                    'nodes' => 1,
                    'ppn' => 1
                  }]
      expect(value).to eq(expected)
    end
  end
end
