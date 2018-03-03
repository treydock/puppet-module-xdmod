shared_examples_for "xdmod::user" do |facts|
  it do
    is_expected.to contain_group('xdmod').with(
      :ensure     => 'present',
      :name       => 'xdmod',
      :gid        => nil,
      :system     => 'true',
      :forcelocal => 'true',
    )
  end

  it do
    is_expected.to contain_user('xdmod').with(
      :ensure     => 'present',
      :name       => 'xdmod',
      :uid        => nil,
      :gid        => 'xdmod',
      :shell      => '/sbin/nologin',
      :home       => '/var/lib/xdmod',
      :managehome => 'false',
      :comment    => 'Open XDMoD',
      :system     => 'true',
      :forcelocal => 'true',
    )
  end

  context 'when user_uid and group_gid defined' do
    let(:params) {{ :user_uid => 100, :group_gid => 100 }}

    it { is_expected.to contain_group('xdmod').with_gid(100) }
    it { is_expected.to contain_user('xdmod').with_uid(100) }
  end
end
