collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'
RSpec.configure do |c|
  c.before :suite do
    on hosts, puppet('module', 'install', 'puppetlabs-yumrepo_core', '--version', '">= 1.0.1 < 2.0.0"'), acceptable_exit_codes: [0, 1]
    on hosts, puppet('module', 'install', 'puppetlabs-cron_core', '--version', '">= 1.0.0 < 2.0.0"'), acceptable_exit_codes: [0, 1]
    on hosts, 'puppet config set --section main show_diff true'
    on hosts, 'mkdir -p /etc/puppetlabs/facter/facts.d'
    create_remote_file(hosts, '/etc/puppetlabs/facter/facts.d/domain.txt', "domain=localdomain\n")
    # Hack to fix startup of mongod in docker
    create_remote_file(hosts, '/etc/sysconfig/mongod', "OPTIONS=\"--smallfiles --quiet -f /etc/mongod.conf\"\n")
  end
end
