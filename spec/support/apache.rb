shared_examples_for "xdmod::apache" do

  it { should contain_class('apache') }
  it { should contain_class('apache::mod::php') }

  it do
    puts catalogue.resource('concat::fragment', 'xdmod-apache-header').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-docroot').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-directories').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-logging').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-serversignature').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-access_log').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-redirect').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod-file_footer').send(:parameters)[:content]

    should contain_apache__vhost('xdmod').with({
      :servername     => 'xdmod.example.com',
      :port           => '80',
      :docroot        => '/usr/share/xdmod/html',
      :manage_docroot => 'false',
    })
  end

  it do
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-apache-header').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-docroot').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-directories').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-logging').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-serversignature').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-access_log').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-ssl').send(:parameters)[:content]
    puts catalogue.resource('concat::fragment', 'xdmod_ssl-file_footer').send(:parameters)[:content]

    should contain_apache__vhost('xdmod_ssl').with({
      :servername     => 'xdmod.example.com',
      :port           => '443',
      :ssl            => 'true',
      :docroot        => '/usr/share/xdmod/html',
      :manage_docroot => 'false',
    })
  end

  context 'when apache_ssl => false' do
    let(:params) {{ :apache_ssl => false }}

    it { should_not contain_apache__vhost('xdmod_ssl') }
  end

  context 'when manage_apache_vhost => false' do
    let(:params) {{ :manage_apache_vhost => false }}

    it { should_not contain_class('apache') }
    it { should_not contain_apache__vhost('xdmod_ssl') }
    it { should_not contain_apache__vhost('xdmod') }
  end
end
