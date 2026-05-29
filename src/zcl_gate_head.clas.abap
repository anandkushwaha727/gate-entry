CLASS zcl_gate_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : tt_read_head_keys TYPE TABLE FOR READ IMPORT zi_gate_head,
            tt_read_head_rslt TYPE TABLE FOR READ RESULT zi_gate_head,
            tt_read_item_keys TYPE TABLE FOR READ IMPORT zi_gate_item,
            tt_read_item_rslt TYPE TABLE FOR READ RESULT zi_gate_item,
            tt_rba_keys       type table for read import zi_gate_head\_item,
            tt_rba_rslt       type table for read result zi_gate_head\_item,
            tt_rba_asso_link  type table for read link zi_gate_head\_item,
            tt_updt_head_enty TYPE TABLE FOR UPDATE zi_gate_head,
            tt_updt_item_enty TYPE TABLE FOR UPDATE zi_gate_item,
            tt_cret_head_keys TYPE TABLE FOR ACTION IMPORT zi_gate_head~cretgate,
            tt_cret_head_rslt TYPE TABLE FOR ACTION RESULT zi_gate_head~cretgate.

    TYPES : tt_map_early  TYPE RESPONSE FOR MAPPED EARLY zi_gate_head,
            tt_fail_early TYPE RESPONSE FOR FAILED EARLY zi_gate_head,
            tt_rept_early TYPE RESPONSE FOR REPORTED EARLY zi_gate_head.

    TYPES : record TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
            rslt_rqst type c length 1 .

    TYPES : begin of ty_line.
            INCLUDE type I_SchedglineApi01.
    TYPES : srnum type i,
            end of ty_line.

    types : tt_line type standard table of ty_line with default key.

    types : tt_range_month type range of budat.

    CLASS-DATA :   lv_count type i,
                   lv_cdate type d,
                   lv_ndate type d,
                   wa_cline type ty_line,
                   it_cline type tt_line,
                   wa_nline type ty_line,
                   it_nline type tt_line,
                   it_line type tt_line.

    METHODS :  read_head  IMPORTING keys     TYPE  tt_read_head_keys
                          CHANGING  result   TYPE  tt_read_head_rslt
                                    failed   TYPE  tt_fail_early
                                    reported TYPE  tt_rept_early,

      updt_head  IMPORTING entities TYPE tt_updt_head_enty
                 EXPORTING error    TYPE string_table
                           success  TYPE string_table
                 CHANGING  mapped   TYPE tt_map_early
                           failed   TYPE tt_fail_early
                           reported TYPE tt_rept_early,

      cretgate  IMPORTING keys     TYPE tt_cret_head_keys
                EXPORTING error    TYPE string_table
                          success  TYPE string_table
                          record   type record
                CHANGING  result   TYPE tt_cret_head_rslt
                          mapped   TYPE tt_map_early
                          failed   TYPE tt_fail_early
                          reported TYPE tt_rept_early,

      read_item  IMPORTING keys     TYPE tt_read_item_keys
                 CHANGING  result   TYPE tt_read_item_rslt
                           failed   TYPE tt_fail_early
                           reported TYPE tt_rept_early,

      updt_item  IMPORTING entities TYPE tt_updt_item_enty
                 EXPORTING error    TYPE string_table
                           success  TYPE string_table
                 CHANGING  mapped   TYPE tt_map_early
                           failed   TYPE tt_fail_early
                           reported TYPE tt_rept_early,

      rba_item   importing keys_rba             type tt_rba_keys
                           result_requested     type rslt_rqst
                  changing result               type tt_rba_rslt
                           association_links    type tt_rba_asso_link
                           failed               type tt_fail_early
                           reported             type tt_rept_early.

    INTERFACES : if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS: get_uuid RETURNING VALUE(rt_uuid) TYPE sysuuid_x16,
                   get_oqty IMPORTING ip_ebeln type ebeln
                                      ip_ebelp type ebelp
                                      ip_zxdat type d optional
                            RETURNING VALUE(rt_oqty) type menge_d,
                   get_unit importing ip_unit type meins optional
                            returning value(rt_unit) type meins,
                   get_month_dates importing ip_sydate type d
                                   returning value(rt_date) type tt_range_month.
ENDCLASS.



CLASS ZCL_GATE_HEAD IMPLEMENTATION.


  METHOD cretgate.
    DATA : wa_data  TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
           it_cret  TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
           it_dupl  TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
           lv_resp  TYPE string,
           lv_gnum  TYPE c LENGTH 10,
           lv_lifnr TYPE string,
           lv_xblnr TYPE string,
           lv_zxdat type budat,
           lv_msg type string,
           lv_rels type c length 1.

    IF keys IS NOT INITIAL.
      DATA(lo_gcbo) = NEW zcl_gate_crud(  ).

      data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

      SELECT *
        FROM zdt_gate_man
         FOR ALL ENTRIES IN @keys
       WHERE ebeln EQ @keys-ebeln
         and ernam eq @lv_user
        INTO TABLE @DATA(it_temp).


        SELECT PurchaseOrder,
               ReleaseIsNotCompleted
          FROM I_PurchaseOrderAPI01
           FOR ALL ENTRIES IN @keys
         WHERE PurchaseOrder EQ @keys-ebeln
          INTO TABLE @DATA(it_prel).

        if it_prel is initial.
            select SchedulingAgreement,
                   ReleaseIsNotCompleted
              from I_SchedgAgrmtHdrTP_2
               for all entries in @keys "#EC CI_FAE_LINES_ENSURED
             where SchedulingAgreement eq @keys-ebeln
              into table @data(it_srel)."#EC CI_ALL_FIELDS_NEEDED
        endif.

      IF it_temp IS NOT INITIAL.


        LOOP AT it_temp INTO DATA(wa_temp).
            read table it_prel into data(wa_prel) with key PurchaseOrder = wa_temp-ebeln.
            if wa_prel is not initial.
               lv_rels = wa_prel-ReleaseIsNotCompleted.
            elseif wa_prel is initial.
                read table it_srel into data(wa_srel) with key SchedulingAgreement = wa_temp-ebeln.
                if wa_srel is not initial.
                    lv_rels = wa_srel-ReleaseIsNotCompleted.
                endif.
            endif.
*          if wa_temp-zrgno is not initial.
*
*            call method lo_gcbo->gate_read
*              EXPORTING
*                ip_zrgno = wa_temp-zrgno
*              IMPORTING
*                ep_data  = data(lt_gdat).
*
*          elseif wa_temp-zrgno is initial.
*              lv_lifnr = wa_temp-lifnr.
*              lv_xblnr = wa_temp-xblnr.
*              lv_zxdat = wa_temp-zxdat.
*
*              call method lo_gcbo->gate_dupl
*                EXPORTING
*                  ip_lifnr = lv_lifnr
*                  ip_xblnr = lv_xblnr
*                  ip_zxdat = lv_zxdat
*                IMPORTING
*                  ep_gedat = lt_gdat.
*          endif.

*          if lt_gdat is initial.
*               if lv_rels eq space.
                  if wa_temp-lsmng gt 0.
                      if lv_gnum is initial.
                        lv_gnum = zcl_num_range=>get_ge_num_next( ).
                      endif.
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
                                             zdinv           = 'X'
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

                      IF lv_resp IS NOT INITIAL.
                        IF lv_resp CS 'Gate entry created'.
                          wa_temp-zrgno = wa_data-zrgno.
                          wa_temp-ztext = 'Gate Entry Created'.
                          MODIFY : it_temp FROM wa_temp.
                          CLEAR : wa_temp, wa_data, lv_resp.
                        ELSE.
                          IF lv_resp CS 'Gate entry not created'.
                            wa_temp-zrgno = '0000000000'.
                            wa_temp-ztext = 'Gate entry not created'.
                            MODIFY : it_temp FROM wa_temp.
                            CLEAR : wa_temp, wa_data, lv_resp.
                          ENDIF.
                        ENDIF.
                      ENDIF.
                  endif.
*               elseif lv_rels eq space.
*                  error = VALUE #( ( |PO { wa_temp-ebeln } is not Released| ) ).
*               endif.
*          else.
*             error = VALUE #( ( |Entry { wa_temp-zrgno } exists for { wa_temp-xblnr }| ) ).
*          endif.
          clear : lv_lifnr, lv_xblnr, lv_zxdat.
*          free : lt_gdat.
        ENDLOOP.
        if lv_gnum is not initial.
            CLEAR : lv_gnum.
*        elseif lv_gnum is initial.
*           error = VALUE #( ( |Please Enter Qty for At least 1 Item| ) ).
        endif.

        record = CORRESPONDING #( it_temp ).

        READ ENTITIES OF zi_gate_head
        ENTITY zi_gate_head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

        IF lt_result IS NOT INITIAL.
          result = VALUE #( FOR ls_result IN lt_result ( %key = ls_result-%key
                                                         %param = CORRESPONDING #( ls_result ) ) ).
        ENDIF.
      ENDIF.
    ENDIF.
    clear : lv_user.
  ENDMETHOD.


  METHOD get_oqty.
*    if ip_zxdat is not initial.
*        data(lt_date) = zcl_gate_head=>get_month_dates( ip_sydate = ip_zxdat ).
*    elseif ip_zxdat is initial.
        data(lt_date) = zcl_gate_head=>get_month_dates( ip_sydate = cl_abap_context_info=>get_system_date( ) ).
*    endif.

    select *
      from I_PurOrdScheduleLineAPI01
     where PurchaseOrder eq @ip_ebeln
       and PurchaseOrderItem eq @ip_ebelp
*       and ScheduleLineDeliveryDate in @lt_date
      into table @data(it_p_schl)."#EC CI_ALL_FIELDS_NEEDED

    if it_p_schl is initial.
       select *
          from I_SchedglineApi01
         where SchedulingAgreement eq @ip_ebeln
           and SchedulingAgreementItem eq @ip_ebelp
           and ScheduleLineDeliveryDate in @lt_date
          into table @data(it_s_schl)."#EC CI_ALL_FIELDS_NEEDED

       if it_s_schl is not initial.
*          sort it_s_schl by SchedulingAgreement ASCENDING
*                            SchedulingAgreementItem ASCENDING
*                            ScheduleLine DESCENDING.
*
*          DELETE ADJACENT DUPLICATES FROM it_s_schl COMPARING SchedulingAgreement SchedulingAgreementItem.
       endif.

    else.
*       sort it_p_schl by PurchaseOrder ASCENDING
*                         PurchaseOrderItem ASCENDING
*                         PurchaseOrderScheduleLine DESCENDING.
*
*       delete ADJACENT DUPLICATES FROM it_p_schl comparing PurchaseOrder PurchaseOrderItem.
    endif.

    if it_p_schl is not initial.
        loop at it_p_schl into data(wa_p_schl) where PurchaseOrder = ip_ebeln
                                                 and PurchaseOrderItem = ip_ebelp.
            case wa_p_schl-DelivDateCategory.
                WHEN '1'.
                    if wa_p_Schl-ScheduleLineOrderQuantity gt wa_p_schl-RoughGoodsReceiptQty.
                        rt_oqty = rt_oqty + ( wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty ).
                    endif.
                WHEN OTHERS.
                    if wa_p_Schl-ScheduleLineOrderQuantity gt wa_p_schl-RoughGoodsReceiptQty.
                        if rt_oqty gt 0.
                            rt_oqty = rt_oqty + ( wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty ).
                        else.
                            rt_oqty = wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty.
                        endif.
                    endif.
            endcase.
            clear : wa_p_schl.
         endloop.
    endif.



    if it_s_schl is not initial.

        loop at it_s_schl into data(wa_s_schl) where SchedulingAgreement = ip_ebeln
                                                 and SchedulingAgreementItem = ip_ebelp.
            case wa_s_schl-DelivDateCategory.
                WHEN '1'.
                    if wa_s_Schl-ScheduleLineOrderQuantity gt wa_s_schl-RoughGoodsReceiptQty.
                        rt_oqty = rt_oqty + ( wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty ).
                    endif.
                WHEN OTHERS.
                    if wa_s_Schl-ScheduleLineOrderQuantity gt wa_s_schl-RoughGoodsReceiptQty.
                        if rt_oqty gt 0.
                            rt_oqty = rt_oqty + ( wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty ).
                        else.
                            rt_oqty = wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty.
                        endif.
                    endif.
            endcase.
            clear : wa_s_schl.
        endloop.

    endif.
    clear: wa_s_schl, wa_p_schl.
    free : it_s_schl, it_p_schl.
  ENDMETHOD.


  METHOD GET_UNIT.
    if ip_unit is not initial.
      SELECT
      SINGLE UnitOfMeasure,
             UnitOfMeasureISOCode,
             UnitOfMeasure_E
        FROM I_UnitOfMeasure
       WHERE UnitOfMeasure EQ @ip_unit
        INTO @DATA(ls_punit).

      rt_unit = ls_punit-UnitOfMeasure_E.
      CONDENSE rt_unit NO-GAPS.
      CLEAR : ls_punit.
    endif.
  ENDMETHOD.


  METHOD get_uuid.
    DATA: exc TYPE REF TO cx_uuid_error.
    DATA(get_uuid) = cl_uuid_factory=>create_system_uuid( ).

    TRY.
        DATA(uuid_po)    = get_uuid->create_uuid_x16( ).

        rt_uuid = uuid_po.
        clear : uuid_po.
      CATCH cx_uuid_error into exc.
         DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    data :  lt_tabl_read type standard table of zc_gate_item with default key.

    lt_tabl_read = CORRESPONDING #( it_original_data ).

*    select *
*      from I_PurOrdScheduleLineAPI01
*       for all entries in @lt_tabl_read
*     where PurchaseOrder eq @lt_tabl_read-Ebeln
*       and PurchaseOrderItem eq @lt_tabl_read-Ebelp
*      into table @data(it_p_schl)."#EC CI_ALL_FIELDS_NEEDED
*
*    if it_p_schl is initial.
*       select *
*          from I_SchedglineApi01
*           for all entries in @lt_tabl_read
*         where SchedulingAgreement eq @lt_tabl_read-Ebeln
*           and SchedulingAgreementItem eq @lt_tabl_read-Ebelp
*          into table @data(it_s_schl)."#EC CI_ALL_FIELDS_NEEDED
*
*       if it_s_schl is not initial.
*          sort it_s_schl by SchedulingAgreement ASCENDING
*                            SchedulingAgreementItem ASCENDING
*                            ScheduleLine DESCENDING.
*
*          DELETE ADJACENT DUPLICATES FROM it_s_schl COMPARING SchedulingAgreement SchedulingAgreementItem.
*       endif.
*
*    else.
*       sort it_p_schl by PurchaseOrder ASCENDING
*                         PurchaseOrderItem ASCENDING
*                         PurchaseOrderScheduleLine DESCENDING.
*
*       delete ADJACENT DUPLICATES FROM it_p_schl comparing PurchaseOrder PurchaseOrderItem.
*    endif.
    if lt_tabl_read is not initial.
        loop at lt_tabl_read into data(ls_tabl_read).
*            if ls_tabl_read-zxdat is not initial.
*                data(lt_date) = zcl_gate_head=>get_month_dates( ip_sydate = ls_tabl_read-zxdat ).
*            elseif ls_tabl_read-zxdat is initial.
                data(lt_date) = zcl_gate_head=>get_month_dates( ip_sydate = cl_abap_context_info=>get_system_date( ) ).
*            endif.

            select *
              from I_PurOrdScheduleLineAPI01
             where PurchaseOrder eq @ls_tabl_read-Ebeln
               and PurchaseOrderItem eq @ls_tabl_read-Ebelp
*               and ScheduleLineDeliveryDate in @lt_date
              into table @data(it_p_schl)."#EC CI_ALL_FIELDS_NEEDED

            if it_p_schl is initial.
               select *
                  from I_SchedglineApi01
                 where SchedulingAgreement eq @ls_tabl_read-Ebeln
                   and SchedulingAgreementItem eq @ls_tabl_read-Ebelp
                   and ScheduleLineDeliveryDate in @lt_date
                  into table @data(it_s_schl)."#EC CI_ALL_FIELDS_NEEDED

               if it_s_schl is not initial.
*                  sort it_s_schl by SchedulingAgreement ASCENDING
*                                    SchedulingAgreementItem ASCENDING
*                                    ScheduleLine DESCENDING.
*
*                  DELETE ADJACENT DUPLICATES FROM it_s_schl COMPARING SchedulingAgreement SchedulingAgreementItem.
               endif.

            else.
*               sort it_p_schl by PurchaseOrder ASCENDING
*                                 PurchaseOrderItem ASCENDING
*                                 PurchaseOrderScheduleLine DESCENDING.
*
*               delete ADJACENT DUPLICATES FROM it_p_schl comparing PurchaseOrder PurchaseOrderItem.
            endif.

            loop at it_p_schl into data(wa_p_schl) where PurchaseOrder = ls_tabl_read-Ebeln
                                                     and PurchaseOrderItem = ls_tabl_read-Ebelp.
                case wa_p_schl-DelivDateCategory.
                    WHEN '1'.
                        if wa_p_Schl-ScheduleLineOrderQuantity gt wa_p_schl-RoughGoodsReceiptQty.
                            ls_tabl_read-opqty = ls_tabl_read-opqty + ( wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty ).
                        endif.
                    WHEN OTHERS.
                        if wa_p_Schl-ScheduleLineOrderQuantity gt wa_p_schl-RoughGoodsReceiptQty.
                            if ls_tabl_read-opqty gt 0.
                                ls_tabl_read-opqty = ls_tabl_read-opqty + ( wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty ).
                            else.
                                ls_tabl_read-opqty = wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty.
                            endif.
                        endif.
                endcase.
                clear : wa_p_schl.
            endloop.

            loop at it_s_schl into data(wa_s_schl) where SchedulingAgreement = ls_tabl_read-Ebeln
                                                     and SchedulingAgreementItem = ls_tabl_read-Ebelp.
                case wa_s_schl-DelivDateCategory.
                    WHEN '1'.
                        if wa_s_Schl-ScheduleLineOrderQuantity gt wa_s_schl-RoughGoodsReceiptQty.
                            ls_tabl_read-opqty = ls_tabl_read-opqty + ( wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty ).
                        endif.
                    WHEN OTHERS.
                        if wa_s_Schl-ScheduleLineOrderQuantity gt wa_s_schl-RoughGoodsReceiptQty.
                            if ls_tabl_read-opqty gt 0.
                                ls_tabl_read-opqty = ls_tabl_read-opqty + ( wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty ).
                            else.
                                ls_tabl_read-opqty = wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty.
                            endif.
                        endif.
                endcase.
                clear : wa_s_schl.
            endloop.

*            read table it_p_schl into data(wa_p_schl) with key PurchaseOrder = ls_tabl_read-Ebeln
*                                                               PurchaseOrderItem = ls_tabl_read-Ebelp.
*            read table it_s_schl into data(wa_s_schl) with key SchedulingAgreement = ls_tabl_read-Ebeln
*                                                               SchedulingAgreementItem = ls_tabl_read-Ebelp.
*
*            if wa_p_schl is not initial.
*                ls_tabl_read-opqty = wa_p_Schl-ScheduleLineOrderQuantity - wa_p_schl-RoughGoodsReceiptQty.
*            endif.
*
*            if wa_s_schl is not initial.
*                ls_tabl_read-opqty = wa_s_Schl-ScheduleLineOrderQuantity - wa_s_schl-RoughGoodsReceiptQty.
*            endif.

            ls_tabl_read-dmbtr = ls_tabl_read-netpr * ls_tabl_read-menge.

            modify : lt_tabl_read from ls_tabl_read.
             clear : ls_tabl_read.

            free : it_s_schl, it_p_schl, wa_s_schl, wa_p_schl, lt_date.
        endloop.
    endif.

    ct_calculated_data = CORRESPONDING #( lt_tabl_read ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.


  METHOD rba_item.
    if keys_rba is not initial.
        select *
          from zi_gate_item
           for all entries in @keys_rba
         where ebeln eq @keys_rba-ebeln
          into table @data(it_temp).

        if it_temp is not initial.
            result = CORRESPONDING #( it_temp ).
        endif.
    endif.
  ENDMETHOD.


  METHOD read_head.

    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    IF keys IS NOT INITIAL.
      SELECT *
        FROM zi_gate_head
         FOR ALL ENTRIES IN @keys
       WHERE ebeln EQ @keys-ebeln
         and ernam eq @lv_user
        INTO TABLE @DATA(it_temp).

      IF it_temp IS NOT INITIAL.
        result = CORRESPONDING #( it_temp ).
      ENDIF.
    ENDIF.

    free : it_temp, lv_user.
  ENDMETHOD.


  METHOD read_item.

    IF keys IS NOT INITIAL.
      SELECT *
        FROM zi_gate_item
         FOR ALL ENTRIES IN @keys
       WHERE ebeln EQ @keys-ebeln
         AND ebelp EQ @keys-ebelp
        INTO TABLE @DATA(it_temp).

      IF it_temp IS NOT INITIAL.
        result = CORRESPONDING #( it_temp ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD updt_head.
    DATA : it_tabl  TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           wa_tabl  TYPE zdt_gate_man,
           it_htbl  type standard table of zdt_gate_head with default key,
           wa_htbl  type zdt_gate_head,
           lv_lifnr TYPE string,
           lv_xblnr TYPE string,
           lv_zcarr type string,
           lv_zxdat TYPE budat.

    DATA(lo_updt_head) = NEW zcl_gate_crud(  ).

    DATA(lv_cdate) = cl_abap_context_info=>get_system_date( ).

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    data(lv_head) = zcl_clean_table=>clean_gate_head_dt( ).
    data(lv_item) = zcl_clean_table=>clean_gate_man_dt( ).

    if entities is not initial.
      SELECT *
        FROM zi_gate_head
         FOR ALL ENTRIES IN @entities
       WHERE ebeln EQ @entities-ebeln
         and ernam eq @lv_user
        INTO TABLE @DATA(it_head).

      if it_head is not initial.
        SELECT *
          FROM zi_gate_item
           FOR ALL ENTRIES IN @entities
         WHERE ebeln EQ @entities-ebeln
          INTO TABLE @DATA(it_item).

        if it_item is not initial.
          select *
            from I_PurchaseOrderAPI01
             for all entries in @it_item"#EC CI_NO_TRANSFORM
           where PurchaseOrder eq @it_item-ebeln
             and SupplyingPlant is not initial
            into table @data(it_psto).

            if it_psto is not initial.
              select *
                from I_Plant
                 for all entries in @it_psto"#EC CI_NO_TRANSFORM
               where Plant eq @it_psto-SupplyingPlant
                into table @data(it_splnt)."#EC CI_ALL_FIELDS_NEEDED
            endif.

            loop at entities into data(wa_enty).
               loop at it_item into data(wa_item) where ebeln = wa_enty-ebeln.
                    READ TABLE it_head INTO DATA(wa_head) WITH KEY ebeln = wa_item-ebeln.
                    read table it_psto into data(wa_psto) with key PurchaseOrder = wa_item-ebeln.
                    read table it_splnt into data(wa_plnt) with key Plant = wa_psto-SupplyingPlant.

                    CLEAR : lv_lifnr, lv_xblnr, lv_zxdat, lv_zcarr.

                    if wa_head-bsart eq 'ZSTO'.
                        lv_lifnr = wa_psto-SupplyingPlant.
                        lv_xblnr = to_upper( COND #( when wa_enty-%control-xblnr eq '01' then wa_enty-xblnr
                                           else COND #( WHEN wa_head-xblnr is initial then wa_item-xblnr
                                                        ELSE wa_head-xblnr ) ) ).
                        lv_zxdat = COND #( when wa_enty-%control-zxdat eq '01' then wa_enty-zxdat
                                           else COND #( WHEN wa_head-zxdat is initial then wa_item-zxdat
                                                        ELSE wa_head-zxdat ) ).
                    elseif wa_head-bsart ne 'ZSTO'.
                        lv_lifnr = wa_head-lifnr.
                        lv_xblnr = to_upper( COND #( when wa_enty-%control-xblnr eq '01' then wa_enty-xblnr
                                           else COND #( WHEN wa_head-xblnr is initial then wa_item-xblnr
                                                        ELSE wa_head-xblnr ) ) ).
                        lv_zxdat = COND #( when wa_enty-%control-zxdat eq '01' then wa_enty-zxdat
                                           else COND #( WHEN wa_head-zxdat is initial then wa_item-zxdat
                                                        ELSE wa_head-zxdat ) ).
                    endif.

                    lv_zcarr = COND #( when wa_enty-%control-zcarr eq '01' then wa_enty-zcarr
                                       else wa_head-zcarr ).

                    CALL METHOD lo_updt_head->gate_dupl
                        EXPORTING
                          ip_lifnr = lv_lifnr
                          ip_xblnr = lv_xblnr
                          ip_zxdat = lv_zxdat
                        IMPORTING
                          ep_gedat = DATA(lt_gdat).

                      if lt_gdat is not initial.
                        loop at lt_gdat into data(wa_gdat).
                            if wa_gdat-zstat eq 'X'.
                                delete lt_gdat where zrgno eq wa_gdat-zrgno.
                            elseif wa_gdat-zstat eq space.
                                continue.
                            endif.
                        endloop.
                      endif.

                    if lt_gdat is not initial.
                        LOOP AT lt_gdat INTO DATA(ls_dupl).
                          error = VALUE #( ( |Entry { ls_dupl-zrgno } Exist for { ls_dupl-xblnr }| ) ).
                          CLEAR : ls_dupl.
                        ENDLOOP.
                    elseif lt_gdat is initial.
                       if lv_zxdat gt lv_cdate.
                          error = VALUE #( ( |Invoice Date is in Future| ) ).
                       elseif lv_zxdat le lv_cdate.
                          wa_tabl-sap_uuid = zcl_gate_head=>get_uuid( ).
                          wa_tabl-bukrs    = wa_head-bukrs.
                          wa_tabl-ebeln    = wa_item-ebeln.
                          wa_tabl-ebelp    = wa_item-ebelp.
                          wa_tabl-erdat    = wa_head-erdat.
                          wa_tabl-ernam    = wa_head-ernam.
                          wa_tabl-erzet    = wa_head-erzet.
                          wa_tabl-werks    = wa_item-werks.
                          wa_tabl-lgort    = wa_item-lgort.
                          if wa_head-bsart eq 'ZSTO'.
                              wa_tabl-lifnr    = wa_psto-SupplyingPlant.
                              wa_tabl-vname    = wa_plnt-PlantName.
                              wa_tabl-zgcat    = 'STO'.
                          elseif wa_head-bsart ne 'ZSTO'.
                              wa_tabl-lifnr    = wa_head-lifnr.
                              wa_tabl-vname    = wa_head-lname.
                              wa_tabl-zgcat    = wa_head-zgcat.
                          endif.
                          wa_tabl-xblnr    = lv_xblnr.
                          wa_tabl-zxdat    = lv_zxdat.
                          wa_tabl-zcarr    = lv_zcarr.

                          wa_tabl-opqty    = zcl_gate_head=>get_oqty( ip_ebeln = wa_tabl-ebeln
                                                                      ip_ebelp = wa_tabl-ebelp
                                                                      ip_zxdat = wa_tabl-zxdat ).
                          wa_tabl-lsmeh    = zcl_gate_head=>get_unit( ip_unit = wa_item-meins ). "wa_item-meins.
                          wa_tabl-matnr    = wa_item-matnr.
                          wa_tabl-txz01    = wa_item-maktx.
                          wa_tabl-zmdir    = wa_head-zmdir.
                          wa_tabl-zrgno    = ''.
                          wa_tabl-ztext    = 'Ready to Post'. "wa_item-ztext.


                          append : wa_tabl to it_tabl.
                           clear : wa_tabl, lv_xblnr, lv_lifnr, lv_zxdat, lv_zcarr,
                                   wa_item, wa_head, wa_psto, wa_plnt.
                       endif.
                    endif.
                    free : lt_gdat.
               endloop.
               clear : wa_enty.
            endloop.

            free : it_head, it_item, it_psto, it_splnt.
        endif.
      endif.

      if it_tabl is not initial.
        CALL METHOD zcl_clean_table=>clean_gate_head_dt( ).
        CALL METHOD zcl_clean_table=>clean_gate_man_dt( ).

        it_htbl = CORRESPONDING #( it_tabl ).
        delete ADJACENT DUPLICATES FROM it_htbl COMPARING ebeln.

        INSERT zdt_gate_head from table @it_htbl.
        INSERT zdt_gate_man FROM TABLE @it_tabl.
        success = VALUE #( ( | Data Updated - Header | ) ).
      endif.
    endif.
    clear : lv_user.
  ENDMETHOD.


  METHOD updt_item.
    DATA : it_tabl TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           wa_tabl TYPE zdt_gate_man,
           lt_head type standard table of zdt_gate_head with default key,
           lv_menge type menge_d.

    DATA(lo_updt_item) = NEW zcl_gate_crud(  ).
    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    if entities is not initial.
      SELECT *
        FROM zc_gate_item"#EC CI_ALL_FIELDS_NEEDED
         FOR ALL ENTRIES IN @entities
       WHERE ebeln EQ @entities-ebeln
         AND ebelp EQ @entities-ebelp
        INTO TABLE @DATA(it_item).

      select *
        from zdt_gate_head"#EC CI_ALL_FIELDS_NEEDED
         for all entries in @entities
       where ebeln eq @entities-ebeln
         and ernam eq @lv_user
        into table @lt_head.

      SELECT *
        FROM zdt_gate_man
         FOR ALL ENTRIES IN @entities
       WHERE ebeln EQ @entities-ebeln
         AND ebelp EQ @entities-ebelp
         and ernam eq @lv_user
        INTO TABLE @it_tabl."#EC CI_ALL_FIELDS_NEEDED

      loop at entities into data(wa_enty).
        loop at it_tabl into wa_tabl where ebeln = wa_enty-ebeln
                                       and ebelp = wa_enty-ebelp.
          read table it_item into data(wa_item) with key ebeln = wa_tabl-ebeln
                                                         ebelp = wa_tabl-ebelp.

            lv_menge = COND #( when wa_enty-%control-menge eq '01' then wa_enty-menge
                               else wa_item-menge ).

*            if lv_menge gt wa_item-opqty.
*                 error = VALUE #( ( |{ lv_menge } > { wa_item-opqty }| )
*                                  ( |Entered Qty is Greater than Open Qty| ) ).
*            elseif lv_menge le wa_item-opqty.
                wa_tabl-lsmng = lv_menge.
                modify : it_tabl from wa_tabl.

                update zdt_gate_man
                   set lsmng = @wa_tabl-lsmng
                 where sap_uuid = @wa_tabl-sap_uuid
                   and ebeln    = @wa_tabl-ebeln
                   and ebelp    = @wa_tabl-ebelp.

                success = VALUE #( ( |Data Updated - Item| ) ).
*            endif.
          clear : wa_item, lv_menge, wa_tabl.
        endloop.
      endloop.
    endif.
    clear : lv_user.
  ENDMETHOD.


  METHOD GET_MONTH_DATES.
    data : lv_first_day type d,
           lv_last_day type d.

    lv_first_day = ip_sydate.

    lv_first_day+6(2) = '01'.

    lv_last_day = lv_first_day + 31.

    lv_last_day+6(2) = '01'. "forcefully make it one.

    lv_last_day = lv_last_day - 1. "to get the last day of month.

    rt_date = VALUE #( ( sign       = 'I'
                         option     = 'BT'
                         low        = lv_first_day
                         high       = lv_last_day ) ).
  ENDMETHOD.
ENDCLASS.
