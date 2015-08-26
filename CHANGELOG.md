## 1.0.0 - TBD

### Summary

Support for XDMoD 5.0.0

### Changes

* Add support for Application Kernels
* Add support for Application Kernels Remote Runner (AKRR)

### Detailed Changes

* Parameters added:
  * `enable_appkernel`
  * `appkernels_package_name`
  * `akrr_database_user`
  * `akrr_database_password`
  * `akrr_restapi_port`
  * `akrr_restapi_rw_password`
  * `akrr_restapi_ro_password`
* Update XDMoD Apache::Vhost
* Change default value for `web_host` to be `localhost`

## 0.0.1 - 2015-08-19

### Summary

This initial release supports XDMoD 4.5.x
