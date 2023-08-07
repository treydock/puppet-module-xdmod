# frozen_string_literal: true

dir = __dir__
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def verify_exact_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  expect(content.split("\n").reject { |line| line =~ %r{(^$|^#)} }).to eq(expected_lines)
end

require 'rspec-puppet-facts'
include RspecPuppetFacts # rubocop:disable Style/MixinUsage

add_custom_fact :systemd_version, ->(os, _facts) {
  case os
  when %r{(redhat|centos|scientific)-7-x86_64}
    219
  when %r{(redhat|centos|scientific)-8-x86_64}
    239
  end
}
