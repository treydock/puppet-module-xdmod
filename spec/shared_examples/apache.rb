# frozen_string_literal: true

shared_examples_for 'xdmod::apache' do |_facts|
  it { is_expected.to contain_class('apache') }
  it { is_expected.to contain_class('apache::mod::php') }

  it do
    is_expected.to contain_apache__vhost__custom('xdmod')
  end

  context 'when manage_apache_vhost => false' do
    let(:params) { { manage_apache_vhost: false } }

    it { is_expected.not_to contain_class('apache') }
    it { is_expected.not_to contain_apache__vhost__custom('xdmod') }
  end
end
