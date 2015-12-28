shared_examples_for 'xdmod::database' do |facts|
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
  end

  it { should contain_mysql__db('mod_hpcdb').with_sql(['/usr/share/xdmod/db/schema/mod_hpcdb.sql', '/usr/share/xdmod/db/data/mod_hpcdb.sql']) }
  it { should contain_mysql__db('mod_logger').with_sql(['/usr/share/xdmod/db/schema/mod_logger.sql', '/usr/share/xdmod/db/data/mod_logger.sql']) }
  it { should contain_mysql__db('mod_shredder').with_sql(['/usr/share/xdmod/db/schema/mod_shredder.sql', '/usr/share/xdmod/db/data/mod_shredder.sql']) }
  it { should contain_mysql__db('moddb').with_sql(['/usr/share/xdmod/db/schema/moddb.sql', '/usr/share/xdmod/db/data/moddb.sql']) }
  it { should contain_mysql__db('modw').with_sql(['/usr/share/xdmod/db/schema/modw.sql', '/usr/share/xdmod/db/data/modw.sql']) }
  it { should contain_mysql__db('modw_aggregates').with_sql('/usr/share/xdmod/db/schema/modw_aggregates.sql') }

  it { should_not contain_mysql__db('mod_appkernel') }
  it { should_not contain_mysql__db('mod_akrr') }
  it { should_not contain_mysql_grant('akrr@localhost/modw.resourcefact') }

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
        :require    => ['Mysql::Db[modw]', 'Mysql::Db[mod_akrr]'],
      })
    end
  end

  context 'when database_host => host.domain' do
    let(:params) {{ :database_host => 'host.domain' }}

    it { should contain_mysql__db('mod_hpcdb').without_sql }
    it { should contain_mysql__db('mod_logger').without_sql }
    it { should contain_mysql__db('mod_shredder').without_sql }
    it { should contain_mysql__db('moddb').without_sql }
    it { should contain_mysql__db('modw').without_sql }
    it { should contain_mysql__db('modw_aggregates').without_sql }
  end
end
