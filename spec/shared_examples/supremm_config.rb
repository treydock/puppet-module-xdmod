shared_examples_for 'xdmod::supremm::config' do |_facts|
  it 'has valid JSON' do
    config = catalogue.resource('file', '/etc/supremm/config.json').send(:parameters)[:content]
    expect { JSON.parse(config) }.not_to raise_error
  end

  context 'prometheus parameters' do
    let(:params) do
      default_params.merge(
        supremm_prometheus_url: 'http://example.com:9090',
        supremm_prometheus_step: '1m',
        supremm_prometheus_rates: { 'gpfs' => '15m' },
      )
    end

    it 'has valid JSON' do
      config = catalogue.resource('file', '/etc/supremm/config.json').send(:parameters)[:content]
      expect { JSON.parse(config) }.not_to raise_error
      data = JSON.parse(config)
      expect(data['summary']['prometheus_url']).to eq('http://example.com:9090')
    end
  end
end
