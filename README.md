# puppet-module-xdmod

[![Build Status](https://travis-ci.org/treydock/puppet-module-xdmod.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-xdmod)

####Table of Contents

1. [Overview](#overview)
    * [Open XDMoD Compatibility](#open-xdmod-compatibility)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module will manage [Open XDMoD](http://xdmod.sourceforge.net/).  This module works best when paired with Hiera for defining parameter values.

This module is designed so that different hosts can run the various components of Open XDMoD.

### Open XDMoD Compatibility

Open XDMoD Versions         |  4.5.x   | 5.0.x   | 5.5.0       | >5.5.0      |
:---------------------------|:--------:|:-------:|:-----------:|:-----------:|
**puppet-module-xdmod 0.x** | **yes**  | no      | no          | **unknown** |
**puppet-module-xdmod 1.x** | no       | **yes** | no          | **unknown** |
**puppet-module-xdmod 2.x** | no       | **yes** | **yes**     | **unknown** |

## Usage

Examples of some hiera values that may be useful to set globally

    xdmod::version: '5.5.0'
    # Disable roles that are enabled by default
    xdmod::web: false
    xdmod::database: false
    # Define which features of XDMoD are enabled
    xdmod::enable_appkernel: true
    xdmod::enable_supremm: true
    # Set parameters used by multiple roles
    xdmod::resource_name: 'cluster-name-here'
    xdmod::web_host: 'ip-of-web-host'
    xdmod::akrr_host: 'ip-of-akrr-host'
    xdmod::database_password: 'xdmod-db-password-here'
    xdmod::database_host: 'dbhost.domain'
    xdmod::akrr_restapi_rw_password: 'some-password'
    xdmod::akrr_restapi_ro_password: 'some-password'
    xdmod::akrr_database_password: 'some-password'
    xdmod::supremm_mongodb_password: 'some-password'
    xdmod::supremm_mongodb_host: 'xdmod-mongodb-host'

If you run a local yum repo for XDMoD packages

    xdmod::create_local_repo: false
    xdmod::local_repo_name: 'local-repo-name-here'

Run the XDMoD web interface and AKRR web service with SUPReMM support

    classes:
      - 'xdmod'
    xdmod::web: true
    xdmod::akrr: true
    xdmod::database: false
    xdmod::enable_appkernel: true
    xdmod::enable_supremm: true
    xdmod::enable_update_check: false

Host the MySQL databases for XDMoD, AKRR and SUPReMM

    classes:
      - 'xdmod'
    xdmod::web: false
    xdmod::database: true

A compute node that will collect PCP data for SUPReMM.  The xdmod::supremm::compute::pcp class will declare the pcp class by default.  The metrics defined in `pcp_static_metrics` and `pcp_standard_metrics` will also define `pcp::pmda` resources based on which metrics are enabled.  See `xdmod::params` for some defaults.  The infiniband, perfevent, nvidia, gpfs, slurm, and mic metrics are commented out.

    classes:
      - 'xdmod'
    xdmod::web: false
    xdmod::database: false
    xdmod::compute: true
    xdmod::pcp_log_base_dir: '/data/supremm/pmlogger'
    xdmod::pcp_static_metrics:
      - 'metrics that don't change often go here'
      - '#comments can be defined too and will be present in config file as comments'
      - 'more static metrics'
    xdmod::pcp_standard_metrics:
      - 'metrics that change often like during a job'
      - '#comments can be defined too and will be present in config file as comments'
      - 'more standard metrics'

If you wish to use `include` style class declaration for the pcp class then the default pmlogger and pmie need to be removed and pmlogger_daily in cron needs to have modified arguments.

    classes:
      - 'xdmod'
    pcp::include_default_pmlogger: false
    pcp::include_default_pmie: false
    pcp::pmlogger_daily_args: '-M -k forever'
    xdmod::web: false
    xdmod::database: false
    xdmod::compute: true
    xdmod::pcp_declare_method: 'include'
    xdmod::pcp_log_base_dir: '/data/supremm/pmlogger'
    xdmod::pcp_static_metrics:
      - 'metrics that don't change often go here'
      - '#comments can be defined too and will be present in config file as comments'
      - 'more static metrics'
    xdmod::pcp_standard_metrics:
      - 'metrics that change often like during a job'
      - '#comments can be defined too and will be present in config file as comments'
      - 'more standard metrics'

A host that needs to run the SUPReMM job summarization and disable PCP that is a dependency of SUPReMM.

    classes:
      - 'pcp'
      - 'xdmod'
    pcp::ensure: 'stopped'
    xdmod::supremm:: true
    xdmod::job_scripts_dir: '/data/supremm/job_scripts'
    xdmod::pcp_log_base_dir: '/data/supremm/pmlogger'

A MongoDB host needs to be setup for SUPReMM

    classes:
      - 'xdmod'
    xdmod::web: false
    xdmod::database: false
    xdmod::supremm_database: true

## Reference

### Classes

#### Public classes

* `xdmod`: Installs and configures xdmod.

#### Private classes

* `xdmod::repo`: Creates local repo for XDMoD packages
* `xdmod::install`: Installs xdmod packages.
* `xdmod::database`: Manage XDMoD databases.
* `xdmod::config`: Configures xdmod.
* `xdmod::apache`: Manage Apache configurations.
* `xdmod::params`: Sets parameter defaults.
* `xdmod::akrr::user`: Create AKRR user and group
* `xdmod::akrr::install`: Install AKRR
* `xdmod::akrr::config`: Configure AKRR
* `xdmod::akrr::service`: Manage AKRR services
* `xdmod::supremm::install`: Install SUPReMM
* `xdmod::supremm::database`: Manage SUPReMM MongoDB database
* `xdmod::supremm::config`: Configure SUPReMM
* `xdmod::supremm::compute::pcp`: Configure compute PCP data collection

#### Class xdmod

TODO

## Limitations

This module has been tested on:

* CentOS 6

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

Docker based acceptance tests can also be run to test default behavior

    BEAKER_set=centos-6-x64-docker BEAKER_destroy=no bundle exec rake beaker

Docker acceptance tests can also be run to test full funtionality of multiple systems hosting various XDMoD components

    BEAKER_set=centos-6-x64-docker-multinode BEAKER_destroy=no bundle exec rake beaker_full
