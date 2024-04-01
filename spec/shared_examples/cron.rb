# frozen_string_literal: true

shared_examples_for 'xdmod::cron' do |_facts|
  it do
    is_expected.to contain_file('/usr/local/bin/xdmod-cron.sh').with(
      ensure: 'file',
      owner: 'root',
      group: 'root',
      mode: '0755',
    )
  end

  it 'does not collect supremm' do
    is_expected.to contain_file('/usr/local/bin/xdmod-cron.sh').without_content(%r{supremm})
  end

  it do
    is_expected.to contain_file('/etc/cron.d/xdmod').with(
      ensure: 'file',
      owner: 'root',
      group: 'root',
      mode: '0644',
    )
  end

  it do
    verify_contents(catalogue, '/etc/cron.d/xdmod', [
                      '1 0 * * * xdmod /usr/local/bin/xdmod-cron.sh'
                    ])
  end

  it { is_expected.to contain_file('/etc/cron.d/xdmod-storage').with_ensure('absent') }
  it { is_expected.to contain_file('/etc/cron.d/xdmod-ondemand').with_ensure('absent') }
  it { is_expected.to contain_file('/etc/cron.d/supremm').with_ensure('absent') }

  context 'when resources defined' do
    let(:params) do
      {
        resources: [
          { 'resource' => 'example', 'name' => 'Example' }
        ]
      }
    end

    it do
      verify_contents(catalogue, '/usr/local/bin/xdmod-cron.sh', [
                        '/usr/bin/xdmod-slurm-helper --quiet -r example',
                        '/usr/bin/xdmod-ingestor --quiet 2>&1 | logger -t xdmod-ingestor'
                      ])
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
      verify_contents(catalogue, '/usr/local/bin/xdmod-cron.sh', [
                        '/usr/bin/xdmod-slurm-helper --quiet -r example1',
                        '/usr/bin/xdmod-slurm-helper --quiet -r example2',
                        '/usr/bin/xdmod-ingestor --quiet 2>&1 | logger -t xdmod-ingestor'
                      ])
    end
  end

  context 'when shredder_command defined as String' do
    let(:params) do
      {
        shredder_command: '/usr/bin/xdmod-slurm-helper --quiet -r example'
      }
    end

    it do
      verify_contents(catalogue, '/usr/local/bin/xdmod-cron.sh', [
                        '/usr/bin/xdmod-slurm-helper --quiet -r example',
                        '/usr/bin/xdmod-ingestor --quiet 2>&1 | logger -t xdmod-ingestor'
                      ])
    end
  end

  context 'when shredder_command defined as Array' do
    let(:params) do
      {
        shredder_command: [
          '/usr/bin/xdmod-slurm-helper --quiet -r example1',
          '/usr/bin/xdmod-slurm-helper --quiet -r example2'
        ]
      }
    end

    it do
      verify_contents(catalogue, '/usr/local/bin/xdmod-cron.sh', [
                        '/usr/bin/xdmod-slurm-helper --quiet -r example1',
                        '/usr/bin/xdmod-slurm-helper --quiet -r example2',
                        '/usr/bin/xdmod-ingestor --quiet 2>&1 | logger -t xdmod-ingestor'
                      ])
    end
  end

  context 'when supremm enabled' do
    let(:params) do
      {
        supremm: true
      }
    end

    it 'generates cron entry for summarize jobs' do
      is_expected.to contain_file('/usr/local/bin/xdmod-cron.sh').with_content(%r{/usr/bin/supremm_update 2>&1 | logger -t supremm_update})
    end

    context 'when supremm_cron_index_archives => false' do
      let(:params) do
        {
          supremm: true,
          supremm_cron_index_archives: false
        }
      end

      it 'generates cron entry for summarize jobs' do
        is_expected.to contain_file('/usr/local/bin/xdmod-cron.sh').with_content(%r{/usr/bin/summarize_jobs.py -t 1 -q 2>&1 | logger -t supremm_update})
      end
    end
  end
end
