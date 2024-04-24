# frozen_string_literal: true

shared_examples_for 'xdmod::supremm::config' do |_facts|
  it 'has valid JSON' do
    config = catalogue.resource('file', '/etc/supremm/config.json').send(:parameters)[:content]
    expect { JSON.parse(config) }.not_to raise_error
  end

  context 'with prometheus parameters' do
    let(:params) do
      default_params.merge(
        supremm_cron_index_archives: false,
        supremm_resources: [
          {
            resource: 'test',
            resource_id: 1,
            enabled: true,
            datasource: 'prometheus',
            hardware: { gpfs: 'ess', network: 'em1' },
            batchscript: { path: '/scripts', timestamp_mode: 'start' },
            prom_host: 'foo.example.com:9090'
          }
        ],
      )
    end

    it 'has valid JSON' do
      config = catalogue.resource('file', '/etc/supremm/config.json').send(:parameters)[:content]
      puts "CONFIG: #{config}"
      expect { JSON.parse(config) }.not_to raise_error
    end
  end
end
