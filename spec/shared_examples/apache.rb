shared_examples_for "xdmod::apache" do |facts|

  it { should contain_class('apache') }
  it { should contain_class('apache::mod::php') }

  it do
    should contain_apache__vhost__custom('xdmod')
  end

  context 'when manage_apache_vhost => false' do
    let(:params) {{ :manage_apache_vhost => false }}

    it { should_not contain_class('apache') }
    it { should_not contain_apache__vhost__custom('xdmod') }
  end
end
