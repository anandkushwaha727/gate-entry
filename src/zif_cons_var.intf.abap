INTERFACE zif_cons_var
  PUBLIC .
  CONSTANTS : sys_dev     TYPE string VALUE 'https://my412713.s4hana.cloud.sap',
              sys_prd     TYPE string VALUE 'https://my419648.s4hana.cloud.sap',
              portal_dev  TYPE string VALUE 'http://quality.umasons.com',
              portal_prd  TYPE string VALUE 'http://13.201.253.34',
              vendor_sync TYPE string VALUE '/auvendor/',
              purord_sync TYPE string VALUE '/aupoitems/',
              schlin_sync TYPE string VALUE '/audelsch/',
              matdoc_sync TYPE string VALUE '/aumdoc/',
              subchl_sync TYPE string VALUE '/ausubcon/',
              substk_sync type string value '/aumblb/',
              normge_mdn  TYPE string VALUE '/getasndocbyid/',
              b2s2ge_mdn  TYPE string VALUE '/getbsvendorlist/',
              iwdnum_sync TYPE string VALUE '/sendinwardnumberbyasnid/',
              portal_tkn  TYPE string VALUE 'fb3_pryjdgpm6iz9p4ilk^9l+1&dx7i#obq-v!hca&1%qz-&)%',
              log_sys_dev     type string value '0M5P2GD',
              log_sys_qas     type string value '0M61NG2'.

*  CONSTANTS : ptop_vend type string VALUE '10082'.

  CONSTANTS : ptop_vend type string VALUE '10397',
              ptop_vend_dev type string VALUE '10082'.

  CONSTANTS : begin of c_user,
                 scm_user    TYPE string VALUE 'ZGATE_CBO',
                 scm_pass    TYPE string VALUE 'XzXR(NsQcsXZkXzdlQUEuGPtgRelfv6pmNfadXfl',
              end of c_user.



ENDINTERFACE.
