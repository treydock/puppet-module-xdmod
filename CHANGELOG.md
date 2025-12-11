# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v11.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v11.0.0) (2024-10-14)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v10.1.0...v11.0.0)

### Changed

- Require stdlib 9.x [\#33](https://github.com/treydock/puppet-module-xdmod/pull/33) ([treydock](https://github.com/treydock))

## [v10.1.0](https://github.com/treydock/puppet-module-xdmod/tree/v10.1.0) (2024-08-09)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v10.0.0...v10.1.0)

### Added

- Allow 'collection' for SUPREMM resources [\#32](https://github.com/treydock/puppet-module-xdmod/pull/32) ([treydock](https://github.com/treydock))

## [v10.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v10.0.0) (2024-04-24)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v9.0.0...v10.0.0)

### Changed

- BREAKING: Support XDMOD 10.5 [\#31](https://github.com/treydock/puppet-module-xdmod/pull/31) ([treydock](https://github.com/treydock))

## [v9.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v9.0.0) (2023-08-11)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v8.0.0...v9.0.0)

### Changed

- Numerous updates - Drop Puppet 6, add Puppet 8, XDMOD 10.0.3 [\#30](https://github.com/treydock/puppet-module-xdmod/pull/30) ([treydock](https://github.com/treydock))

## [v8.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v8.0.0) (2022-03-24)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.5.1...v8.0.0)

### Changed

- Support XDMOD 10.0.0, support EL8 and bump module dependency ranges [\#29](https://github.com/treydock/puppet-module-xdmod/pull/29) ([treydock](https://github.com/treydock))

## [v7.5.1](https://github.com/treydock/puppet-module-xdmod/tree/v7.5.1) (2021-12-22)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.5.0...v7.5.1)

### Fixed

- Improve logging for xdmod-ingestor [\#27](https://github.com/treydock/puppet-module-xdmod/pull/27) ([treydock](https://github.com/treydock))

## [v7.5.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.5.0) (2021-12-02)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.4.1...v7.5.0)

### Added

- Improved cron job logging [\#26](https://github.com/treydock/puppet-module-xdmod/pull/26) ([treydock](https://github.com/treydock))
- Updates to support latest PCP module [\#25](https://github.com/treydock/puppet-module-xdmod/pull/25) ([treydock](https://github.com/treydock))
- Bump dependency version requirements [\#23](https://github.com/treydock/puppet-module-xdmod/pull/23) ([yorickps](https://github.com/yorickps))

## [v7.4.1](https://github.com/treydock/puppet-module-xdmod/tree/v7.4.1) (2021-09-15)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.4.0...v7.4.1)

### Fixed

- Avoid timeouts during install [\#22](https://github.com/treydock/puppet-module-xdmod/pull/22) ([treydock](https://github.com/treydock))

## [v7.4.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.4.0) (2021-09-15)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.3.0...v7.4.0)

### Added

- Allow cron jobs to be unmanaged [\#21](https://github.com/treydock/puppet-module-xdmod/pull/21) ([treydock](https://github.com/treydock))

## [v7.3.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.3.0) (2021-07-28)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.2.0...v7.3.0)

### Added

- Update how OnDemand plugin works for stable release [\#19](https://github.com/treydock/puppet-module-xdmod/pull/19) ([treydock](https://github.com/treydock))

## [v7.2.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.2.0) (2021-06-28)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.1.1...v7.2.0)

### Added

- Experimental Prometheus support [\#17](https://github.com/treydock/puppet-module-xdmod/pull/17) ([treydock](https://github.com/treydock))

### Fixed

- Do not execute xdmod-ingestor as part of Puppet runs [\#18](https://github.com/treydock/puppet-module-xdmod/pull/18) ([treydock](https://github.com/treydock))

## [v7.1.1](https://github.com/treydock/puppet-module-xdmod/tree/v7.1.1) (2021-06-28)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.1.0...v7.1.1)

### Fixed

- Do not timeout xdmod-ingestor, only run if gateway resources defined [\#16](https://github.com/treydock/puppet-module-xdmod/pull/16) ([treydock](https://github.com/treydock))

## [v7.1.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.1.0) (2021-06-28)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.0.1...v7.1.0)

### Added

- Support OnDemand module [\#15](https://github.com/treydock/puppet-module-xdmod/pull/15) ([treydock](https://github.com/treydock))

## [v7.0.1](https://github.com/treydock/puppet-module-xdmod/tree/v7.0.1) (2021-05-26)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v7.0.0...v7.0.1)

### Fixed

- Do not set java paths, removed during XDMOD 9.5.0 upgrade [\#14](https://github.com/treydock/puppet-module-xdmod/pull/14) ([treydock](https://github.com/treydock))

## [v7.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v7.0.0) (2021-05-25)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v6.0.1...v7.0.0)

### Changed

- Support XDMOD 9.5.x [\#13](https://github.com/treydock/puppet-module-xdmod/pull/13) ([treydock](https://github.com/treydock))
- Support Puppet 7, drop Puppet 5, update module dependencies [\#11](https://github.com/treydock/puppet-module-xdmod/pull/11) ([treydock](https://github.com/treydock))

### Added

- Run supremm mongo\_setup after package updates [\#12](https://github.com/treydock/puppet-module-xdmod/pull/12) ([treydock](https://github.com/treydock))

## [v6.0.1](https://github.com/treydock/puppet-module-xdmod/tree/v6.0.1) (2020-10-14)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v6.0.0...v6.0.1)

### Fixed

- Fix issue when multiple supremm resources have same PCP datasetmap\_source [\#10](https://github.com/treydock/puppet-module-xdmod/pull/10) ([treydock](https://github.com/treydock))

## [v6.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v6.0.0) (2020-10-07)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v5.1.0...v6.0.0)

### Changed

- Add support for XDMOD 9.0.0 [\#9](https://github.com/treydock/puppet-module-xdmod/pull/9) ([treydock](https://github.com/treydock))

## [v5.1.0](https://github.com/treydock/puppet-module-xdmod/tree/v5.1.0) (2020-02-26)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v5.0.0...v5.1.0)

### Added

- Update dependency ranges [\#7](https://github.com/treydock/puppet-module-xdmod/pull/7) ([treydock](https://github.com/treydock))

## [v5.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v5.0.0) (2019-10-28)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/v4.0.0...v5.0.0)

### Changed

- Support XDMoD 8.5 [\#5](https://github.com/treydock/puppet-module-xdmod/pull/5) ([treydock](https://github.com/treydock))

## [v4.0.0](https://github.com/treydock/puppet-module-xdmod/tree/v4.0.0) (2019-08-21)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/3.0.0...v4.0.0)

### Added

- Update module dependency upper limits [\#4](https://github.com/treydock/puppet-module-xdmod/pull/4) ([treydock](https://github.com/treydock))
- Update docs [\#3](https://github.com/treydock/puppet-module-xdmod/pull/3) ([treydock](https://github.com/treydock))
- Improvements to modernize module [\#2](https://github.com/treydock/puppet-module-xdmod/pull/2) ([treydock](https://github.com/treydock))
- Convert module to PDK [\#1](https://github.com/treydock/puppet-module-xdmod/pull/1) ([treydock](https://github.com/treydock))

## [3.0.0](https://github.com/treydock/puppet-module-xdmod/tree/3.0.0) (2019-03-01)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/1.0.0...3.0.0)

## [1.0.0](https://github.com/treydock/puppet-module-xdmod/tree/1.0.0) (2015-12-18)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/0.0.1...1.0.0)

## [0.0.1](https://github.com/treydock/puppet-module-xdmod/tree/0.0.1) (2015-08-19)

[Full Changelog](https://github.com/treydock/puppet-module-xdmod/compare/d2e483bba1f7cc0546b48bfc5a21a3b905cfdbfe...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
