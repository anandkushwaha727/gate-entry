CLASS zcl_man_gate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : tt_rept_early TYPE RESPONSE FOR REPORTED EARLY zi_man_gate,
            tt_map_early  TYPE RESPONSE FOR MAPPED EARLY zi_man_gate,
            tt_fail_early TYPE RESPONSE FOR FAILED EARLY zi_man_gate.

    TYPES : tt_gdat_keys TYPE TABLE FOR ACTION IMPORT zi_man_gate~getdata,
            tt_cret_keys TYPE TABLE FOR ACTION IMPORT zi_man_gate~cretgate,
            tt_cret_rslt type table for action result zi_man_gate~cretgate,
            tt_read_keys TYPE TABLE FOR READ IMPORT zi_man_gate,
            tt_read_rslt TYPE TABLE FOR READ RESULT zi_man_gate,
            tt_addl_keys TYPE TABLE FOR ACTION IMPORT zi_man_gate~addline.

    TYPES : record TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
            ty_rec TYPE zdt_gate_man.

    TYPES : ty_tabl  TYPE zdt_gate_man,
            gt_tabl  TYPE STANDARD TABLE OF ty_tabl WITH DEFAULT KEY,
            ty_num   TYPE c LENGTH 10,
            ty_menge TYPE p LENGTH 13 DECIMALS 2.

    DATA : wa_rec  TYPE ty_rec,
           wa_tabl TYPE ty_tabl,
           it_tabl TYPE gt_tabl.

    DATA : lv_lifnr TYPE string,
           lv_xblnr TYPE string,
           lv_vehno TYPE string,
           lv_zxdat TYPE budat,
           lv_puord TYPE ebeln,
           lv_schag TYPE ebeln,
           lv_matnr TYPE matnr,
           lv_menge TYPE p LENGTH 13 DECIMALS 2,
           lv_tdate TYPE string,
           lv_ttime TYPE string.

    METHODS:  getdata IMPORTING keys     TYPE tt_gdat_keys
                      EXPORTING record   TYPE record
                                avail    TYPE c
                      CHANGING  mapped   TYPE tt_map_early
                                failed   TYPE tt_fail_early
                                reported TYPE tt_rept_early,

      addline IMPORTING keys     TYPE tt_addl_keys
              EXPORTING record   TYPE record
                        exist    TYPE c
              CHANGING  mapped   TYPE tt_map_early
                        failed   TYPE tt_fail_early
                        reported TYPE tt_rept_early,


      cretgate    IMPORTING keys     TYPE tt_cret_keys
                  EXPORTING record   TYPE record
                  CHANGING  result   type tt_cret_rslt
                            mapped   TYPE tt_map_early
                            failed   TYPE tt_fail_early
                            reported TYPE tt_rept_early,

      read    IMPORTING keys     TYPE tt_read_keys
              CHANGING  result   TYPE tt_read_rslt
                        failed   TYPE tt_fail_early
                        reported TYPE tt_rept_early .

      INTERFACES : if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS: get_po_data IMPORTING ip_lifnr       TYPE string
                                         ip_xblnr       TYPE string
                                         ip_vehno       TYPE string
                                         ip_zxdat       TYPE budat
                                         ip_puord       TYPE ebeln
                                         ip_matnr       TYPE matnr
                                         ip_menge       TYPE ty_menge
                               RETURNING VALUE(rt_tabl) TYPE gt_tabl,
      get_sa_data IMPORTING ip_lifnr       TYPE string
                            ip_xblnr       TYPE string
                            ip_vehno       TYPE string
                            ip_zxdat       TYPE budat
                            ip_schag       TYPE ebeln
                            ip_matnr       TYPE matnr
                            ip_menge       TYPE ty_menge
                  RETURNING VALUE(rt_tabl) TYPE gt_tabl,

      get_unit   IMPORTING ip_pounit      TYPE I_PurchaseOrderItemAPI01-BaseUnit OPTIONAL
                           ip_scunit      TYPE I_SchedgAgrmtItmApi01-OrderPriceUnit OPTIONAL
                 RETURNING VALUE(rt_unit) TYPE string.
ENDCLASS.



CLASS ZCL_MAN_GATE IMPLEMENTATION.


  METHOD addline.
    DATA : lv_kmat TYPE n LENGTH 18.

    IF keys IS NOT INITIAL.
      SELECT lifnr,
             xblnr,
             zxdat,
             zcarr
        FROM zi_man_gate
        INTO TABLE @DATA(it_rec)."#EC CI_NOWHERE

      READ TABLE keys INTO DATA(ls_key) INDEX 1.
      READ TABLE it_rec INTO DATA(wa_rec) INDEX 1.

      IF ls_key IS NOT INITIAL.
        lv_lifnr = ls_key-%param-vendor.
        IF lv_lifnr IS INITIAL.
          lv_lifnr = wa_rec-lifnr.
        ENDIF.
        lv_xblnr = ls_key-%param-xblnr.
        IF lv_xblnr IS INITIAL.
          lv_xblnr = wa_rec-xblnr.
        ENDIF.
        lv_zxdat = ls_key-%param-zxdat.
        IF lv_zxdat IS INITIAL.
          lv_zxdat = wa_rec-zxdat.
        ENDIF.
        lv_puord = ls_key-%param-puord.
        lv_schag = ls_key-%param-schag.
        lv_matnr = ls_key-%param-product.
        lv_menge = ls_key-%param-menge.
        lv_vehno = ls_key-%param-vehno.
        IF lv_vehno IS INITIAL.
          lv_vehno = wa_rec-zcarr.
        ENDIF.
      ENDIF.
      IF lv_puord IS NOT INITIAL.
        FREE : it_tabl.

        SELECT *
          FROM zi_man_gate
         WHERE lifnr EQ @lv_lifnr
           AND xblnr EQ @lv_xblnr
           AND ebeln EQ @lv_puord
           AND matnr EQ @lv_matnr
          INTO TABLE @DATA(it_pord).

        IF it_pord IS NOT INITIAL.
          exist = 'X'.
        ELSE.
          IF it_pord IS INITIAL.
            CALL METHOD zcl_man_gate=>get_po_data
              EXPORTING
                ip_lifnr = lv_lifnr
                ip_xblnr = lv_xblnr
                ip_vehno = lv_vehno
                ip_zxdat = lv_zxdat
                ip_puord = lv_puord
                ip_matnr = lv_matnr
                ip_menge = lv_menge
              RECEIVING
                rt_tabl  = it_tabl.

            IF it_tabl IS NOT INITIAL.
              record = CORRESPONDING #( it_tabl ).
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_schag IS NOT INITIAL.
        FREE : it_tabl.

        SELECT *
          FROM zi_man_gate
         WHERE lifnr EQ @lv_lifnr
           AND xblnr EQ @lv_xblnr
           AND ebeln EQ @lv_schag
           AND matnr EQ @lv_matnr
          INTO TABLE @DATA(it_schd).

        IF it_schd IS NOT INITIAL.
          exist = 'X'.
        ELSE.
          CALL METHOD zcl_man_gate=>get_sa_data
            EXPORTING
              ip_lifnr = lv_lifnr
              ip_xblnr = lv_xblnr
              ip_vehno = lv_vehno
              ip_zxdat = lv_zxdat
              ip_schag = lv_schag
              ip_matnr = lv_matnr
              ip_menge = lv_menge
            RECEIVING
              rt_tabl  = it_tabl.

          IF it_tabl IS NOT INITIAL.
            record = CORRESPONDING #( it_tabl ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cretgate.
    DATA : wa_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
           it_cret TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
           it_dupl TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
           lv_resp TYPE string,
           lv_gnum type c length 10,
           lv_lifnr type string,
           lv_xblnr type string.

    IF keys IS NOT INITIAL.
      DATA(lo_gcbo) = NEW zcl_gate_crud(  ).

      select *
        from zdt_gate_man
         for all entries in @keys
       where ebeln eq @keys-ebeln
         and ebelp eq @keys-ebelp
         and lifnr eq @keys-lifnr
         and matnr eq @keys-matnr
        into table @data(it_temp)."#EC CI_NOWHERE

        if it_temp is not initial.

           loop at it_temp into data(wa_dupl).
               lv_lifnr = wa_dupl-lifnr.
               lv_xblnr = wa_dupl-xblnr.

               call method lo_gcbo->gate_dupl
                 EXPORTING
                   ip_lifnr = lv_lifnr
                   ip_xblnr = lv_xblnr
                   ip_zxdat = wa_dupl-zxdat
                 IMPORTING
                   ep_gedat = data(lt_gdat).

                 if lt_gdat is initial.
                    insert lines of lt_gdat into table it_dupl.
                 else.
                    if lt_gdat is not initial.
                        append lines of lt_gdat to it_dupl.
                    endif.
                 endif.
            endloop.

            if it_dupl is initial.
                lv_gnum = zcl_num_range=>get_ge_num_next( ).

                loop at it_temp into data(wa_temp).

                     wa_data = VALUE #(     zrgno           = lv_gnum
                                            xblnr           = wa_temp-xblnr
                                            zxdat           = wa_temp-zxdat
                                            zcarr           = wa_temp-zcarr
                                            lifnr           = wa_temp-lifnr
                                            vname           = wa_temp-vname
                                            ebeln           = wa_temp-ebeln
                                            ebelp           = wa_temp-ebelp
                                            bukrs           = wa_temp-bukrs
                                            werks           = wa_temp-werks
                                            lgort           = wa_temp-lgort
                                            matnr           = wa_temp-matnr
                                            txz_01          = wa_temp-txz01
                                            menge_v         = ''
                                            menge_u         = ''
                                            menge_u_text    = ''
                                            meins_v         = ''
                                            meins_u         = ''
                                            meins_u_text    = ''
                                            lsmng_v         = wa_temp-lsmng
                                            lsmng_u         = wa_temp-lsmeh
                                            lsmng_u_text    = ''
                                            lsmeh_v         = ''
                                            lsmeh_u         = ''
                                            lsmeh_u_text    = ''
                                            kdmat           = wa_temp-kdmat
                                            mblnr           = ''
                                            mjahr           = ''
                                            zeile           = ''
                                            zdinv           = ''
                                            vbeln           = ''
                                            posnr           = ''
                                            kunnr           = ''
                                            cname           = ''
                                            zedin           = ''
                                            aufnr           = ''
                                            zconf           = ''
                                            zgcat           = wa_temp-zgcat
                                            zmdir           = wa_temp-zmdir
                                            zstat           = ''
                                            grund           = '' ).

                     CALL METHOD lo_gcbo->gate_cret
                       EXPORTING
                         ip_data = wa_data
                       IMPORTING
                         ep_resp = lv_resp.

                     if lv_resp is not initial.
                      IF lv_resp CS 'Gate entry created'.
                        wa_temp-zrgno = wa_data-zrgno.
                        wa_temp-ztext = 'Gate Entry Created'.
                        MODIFY : it_temp FROM wa_temp.
                        CLEAR : wa_temp, wa_data, lv_resp.
                      else.
                        if lv_resp CS 'Gate entry not created'.
                            wa_temp-zrgno = '0000000000'.
                            wa_temp-ztext = 'Gate entry not created'.
                            MODIFY : it_temp FROM wa_temp.
                            CLEAR : wa_temp, wa_data, lv_resp.
                        endif.
                      ENDIF.
                     endif.
                endloop.
                clear : lv_gnum.

                record = CORRESPONDING #( it_temp ).

                READ ENTITIES OF zi_man_gate
                ENTITY zi_man_gate
                ALL FIELDS WITH CORRESPONDING #( keys )
                result data(lt_result).

                if lt_result is not initial.
                    result = VALUE #( for ls_result in lt_result ( %key = ls_result-%key
                                                                   SapUuid = ls_result-SapUuid
                                                                   Ebeln = ls_result-Ebeln
                                                                   Ebelp = ls_result-Ebelp
                                                                   Lifnr = ls_result-Lifnr
                                                                   Matnr = ls_result-Matnr
                                                                   %param = CORRESPONDING #( ls_result ) ) ).

                endif.
            else.
                if it_dupl is not initial.
                   loop at it_temp into data(wa_updt).
                     read table it_dupl into data(wa_dupl_rec) with key lifnr = wa_updt-lifnr
                                                                    xblnr = wa_updt-xblnr
                                                                    ebeln = wa_updt-ebeln
                                                                    ebelp = wa_updt-ebelp
                                                                    matnr = wa_updt-matnr.

                     wa_updt-zrgno = wa_dupl_rec-zrgno.
                     modify : it_temp from wa_updt.
                      clear : wa_updt, wa_dupl_rec.
                   endloop.
                   record = CORRESPONDING #( it_temp ).

                    READ ENTITIES OF zi_man_gate
                    ENTITY zi_man_gate
                    ALL FIELDS WITH CORRESPONDING #( keys )
                    result lt_result.

                    if lt_result is not initial.
                        result = VALUE #( for ls_result in lt_result ( %key = ls_result-%key
                                                                       SapUuid = ls_result-SapUuid
                                                                       Ebeln = ls_result-Ebeln
                                                                       Ebelp = ls_result-Ebelp
                                                                       Lifnr = ls_result-Lifnr
                                                                       Matnr = ls_result-Matnr
                                                                       %param = CORRESPONDING #( ls_result ) ) ).

                    endif.
                endif.
            endif.
        endif.
    endif.
  ENDMETHOD.


  METHOD getdata.
    DATA: exc TYPE REF TO cx_abap_context_info_error,
          exc_1 TYPE REF TO cx_abap_context_info_error.
    DATA(lo_gate) = NEW zcl_gate_crud(  ).

    call method zcl_clean_table=>clean_gate_man_dt( ).

    IF keys IS NOT INITIAL.
      READ TABLE keys INTO DATA(ls_key) INDEX 1.

      IF ls_key IS NOT INITIAL.
        lv_lifnr = ls_key-%param-vendor.
        lv_xblnr = ls_key-%param-xblnr.
        lv_zxdat = ls_key-%param-zxdat.
        lv_puord = ls_key-%param-puord.
        lv_schag = ls_key-%param-schag.
        lv_matnr = ls_key-%param-product.
        lv_menge = ls_key-%param-menge.
        lv_vehno = ls_key-%param-vehno.
      ENDIF.

      CALL METHOD lo_gate->gate_dupl
        EXPORTING
          ip_lifnr = lv_lifnr
          ip_xblnr = lv_xblnr
          ip_zxdat = lv_zxdat
        IMPORTING
          ep_gedat = DATA(lt_gdat).

      IF lt_gdat IS INITIAL.
        IF lv_puord IS NOT INITIAL.
          FREE : it_tabl.

          CALL METHOD zcl_man_gate=>get_po_data
            EXPORTING
              ip_lifnr = lv_lifnr
              ip_xblnr = lv_xblnr
              ip_vehno = lv_vehno
              ip_zxdat = lv_zxdat
              ip_puord = lv_puord
              ip_matnr = lv_matnr
              ip_menge = lv_menge
            RECEIVING
              rt_tabl  = it_tabl.

          IF it_tabl IS NOT INITIAL.
            record = CORRESPONDING #( it_tabl ).
          ENDIF.
        ENDIF.

        IF lv_schag IS NOT INITIAL.
          FREE : it_tabl.

          CALL METHOD zcl_man_gate=>get_sa_data
            EXPORTING
              ip_lifnr = lv_lifnr
              ip_xblnr = lv_xblnr
              ip_vehno = lv_vehno
              ip_zxdat = lv_zxdat
              ip_schag = lv_schag
              ip_matnr = lv_matnr
              ip_menge = lv_menge
            RECEIVING
              rt_tabl  = it_tabl.

          IF it_tabl IS NOT INITIAL.
            record = CORRESPONDING #( it_tabl ).
          ENDIF.
        ENDIF.
      ELSE.
        IF lt_gdat IS NOT INITIAL.
          avail = 'X'.
          LOOP AT lt_gdat INTO DATA(ls_gdat).
            wa_rec-zrgno = ls_gdat-zrgno.
            wa_rec-ernam = ls_gdat-sap_created_by_user.
            CLEAR : lv_tdate, lv_ttime.
            TRY.
                CONVERT TIME STAMP ls_gdat-sap_created_date_time
                        TIME ZONE cl_abap_context_info=>get_user_time_zone( )
                        INTO DATE lv_tdate
                             TIME lv_ttime.
              CATCH cx_abap_context_info_error into exc.
                 DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
                ##NO_HANDLER
            ENDTRY.
            wa_rec-erdat = lv_tdate.
            wa_rec-lifnr = ls_gdat-lifnr.
            wa_rec-matnr = ls_gdat-matnr.
            wa_rec-ebeln = ls_gdat-ebeln.
            wa_rec-ebelp = ls_gdat-ebelp.
            wa_rec-bukrs = ls_gdat-bukrs.
            wa_rec-werks = ls_gdat-werks.
            wa_rec-lgort = ls_gdat-lgort.
            wa_rec-lsmng = ls_gdat-lsmng_v.
            wa_rec-lsmeh = ls_gdat-lsmng_u.
            wa_rec-zmdir = ls_gdat-zmdir.
            wa_rec-txz01 = ls_gdat-txz_01.
            wa_rec-xblnr = ls_gdat-xblnr.
            wa_rec-zxdat = ls_gdat-zxdat.
            wa_rec-zcarr = ls_gdat-zcarr.
            wa_rec-kdmat = ls_gdat-kdmat.
            wa_rec-vname = ls_gdat-vname.
            CLEAR : lv_tdate, lv_ttime.
            TRY.
                CONVERT TIME STAMP ls_gdat-sap_last_changed_date_time
                        TIME ZONE cl_abap_context_info=>get_user_time_zone( )
                        INTO DATE lv_tdate
                             TIME lv_ttime.
              CATCH cx_abap_context_info_error into exc_1.
                 exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
               ##NO_HANDLER
            ENDTRY.
            wa_rec-zgcat = ls_gdat-zgcat.
            APPEND : wa_rec TO record.
            CLEAR : wa_rec, ls_gdat.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
    FREE : it_tabl.
    CLEAR : lv_lifnr, lv_xblnr, lv_zxdat, lv_puord, lv_schag, lv_matnr, lv_menge, lv_vehno, wa_tabl.

  ENDMETHOD.


  METHOD get_po_data.
    DATA : ls_tabl TYPE ty_tabl,
           lt_tabl TYPE gt_tabl,
           exc TYPE REF TO cx_uuid_error,
           exc_1 TYPE REF TO cx_abap_context_info_error.

    IF ip_puord IS NOT INITIAL.
      SELECT *
        FROM I_PurchaseOrderAPI01"#EC CI_NO_TRANSFORM
       WHERE PurchaseOrder EQ @ip_puord
        INTO TABLE @DATA(it_po_head).

      IF it_po_head IS NOT INITIAL.
        SELECT *
          FROM I_PurchaseOrderItemAPI01"#EC CI_NO_TRANSFORM
           FOR ALL ENTRIES IN @it_po_head
         WHERE PurchaseOrder EQ @it_po_head-PurchaseOrder
           AND Material EQ @ip_matnr
          INTO TABLE @DATA(it_po_item).

        IF it_po_item IS NOT INITIAL.
          IF ip_lifnr IS NOT INITIAL.
            SELECT *
              FROM I_Supplier"#EC CI_NO_TRANSFORM
             WHERE Supplier EQ @ip_lifnr
              INTO TABLE @DATA(it_lif)."#EC CI_ALL_FIELDS_NEEDED
          ELSE.
            IF ip_lifnr IS INITIAL.
              SELECT *
                FROM I_Supplier"#EC CI_NO_TRANSFORM
                 FOR ALL ENTRIES IN @it_po_head
               WHERE Supplier EQ @it_po_head-Supplier
                APPENDING TABLE @it_lif."#EC CI_ALL_FIELDS_NEEDED
            ENDIF.
          ENDIF.

          LOOP AT it_po_item INTO DATA(wa_po_item) WHERE Material EQ ip_matnr.
            READ TABLE it_po_head INTO DATA(wa_po_head) WITH KEY PurchaseOrder = wa_po_item-PurchaseOrder.
            READ TABLE it_lif INTO DATA(wa_lif) WITH KEY Supplier = wa_po_head-Supplier.
            DATA(getpo_uuid) = cl_uuid_factory=>create_system_uuid( ).
            TRY.
                DATA(uuid_po)    = getpo_uuid->create_uuid_x16( ).
              CATCH cx_uuid_error into exc.
                 DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
                ##NO_HANDLER
            ENDTRY.
            ls_tabl-sap_uuid = uuid_po.
            ls_tabl-bukrs = wa_po_item-CompanyCode.
            ls_tabl-ebeln = wa_po_item-PurchaseOrder.
            ls_tabl-ebelp = wa_po_item-PurchaseOrderItem.
            TRY.
                ls_tabl-erdat = cl_abap_context_info=>get_system_date( ).
                ls_tabl-ernam = cl_abap_context_info=>get_user_business_partner_id( ).
              CATCH cx_abap_context_info_error into exc_1.
                 exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
                ##NO_HANDLER
            ENDTRY.
            ls_tabl-lgort = wa_po_item-StorageLocation.
            ls_tabl-lifnr = wa_lif-Supplier.
            ls_tabl-lsmeh = zcl_man_gate=>get_unit( ip_pounit = wa_po_item-BaseUnit ).
            ls_tabl-lsmng = ip_menge.
            ls_tabl-matnr = wa_po_item-Material.
            ls_tabl-txz01 = wa_po_item-PurchaseOrderItemText.
            ls_tabl-vname = wa_lif-SupplierName.
            ls_tabl-werks = wa_po_item-Plant.
            ls_tabl-xblnr = ip_xblnr.
            ls_tabl-zxdat = ip_zxdat.
            ls_tabl-zcarr = ip_vehno.
            ls_tabl-zmdir = '1'.
            ls_tabl-zgcat = 'MAN'.
            ls_tabl-ztext = 'Gate Entry can be Created'.

            APPEND : ls_tabl TO lt_tabl.
            CLEAR : ls_tabl, wa_po_item, wa_po_head, wa_lif.
          ENDLOOP.

          IF lt_tabl IS NOT INITIAL.
            rt_tabl = lt_tabl.
          ENDIF.

          FREE : lt_tabl.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_sa_data.
    DATA : ls_tabl TYPE ty_tabl,
           lt_tabl TYPE gt_tabl,
           exc TYPE REF TO cx_uuid_error,
           exc_1 TYPE REF TO cx_abap_context_info_error.

    IF ip_schag IS NOT INITIAL.
      SELECT *
        FROM I_SchedgagrmthdrApi01"#EC CI_NO_TRANSFORM
       WHERE SchedulingAgreement EQ @ip_schag
        INTO TABLE @DATA(it_sa_head).

      IF it_sa_head IS NOT INITIAL.
        SELECT *
          FROM I_SchedgAgrmtItmApi01"#EC CI_NO_TRANSFORM
           FOR ALL ENTRIES IN @it_sa_head
         WHERE SchedulingAgreement EQ @it_sa_head-SchedulingAgreement
           AND Material EQ @ip_matnr
          INTO TABLE @DATA(it_sa_item).

        IF it_sa_item IS NOT INITIAL.
          IF ip_lifnr IS NOT INITIAL.
            SELECT *
              FROM I_Supplier"#EC CI_NO_TRANSFORM
             WHERE Supplier EQ @ip_lifnr
              INTO TABLE @DATA(it_lif)."#EC CI_ALL_FIELDS_NEEDED
          ELSE.
            IF ip_lifnr IS INITIAL.
              SELECT *
                FROM I_Supplier"#EC CI_NO_TRANSFORM
                 FOR ALL ENTRIES IN @it_sa_head
               WHERE Supplier EQ @it_sa_head-Supplier
                APPENDING TABLE @it_lif."#EC CI_ALL_FIELDS_NEEDED
            ENDIF.
          ENDIF.

          LOOP AT it_sa_item INTO DATA(wa_sa_item) WHERE Material EQ ip_matnr.
            READ TABLE it_sa_head INTO DATA(wa_sa_head) WITH KEY SchedulingAgreement = wa_sa_item-SchedulingAgreement.
            READ TABLE it_lif INTO DATA(wa_lif) WITH KEY Supplier = wa_sa_head-Supplier.
            DATA(getsa_uuid) = cl_uuid_factory=>create_system_uuid( ).
            TRY.
                DATA(uuid_sa)    = getsa_uuid->create_uuid_x16( ).
              CATCH cx_uuid_error into exc.
                 DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
                ##NO_HANDLER
            ENDTRY.
            ls_tabl-sap_uuid = uuid_sa.
            ls_tabl-bukrs = wa_sa_item-CompanyCode.
            ls_tabl-ebeln = wa_sa_item-SchedulingAgreement.
            ls_tabl-ebelp = wa_sa_item-SchedulingAgreementItem.
            TRY.
                ls_tabl-erdat = cl_abap_context_info=>get_system_date( ).
                ls_tabl-ernam = cl_abap_context_info=>get_user_business_partner_id( ).
              CATCH cx_abap_context_info_error into exc_1.
                 exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
                ##NO_HANDLER
            ENDTRY.
            ls_tabl-lgort = wa_sa_item-StorageLocation.
            ls_tabl-lifnr = wa_lif-Supplier.
            ls_tabl-lsmeh = zcl_man_gate=>get_unit( ip_scunit = wa_sa_item-OrderPriceUnit ).
            ls_tabl-lsmng = ip_menge.
            ls_tabl-matnr = wa_sa_item-Material.
            ls_tabl-txz01 = wa_sa_item-PurchasingDocumentItemText.
            ls_tabl-vname = wa_lif-SupplierName.
            ls_tabl-werks = wa_sa_item-Plant.
            ls_tabl-xblnr = ip_xblnr.
            ls_tabl-zxdat = ip_zxdat.
            ls_tabl-zcarr = ip_vehno.
            ls_tabl-zmdir = '1'.
            ls_tabl-zgcat = 'MAN'.
            ls_tabl-ztext = 'Gate Entry can be Created'.

            APPEND : ls_tabl TO lt_tabl.
            CLEAR : ls_tabl, wa_sa_item, wa_sa_head, wa_lif.
          ENDLOOP.

          IF lt_tabl IS NOT INITIAL.
            rt_tabl = lt_tabl.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_unit.
    IF ip_pounit IS NOT INITIAL.

      SELECT
      SINGLE UnitOfMeasure,
             UnitOfMeasureISOCode,
             UnitOfMeasure_E
        FROM I_UnitOfMeasure"#EC CI_NO_TRANSFORM
       WHERE UnitOfMeasure EQ @ip_pounit
        INTO @DATA(ls_punit).

      rt_unit = ls_punit-UnitOfMeasure_E.
      CONDENSE rt_unit NO-GAPS.
      CLEAR : ls_punit.

    ENDIF.

    IF ip_scunit IS NOT INITIAL.

      SELECT
      SINGLE UnitOfMeasure,
             UnitOfMeasureISOCode,
             UnitOfMeasure_E
        FROM I_UnitOfMeasure"#EC CI_NO_TRANSFORM
       WHERE UnitOfMeasure EQ @ip_scunit
        INTO @DATA(ls_sunit).

      rt_unit = ls_sunit-UnitOfMeasure_E.
      CONDENSE rt_unit NO-GAPS.
      CLEAR : ls_punit.

    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    data :  lt_tabl_read type standard table of zc_man_gate with default key.

    lt_tabl_read = CORRESPONDING #( it_original_data ).

    select *
      from I_PurOrdScheduleLineAPI01"#EC CI_NO_TRANSFORM
       for all entries in @lt_tabl_read
     where PurchaseOrder eq @lt_tabl_read-Ebeln
       and PurchaseOrderItem eq @lt_tabl_read-Ebelp
      into table @data(it_p_schl).

    if it_p_schl is initial.
       select *
          from I_SchedglineApi01"#EC CI_NO_TRANSFORM
           for all entries in @lt_tabl_read
         where SchedulingAgreement eq @lt_tabl_read-Ebeln
           and SchedulingAgreementItem eq @lt_tabl_read-Ebelp
          into table @data(it_s_schl).

       if it_s_schl is not initial.
          sort it_s_schl by SchedulingAgreement ASCENDING
                            SchedulingAgreementItem ASCENDING
                            ScheduleLine DESCENDING.

          DELETE ADJACENT DUPLICATES FROM it_s_schl COMPARING SchedulingAgreement.
       endif.

    else.
       sort it_p_schl by PurchaseOrder ASCENDING
                         PurchaseOrderItem ASCENDING
                         PurchaseOrderScheduleLine DESCENDING.

       delete ADJACENT DUPLICATES FROM it_p_schl comparing PurchaseOrder.
    endif.

    loop at lt_tabl_read into data(ls_tabl_read).
        read table it_p_schl into data(wa_p_schl) with key PurchaseOrder = ls_tabl_read-Ebeln
                                                           PurchaseOrderItem = ls_tabl_read-Ebelp.
        read table it_s_schl into data(wa_s_schl) with key SchedulingAgreement = ls_tabl_read-Ebeln
                                                           SchedulingAgreementItem = ls_tabl_read-Ebelp.

        if wa_p_schl is not initial.
            ls_tabl_read-soqty = wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty.
        endif.

        if wa_s_schl is not initial.
            ls_tabl_read-soqty = wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty.
        endif.

        modify : lt_tabl_read from ls_tabl_read.
         clear : ls_tabl_read, wa_p_schl, wa_s_schl.
    endloop.

    ct_calculated_data = CORRESPONDING #( lt_tabl_read ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.


  METHOD read.
    if keys is not initial.
        select *
          from zi_man_gate"#EC CI_NO_TRANSFORM
           for all entries in @keys
         where ebeln eq @keys-ebeln
           and ebelp eq @keys-ebelp
          into table @data(it_temp).

        if it_temp is not initial.
            result = CORRESPONDING #( it_temp ).
        endif.
        free : it_temp.
    endif.
  ENDMETHOD.
ENDCLASS.
