CLASS zcl_clean_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    types : ty_document type c length 10.

    CLASS-DATA    : it_supp_sync TYPE TABLE OF zdt_vend_sync WITH DEFAULT KEY,
                    it_schl_sync TYPE TABLE OF zdt_schl_sync WITH DEFAULT KEY,
                    it_purc_sync TYPE TABLE OF zdt_purc_sync WITH DEFAULT KEY,
                    it_slin_sync TYPE TABLE OF zdt_slin_sync WITH DEFAULT KEY,
                    it_gr_sync   TYPE TABLE OF zdt_gr_sync WITH DEFAULT KEY,
                    it_gate_mdn  TYPE TABLE OF zdt_gate_mdn WITH DEFAULT KEY,
                    it_gate_head type table of zdt_gate_head with default key,
                    it_gate_man  TYPE TABLE OF zdt_gate_man WITH DEFAULT KEY,
                    it_gate_out  type table of zdt_gate_out with default key,
                    it_b2s2      TYPE TABLE OF zdt_b2s2 WITH DEFAULT KEY,
                    it_mdoc      TYPE TABLE OF zdt_mdoc WITH DEFAULT KEY,
                    it_message   type table of zdt_message with default key.

    CLASS-METHODS : clean_supp_sync_dt RETURNING VALUE(rt_resp) TYPE string,
      clean_schl_sync_dt RETURNING VALUE(rt_resp) TYPE string,
      clean_purc_sync_dt RETURNING VALUE(rt_resp) TYPE string,
      clean_slin_sync_dt RETURNING VALUE(rt_resp) TYPE string,
      clean_gr_sync_dt   RETURNING VALUE(rt_resp) TYPE string,
      clean_gate_mdn_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_gate_head_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_gate_man_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_gate_out_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_b2s2_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_mdoc_dt  RETURNING VALUE(rt_resp) TYPE string,
      clean_message_dt IMPORTING ip_zscpn type ty_document optional
                       RETURNING VALUE(rt_resp) TYPE string.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CLEAN_TABLE IMPLEMENTATION.


  METHOD clean_b2s2_dt.
    FREE : it_b2s2.
    SELECT *
      FROM zdt_b2s2
      INTO TABLE @it_b2s2."#EC CI_NOWHERE

    IF it_b2s2 IS NOT INITIAL.
      DELETE FROM zdt_b2s2."#EC CI_NOWHERE
      FREE : it_b2s2.

      SELECT *
        FROM zdt_b2s2
        INTO TABLE @it_b2s2."#EC CI_NOWHERE

      IF it_b2s2 IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_b2s2.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_gate_head_dt.
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    FREE : it_gate_head.
    SELECT *
      FROM zdt_gate_head
     where ernam eq @lv_user
      INTO TABLE @it_gate_head."#EC CI_NOWHERE

    IF it_gate_head IS NOT INITIAL.
      DELETE FROM zdt_gate_head where ernam eq @lv_user."#EC CI_NOWHERE
      FREE : it_gate_head.

      SELECT *
        FROM zdt_gate_head
       where ernam eq @lv_user
        INTO TABLE @it_gate_head."#EC CI_NOWHERE

      IF it_gate_head IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_gate_head, lv_user.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_gate_man_dt.
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    FREE : it_gate_man.
    SELECT *
      FROM zdt_gate_man
     where ernam eq @lv_user
      INTO TABLE @it_gate_man."#EC CI_NOWHERE

    IF it_gate_man IS NOT INITIAL.
      DELETE FROM zdt_gate_man where ernam eq @lv_user."#EC CI_NOWHERE
      FREE : it_gate_man.

      SELECT *
        FROM zdt_gate_man
       where ernam eq @lv_user
        INTO TABLE @it_gate_man."#EC CI_NOWHERE

      IF it_gate_man IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_gate_man, lv_user.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_gate_mdn_dt.
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    FREE : it_gate_mdn.
    SELECT *
      FROM zdt_gate_mdn
     where ernam eq @lv_user
      INTO TABLE @it_gate_mdn."#EC CI_NOWHERE

    IF it_gate_mdn IS NOT INITIAL.
      DELETE FROM zdt_gate_mdn where ernam eq @lv_user."#EC CI_NOWHERE
      FREE : it_gate_mdn.

      SELECT *
        FROM zdt_gate_mdn
       where ernam eq @lv_user
        INTO TABLE @it_gate_mdn."#EC CI_NOWHERE

      IF it_gate_mdn IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_gate_mdn, lv_user.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_gate_out_dt.
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    FREE : it_gate_out.
    SELECT *
      FROM zdt_gate_out
     where ernam eq @lv_user
      INTO TABLE @it_gate_out."#EC CI_NOWHERE

    IF it_gate_out IS NOT INITIAL.
      DELETE FROM zdt_gate_out where ernam eq @lv_user."#EC CI_NOWHERE
      FREE : it_gate_out.

      SELECT *
        FROM zdt_gate_out
       where ernam eq @lv_user
        INTO TABLE @it_gate_out."#EC CI_NOWHERE

      IF it_gate_out IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_gate_out, lv_user.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_gr_sync_dt.
    FREE : it_gr_sync.

    SELECT *
      FROM zdt_gr_sync
      INTO TABLE @it_gr_sync."#EC CI_NOWHERE

    IF it_gr_sync IS NOT INITIAL.
      DELETE FROM zdt_gr_sync."#EC CI_NOWHERE
      FREE : it_gr_sync.

      SELECT *
        FROM zdt_gr_sync
        INTO TABLE @it_gr_sync."#EC CI_NOWHERE

      IF it_gr_sync IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_gr_sync.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_mdoc_dt.
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    FREE : it_mdoc.
    SELECT *
      FROM zdt_mdoc
     where ernam eq @lv_user
      INTO TABLE @it_mdoc."#EC CI_NOWHERE

    IF it_mdoc IS NOT INITIAL.
      DELETE FROM zdt_mdoc where ernam eq @lv_user."#EC CI_NOWHERE
      FREE : it_mdoc.

      SELECT *
        FROM zdt_mdoc
       where ernam eq @lv_user
        INTO TABLE @it_mdoc."#EC CI_NOWHERE

      IF it_mdoc IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_mdoc, lv_user.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_message_dt.
    data : lv_sdate type budat,
           lv_edate type budat.

    FREE : it_message.
    clear : lv_sdate, lv_edate.

    if ip_zscpn is initial.
        lv_edate = cl_abap_context_info=>get_system_date( ).
        lv_sdate = lv_edate - 8.

        select *
          from zdt_message
         where budat eq @lv_sdate
          into table @it_message."#EC CI_NOWHERE

        IF it_message IS NOT INITIAL.
          DELETE zdt_message from table @it_message."#EC CI_NOWHERE
          FREE : it_message.

          if sy-subrc eq 0.
            rt_resp = 'Y'.
          ELSE.
            rt_resp   = 'N'.
          ENDIF.

          FREE : it_message.
        ELSE.
          rt_resp = 'NA'.
        ENDIF.
    elseif ip_zscpn is not initial.

        select *
          from zdt_message
         where zscpn eq @ip_zscpn
          into table @it_message."#EC CI_NOWHERE

        IF it_message IS NOT INITIAL.
          DELETE from zdt_message where zscpn eq @ip_zscpn."#EC CI_NOWHERE
          FREE : it_message.

          if sy-subrc eq 0.
            rt_resp = 'Y'.
          ELSE.
            rt_resp   = 'N'.
          ENDIF.

          FREE : it_message.
        ELSE.
          rt_resp = 'NA'.
        ENDIF.
    endif.
  ENDMETHOD.


  METHOD clean_purc_sync_dt.
    FREE : it_purc_sync.
    SELECT *
      FROM zdt_purc_sync
      INTO TABLE @it_purc_sync."#EC CI_NOWHERE

    IF it_purc_sync IS NOT INITIAL.
      DELETE FROM zdt_purc_sync."#EC CI_NOWHERE
      FREE : it_purc_sync.

      SELECT *
        FROM zdt_purc_sync
        INTO TABLE @it_purc_sync."#EC CI_NOWHERE

      IF it_purc_sync IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_purc_sync.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_schl_sync_dt.
    FREE : it_schl_sync.
    SELECT *
      FROM zdt_schl_sync
      INTO TABLE @it_schl_sync."#EC CI_NOWHERE

    IF it_schl_sync IS NOT INITIAL.
      DELETE FROM zdt_schl_sync."#EC CI_NOWHERE
      FREE : it_schl_sync.

      SELECT *
        FROM zdt_schl_sync
        INTO TABLE @it_schl_sync."#EC CI_NOWHERE

      IF it_schl_sync IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_schl_sync.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_slin_sync_dt.
    FREE : it_slin_sync.
    SELECT *
      FROM zdt_slin_sync
      INTO TABLE @it_slin_sync."#EC CI_NOWHERE

    IF it_slin_sync IS NOT INITIAL.
      DELETE FROM zdt_slin_sync."#EC CI_NOWHERE
      FREE : it_slin_sync.

      SELECT *
        FROM zdt_slin_sync
        INTO TABLE @it_slin_sync."#EC CI_NOWHERE

      IF it_slin_sync IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_slin_sync.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD clean_supp_sync_dt.
    FREE : it_supp_sync.

    SELECT *
      FROM zdt_vend_sync
      INTO TABLE @it_supp_sync."#EC CI_NOWHERE

    IF it_supp_sync IS NOT INITIAL.
      DELETE FROM zdt_vend_sync."#EC CI_NOWHERE
      FREE : it_supp_sync.

      SELECT *
        FROM zdt_vend_sync
        INTO TABLE @it_supp_sync."#EC CI_NOWHERE

      IF it_supp_sync IS INITIAL.
        rt_resp = 'Y'.
      ELSE.
        rt_resp   = 'N'.
      ENDIF.

      FREE : it_supp_sync.
    ELSE.
      rt_resp = 'NA'.
    ENDIF.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
      call method zcl_clean_table=>clean_b2s2_dt( ).
      call method zcl_clean_table=>clean_supp_sync_dt( ).
      call method zcl_clean_table=>clean_schl_sync_dt( ).
      call method zcl_clean_table=>clean_purc_sync_dt( ).
      call method zcl_clean_table=>clean_slin_sync_dt( ).
      call method zcl_clean_table=>clean_gr_sync_dt( ).
      call method zcl_clean_table=>clean_gate_mdn_dt( ).
      call method zcl_clean_table=>clean_gate_head_dt( ).
      call method zcl_clean_table=>clean_gate_man_dt( ).
      call method zcl_clean_table=>clean_mdoc_dt( ).
      call method zcl_clean_table=>clean_message_dt( ).
  ENDMETHOD.
ENDCLASS.
