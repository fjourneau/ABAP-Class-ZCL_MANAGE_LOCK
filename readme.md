# ABAP-Class-ZCL_MANAGE_LOCK
SAP : Class to easily manage lock.

The goal of this class is to easily manage lock with few code.

>:information_source: Code proposed here is not complete, up to you to abapt it according to your need.

## Examples of use

Check how easy it is to check lock :

```abap
 " check if TR is locked :
 lw_subrc = zcl_manage_lock=>check_lock_transfer_request( iw_lgnum         = lv_lgnum
                                                          iw_tbnum         = ltbk-tbnum
                                                          iw_max_wait_time = 5 ).
 " lw_subrc = 0 ===> Not locked !                                                         
```

## Documentation

### Methods

| Name | Type |Visibility | Description |
|---|---|---|---|
|`CHECK_LOCK_OBJECT`|Static Method|Public|Check if object is locked|
|`READ_ENQUEUE`|Static Method|Private|Call FM to read enqueue|
|`CHECK_LOCK_TRANSFER_REQUEST`|Static Method|Public|Check if TR is locked|

You can easily create new methods for objects...
