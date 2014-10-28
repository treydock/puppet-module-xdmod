shared_examples_for "xdmod::apache" do

  it { should contain_class('apache') }

  it do
    should contain_apache__vhost('xdmod').with({
      :servername     => 'xdmod.example.com',
      :port           => '8080',
      :docroot        => '/usr/share/xdmod/html',
      :options        => ['FollowSymLinks'],
      :override       => ['All'],
      :directoryindex => 'index.php',
      :manage_docroot => 'false',
    })
  end

  context 'when manage_apache_vhost => false' do
    let(:params) {{ :manage_apache_vhost => false }}

    it { should_not contain_class('apache') }
    it { should_not contain_apache__vhost('xdmod.example.com') }
  end
end
