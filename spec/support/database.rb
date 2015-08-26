shared_examples_for 'xdmod::database' do
  [
    'mod_hpcdb',
    'mod_logger',
    'mod_shredder',
    'moddb',
    'modw',
    'modw_aggregates',
  ].each do |db|
    it "should create Mysql::Db[#{db}]" do
      should contain_mysql__db(db).with({
        :ensure       => 'present',
        :user         => 'xdmod',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'utf8',
        :collate      => 'utf8_general_ci',
        :grant        => ['ALL'],
      })
    end

    it { should_not contain_mysql__db('mod_appkernel') }
    it { should_not contain_mysql__db('mod_akrr') }
    it { should_not contain_mysql_grant('akrr@localhost/modw.resourcefact') }
  end

  context 'when enable_appkernel => true' do
    let(:params) {{ :enable_appkernel => true }}

    it do
      should contain_mysql__db('mod_appkernel').with({
        :ensure       => 'present',
        :user         => 'akrr',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'utf8',
        :collate      => 'utf8_general_ci',
        :grant        => ['ALL'],
      })
    end

    it do
      should contain_mysql__db('mod_appkernel').with({
        :ensure       => 'present',
        :user         => 'akrr',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'utf8',
        :collate      => 'utf8_general_ci',
        :grant        => ['ALL'],
      })
    end

    it do
      should contain_mysql_grant('akrr@localhost/modw.resourcefact').with({
        :ensure     => 'present',
        :privileges => ['SELECT'],
        :table      => 'modw.resourcefact',
        :user       => 'akrr@localhost',
        :require    => 'Mysql::Db[mod_akrr]',
      })
    end
  end
end
