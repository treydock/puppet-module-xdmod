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
        :charset      => 'latin1',
        :collate      => 'latin1_swedish_ci',
        :grant        => ['ALL'],
      })
    end
  end

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
        :charset      => 'latin1',
        :collate      => 'latin1_swedish_ci',
        :grant        => ['ALL'],
      })
    end

    it do
      should contain_mysql__db('mod_akrr').with({
        :ensure       => 'present',
        :user         => 'akrr',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'latin1',
        :collate      => 'latin1_swedish_ci',
        :grant        => ['ALL'],
      })
    end

    it do
      should contain_mysql__db('modw-akrr').with({
        :ensure       => 'present',
        :dbname       => 'modw',
        :user         => 'akrr',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'latin1',
        :collate      => 'latin1_swedish_ci',
        :grant        => ['SELECT'],
      })
    end

    context 'when akrr_host != web_host' do
      let(:params) {{ :enable_appkernel => true, :akrr_host => 'foo' }}

      it { should contain_mysql__db('mod_appkernel').with_host('foo') }
      it { should contain_mysql__db('mod_akrr').with_host('foo') }
    end
  end
end
