require 'beaker-rspec'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each {|f| require f}

install_puppet_on(hosts, {:version => '3.8.3'})

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'xdmod')

    hosts.each do |host|
      on host, 'yum -y install git'
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apache'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-mysql'), { :acceptable_exit_codes => [0,1] }
      # Temporary until >= 0.12.0 is available
      #on host, puppet('module', 'install', 'puppetlabs-mongodb'), { :acceptable_exit_codes => [0,1] }
      on host, '[ -d /etc/puppet/modules/mongodb ] || git clone https://github.com/puppetlabs/puppetlabs-mongodb.git /etc/puppet/modules/mongodb'
      on host, 'cd /etc/puppet/modules/mongodb && git reset --hard 3bcfc75'
      on host, puppet('module', 'install', 'stahnma-epel'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'rodjek-logrotate'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'nanliu-staging'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'herculesteam-augeasproviders_shellvar'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'saz-sudo'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'treydock-pcp'), { :acceptable_exit_codes => [0,1] }

      host_pp = <<-EOS
        host { 'web': ip => '#{find_only_one(:web).ip}' }
        host { 'db': ip => '#{find_only_one(:db).ip}' }
        host { 'akrr': ip => '#{find_only_one(:akrr).ip}' }
      EOS
      apply_manifest_on(host, host_pp, :catch_failures => true)
      on host, puppet('resource service iptables ensure=stopped'), { :acceptable_exit_codes => [0,1] }
    end

    apply_manifest_on(find_only_one(:web), "host { 'xdmod.localdomain': ip => '127.0.0.1' }", :catch_failures => true)
  end

  c.before(:all) do
    @web_ip ||= find_only_one(:web).ip
    @db_ip ||= find_only_one(:db).ip
    @akrr_ip ||= find_only_one(:akrr).ip
  end
end
