CLASS lhc_buffer DEFINITION.
  PUBLIC SECTION.

    TYPES : BEGIN OF ty_buff.
              INCLUDE TYPE zdt_gate_man AS data.
    TYPES :   stats TYPE c LENGTH 6,
            END OF ty_buff.

    TYPES tt_buff TYPE TABLE OF ty_buff WITH DEFAULT KEY.

    CLASS-DATA mt_buff TYPE tt_buff.

ENDCLASS.

CLASS lhc_ZI_GATE_HEAD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gate_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gate_head RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_gate_head.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_gate_head RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_gate_head.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ zi_gate_head\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cretgate FOR MODIFY
      IMPORTING keys FOR ACTION zi_gate_head~cretgate RESULT result.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE zi_gate_head.

    METHODS precheck_cretgate FOR PRECHECK
      IMPORTING keys FOR ACTION zi_gate_head~cretgate.

ENDCLASS.

CLASS lhc_ZI_GATE_HEAD IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_gate_head IN LOCAL MODE
    ENTITY zi_gate_head
    FIELDS ( zrgno ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    IF lt_result IS NOT INITIAL.

      result =  VALUE #( FOR ls_result IN lt_result
                        LET status = COND #( WHEN ls_result-zrgno IS NOT INITIAL
                                             THEN if_abap_behv=>fc-o-disabled
                                             ELSE if_abap_behv=>fc-o-enabled )

                        IN ( %tky = ls_result-%tky %action-cretgate = status )

                         ).
    ENDIF.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD update.
    data : error type string_table,
           success type string_table.

    data(lo_updt) = new zcl_gate_head(  ).

    free : error, success.

    call method lo_updt->updt_head
      EXPORTING
        entities = entities
      IMPORTING
        error    = error
        success  = success
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported.

    if error is not initial.
        loop at error into data(ls_error).
            APPEND VALUE #( %key-ebeln = entities[ 1 ]-%key-ebeln ) TO failed-zi_gate_head.
            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = ls_error )
                        ) TO reported-zi_gate_head.
        endloop.
    endif.

    if success is not initial.
*        loop at success into data(ls_success).
*            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                              text     = ls_success )
*            ) TO reported-zi_gate_head.
*        endloop.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                              text     = |Data Updated| )
                      ) TO reported-zi_gate_head.
    endif.
  ENDMETHOD.

  METHOD read.
    data(lo_read) = new zcl_gate_head(  ).

    if keys is not initial.
        call method lo_read->read_head
          EXPORTING
            keys     = keys
          CHANGING
            result   = result
            failed   = failed
            reported = reported .
    endif.
  ENDMETHOD.

  METHOD lock.
    TRY.
        data(lo_lock) = cl_abap_lock_object_factory=>get_instance( iv_name =  'EZMAN_GATE' ).
      CATCH cx_abap_lock_failure into data(lx_lock).
        "handle exception

    ENDTRY.

    loop at keys into data(ls_keys).
        TRY.
            call method lo_lock->enqueue
              EXPORTING
*                it_table_mode =
                it_parameter  = VALUE #( ( name = 'EBELN' value = REF #( ls_keys-ebeln ) ) )
*                _scope        =
*                _wait         =
              .
            CATCH cx_abap_foreign_lock into data(lx_for_lock).
                APPEND VALUE #( %msg = new_message(
                                         id       = 'ZMCL_MAN_GATE'
                                         number   = '001'
                                         severity = IF_ABAP_BEHV_MESSAGE=>severity-error
                                         v1       = lx_for_lock->user_name
                                         v2       = ls_keys-ebeln
*                                         v3       =
*                                         v4       =
                                       ) ) to reported-zi_gate_head.
            CATCH cx_abap_lock_failure into data(lx_lock_fail).
        ENDTRY.
    endloop.
  ENDMETHOD.

  METHOD rba_Item.
    data(lo_rbai) = new ZCL_GATE_HEAD(  ).

    call method lo_rbai->rba_item
      EXPORTING
        keys_rba          = keys_rba
        result_requested  = result_requested
      CHANGING
        result            = result
        association_links = association_links
        failed            = failed
        reported          = reported.
  ENDMETHOD.

  METHOD cretgate.
    data : error type string_table,
           success type string_table,
           record type standard table of zdt_gate_man with default key,
           lv_rels type c length 1.

    data(lo_cret) = new zcl_gate_head(  ).

    free : record, success, error.

    if keys is not initial.
        call method lo_cret->cretgate
          EXPORTING
            keys     = keys
          IMPORTING
            error    = error
            success  = success
            record   = record
          CHANGING
            result   = result
            mapped   = mapped
            failed   = failed
            reported = reported .

        if error is not initial.
            loop at keys into data(ls_keys).
                APPEND VALUE #( %key-ebeln = ls_keys-ebeln ) to failed-zi_gate_head.
                clear : ls_keys.
            endloop.

            loop at error into data(ls_error).
                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = ls_error )
                            ) TO reported-zi_gate_head.
            endloop.
        endif.

        if success is not initial.
            loop at success into data(ls_success).
                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                  text     = ls_success )
                ) TO reported-zi_gate_head.
            endloop.
        endif.

        if record is not initial and error is initial.
           LOOP AT record INTO DATA(wa_cret).
             if wa_cret-zrgno is not initial.
              INSERT VALUE #( stats = 'CRTDAT' data = CORRESPONDING #( wa_cret ) ) INTO TABLE lhc_buffer=>mt_buff.
             endif.
           ENDLOOP.
        endif.

    else.
       APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                     text     = 'Please Select the record' )
                     ) TO reported-zi_gate_head.
    endif.
  ENDMETHOD.

  METHOD precheck_update.
    data : lv_fchar type string,
           lv_lchar type string,
           lv_xblnr type string,
           lv_zcarr type string,
           lv_strln type i,
           lv_budat type budat,
           lv_lifnr type string,
           lv_zxdat type budat,
           lv_msg type string,
           lv_rels type c length 1,
           lv_flag type c length 1.

    data(lo_gcbo) = new zcl_gate_crud(  ).

    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

     if entities is not initial.
        select *
          from zi_gate_head
           for all entries in @entities
         where ebeln eq @entities-ebeln
          into table @data(it_dupl).

        if it_dupl is not initial.
            loop at it_dupl into data(wa_dupl).
                if wa_dupl-ernam ne lv_user.
                      lv_flag = 'X'.
                      APPEND VALUE #( %key-ebeln = wa_dupl-ebeln ) to failed-zi_gate_head.

                      APPEND VALUE #( %msg = new_message(
                                               id       = 'ZMCL_MAN_GATE'
                                               number   = '001'
                                               severity = IF_ABAP_BEHV_MESSAGE=>severity-error
                                               v1       = wa_dupl-ernam
                                               v2       = wa_dupl-ebeln
                                             )
                                    ) TO reported-zi_gate_head.
                endif.
                clear : wa_dupl.
            endloop.
        endif.

        if lv_flag eq space.
            select *
              from zi_gate_head
               for all entries in @entities
             where ebeln eq @entities-ebeln
               and ernam eq @lv_user
              into table @data(it_tabl).

            select *
              from zdt_gate_head
               for all entries in @entities
             where ebeln eq @entities-ebeln
               and ernam eq @lv_user
              into table @data(it_dtab).

            SELECT PurchaseOrder,
                   ReleaseIsNotCompleted
              FROM I_PurchaseOrderAPI01
               FOR ALL ENTRIES IN @entities
             WHERE PurchaseOrder EQ @entities-ebeln
              INTO TABLE @DATA(it_prel).

            if it_prel is initial.
                select SchedulingAgreement,
                       ReleaseIsNotCompleted
                  from I_SchedgAgrmtHdrTP_2
                   for all entries in @entities "#EC CI_FAE_LINES_ENSURED
                 where SchedulingAgreement eq @entities-ebeln
                  into table @data(it_srel)."#EC CI_ALL_FIELDS_NEEDED
            endif.

            loop at entities into data(wa_enty).
              loop at it_tabl into data(wa_tabl) where ebeln eq wa_enty-ebeln.
                read table it_dtab into data(wa_dtab) with key ebeln = wa_enty-ebeln.
                read table it_prel into data(wa_prel) with key PurchaseOrder = wa_tabl-ebeln.
                if wa_prel is initial.
                   read table it_srel into data(wa_srel) with key SchedulingAgreement = wa_tabl-ebeln.
                   lv_rels = wa_srel-ReleaseIsNotCompleted.
                elseif wa_prel is not initial.
                   lv_rels = wa_prel-ReleaseIsNotCompleted.
                endif.

                if lv_rels eq space.
                    lv_xblnr = COND #( when wa_enty-%control-xblnr eq '01' then wa_enty-xblnr
                                       else COND #( WHEN wa_tabl-xblnr is initial then wa_dtab-xblnr
                                                    else wa_tabl-xblnr ) ).

                    lv_zxdat = COND #( when wa_enty-%control-zxdat eq '01' then wa_enty-zxdat
                                       else COND #( WHEN wa_tabl-zxdat is initial then wa_dtab-zxdat
                                                    else wa_tabl-zxdat ) ).

                    lv_zcarr = COND #( when wa_enty-%control-zcarr eq '01' then wa_enty-zcarr
                                       else COND #( WHEN wa_tabl-zcarr is initial then wa_dtab-zcarr
                                                    else wa_tabl-zcarr ) ).

                    if lv_xblnr is not initial.
                        lv_strln = strlen( lv_xblnr ).
                        lv_fchar = lv_xblnr(1).
                        lv_strln = lv_strln - 1.
                        lv_lchar = lv_xblnr+lv_strln(1).

                        if lv_fchar ca ',./;:|!@#$%^&*_+=~|\[{]}()"'.
                          APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Spl Char : ,./;:|!@#$%^&*_+=~|\[{]}()"' )
                                        ) TO reported-zi_gate_head.
                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Spl Char Not Allowed before Inv.' )
                                        ) TO reported-zi_gate_head.
                        endif.
                        if lv_lchar ca ',./;:|!@#$%^&*_+=~|\[{]}()'.
                          APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Spl Char : ,./;:|!@#$%^&*_+=~|\[{]}()"' )
                                        ) TO reported-zi_gate_head.
                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Spl Char Not Allowed After Inv.' )
                                        ) TO reported-zi_gate_head.
                        endif.
                    elseif lv_xblnr is initial.
                          APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Please Enter / Re-enter the Inv No' )
                                        ) TO reported-zi_gate_head.
                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Inv No is Mandatory in Update' )
                                        ) TO reported-zi_gate_head.
                    endif.

                    if lv_zxdat is not initial.
                        lv_budat = cl_abap_context_info=>get_system_date( ).

                        if lv_zxdat gt lv_budat.
                          APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Inv Date cannot be in Future.' )
                                        ) TO reported-zi_gate_head.
                        endif.
                    elseif lv_zxdat is initial .
                          APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Please Enter / Re-enter the Inv Date' )
                                        ) TO reported-zi_gate_head.
                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Inv Date is Mandatory in Update' )
                                        ) TO reported-zi_gate_head.
                    endif.
                elseif lv_rels eq 'X'.
                   APPEND VALUE #( %key-ebeln = wa_enty-ebeln ) to failed-zi_gate_head.

                   APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = |PO { wa_enty-ebeln } is not released| )
                                 ) TO reported-zi_gate_head.
                endif.
*                if lv_zcarr is initial.
*                      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                    text     = 'Please Enter / Re-enter the Vehicle No' )
*                                    ) TO reported-zi_gate_head.
*                      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                    text     = 'Vehicle No is Mandatory in Update' )
*                                    ) TO reported-zi_gate_head.
*                endif.
*                free : lt_gdat.
                clear : wa_tabl,lv_xblnr, lv_strln, lv_fchar, lv_lchar,
                        lv_budat, wa_tabl, lv_lifnr, lv_zxdat, lv_zcarr,
                        wa_dtab, lv_rels, wa_prel, wa_srel.

              endloop.
              clear : wa_enty.
            endloop.
        endif.
        free : it_prel, it_srel, it_dtab, it_tabl, lv_user.
     endif.
  ENDMETHOD.

  METHOD precheck_cretgate.
    data : lv_lifnr type string,
           lv_xblnr type string,
           lv_zxdat type budat,
           lv_msg type string,
           lv_rels type c length 1.

    if keys is not initial.
        DATA(lo_gcbo) = NEW zcl_gate_crud(  ).

        data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

        read table keys into data(ls_key) index 1.


        select *
          from zdt_gate_head
           for all entries in @keys
         where ebeln eq @keys-ebeln
           and ernam eq @lv_user
          into table @data(it_tabl).

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

        if it_tabl is not initial.

            select *
              from zdt_gate_man
               for all entries in @it_tabl
             where ebeln eq @it_tabl-ebeln
               and ernam eq @lv_user
               and lsmng gt 0
              into table @data(it_item).

            loop at it_tabl into data(wa_tabl).
*               read table it_prel into data(wa_prel) with key PurchaseOrder = wa_tabl-ebeln.
*               if wa_prel is initial.
*                  read table it_srel into data(wa_srel) with key SchedulingAgreement = wa_tabl-ebeln.
*                  lv_rels = wa_srel-ReleaseIsNotCompleted.
*               elseif wa_prel is not initial.
*                  lv_rels = wa_prel-ReleaseIsNotCompleted.
*               endif.
*
*               if lv_rels eq space.
                   if wa_tabl-xblnr is not initial.
                      lv_lifnr = wa_tabl-lifnr.
                      lv_xblnr = wa_tabl-xblnr.
                      lv_zxdat = wa_tabl-zxdat.

                      call method lo_gcbo->gate_dupl
                        EXPORTING
                          ip_lifnr = lv_lifnr
                          ip_xblnr = lv_xblnr
                          ip_zxdat = lv_zxdat
                        IMPORTING
                          ep_gedat = data(lt_gdat).

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
                        loop at lt_gdat into data(ls_gdat).
                          APPEND VALUE #( %key-ebeln = ls_key-ebeln ) to failed-zi_gate_head.

                          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = |Entry { ls_gdat-zrgno } exists for { ls_gdat-xblnr }| )
                                        ) TO reported-zi_gate_head.
                          clear : ls_gdat.
                        endloop.
                      endif.
                   else.
                      APPEND VALUE #( %key-ebeln = ls_key-ebeln ) to failed-zi_gate_head.

                      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Please Enter Inv No' )
                                    ) TO reported-zi_gate_head.
                   endif.

                   if it_item is not initial.
                        loop at it_item into data(wa_item) where ebeln = wa_tabl-ebeln.
*                            if wa_item-lsmng eq 0.
*                              APPEND VALUE #( %key-ebeln = ls_key-ebeln ) to failed-zi_gate_head.
*
*                              APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                            text     = 'Invoice Qty should be greater than 0' )
*                                            ) TO reported-zi_gate_head.
*                            endif.

                            if wa_item-opqty lt wa_item-lsmng.
                              APPEND VALUE #( %key-ebeln = ls_key-ebeln ) to failed-zi_gate_head.

                              APPEND VALUE #( %msg = new_message(   id       = 'ZMCL_MAN_GATE'
                                                                    number   = '002'
                                                                    severity = if_abap_behv_message=>severity-error
                                                                    v1       = wa_item-lsmng
                                                                    v2       = wa_item-opqty
                                                     ) ) TO reported-zi_gate_head.
                            endif.
                            clear : wa_item.
                        endloop.
                   endif.
*               elseif lv_rels eq 'X'.
*                  APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                text     = |PO { wa_tabl-ebeln } is not released| )
*                                ) TO reported-zi_gate_head.
*               endif.
               free : lt_gdat, it_prel, it_srel.
               clear : ls_gdat, lv_lifnr, lv_xblnr, lv_zxdat, wa_tabl, lv_rels.
            endloop.
            free : it_tabl, lv_user, it_item.
        endif.
    else.
      APPEND VALUE #( %key-ebeln = ls_key-ebeln ) to failed-zi_gate_head.

      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text     = 'Please Select a Record' )
                    ) TO reported-zi_gate_head.
    endif.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_GATE_ITEM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gate_item RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_gate_item.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_gate_item RESULT result.

    METHODS rba_Head FOR READ
      IMPORTING keys_rba FOR READ zi_gate_item\_Head FULL result_requested RESULT result LINK association_links.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE ZI_GATE_ITEM.

ENDCLASS.

CLASS lhc_ZI_GATE_ITEM IMPLEMENTATION.

  METHOD get_instance_features.
*    READ ENTITIES OF zi_gate_head IN LOCAL MODE
*    ENTITY zi_gate_item
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_result_item).
*
*    IF lt_result_item IS NOT INITIAL.
*      result =  VALUE #(  FOR ls_result_item IN lt_result_item
*                            LET status = COND #( WHEN ls_result_item-zrgno IS NOT INITIAL
*                                             THEN if_abap_behv=>fc-o-disabled
*                                             ELSE if_abap_behv=>fc-o-enabled )
*
*                            IN ( %tky = ls_result_item-%tky %update = status )
*
*                         ).
*    ENDIF.
  ENDMETHOD.

  METHOD update.
    data : error type string_table,
           success type string_table.

    data(lo_updt) = new zcl_gate_head(  ).

    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    free : error, success.

    read table entities into data(ls_enty) index 1.

    select
    single ebeln,
           xblnr
      from zdt_gate_head
     where ebeln eq @ls_enty-ebeln
       and ernam eq @lv_user
      into @data(ls_head).


    if ls_head-xblnr is not initial.
        call method lo_updt->updt_item
          EXPORTING
            entities = entities
          IMPORTING
            error    = error
            success  = success
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported.
    else.
        APPEND VALUE #( %key-ebeln = entities[ 1 ]-%key-ebeln ) TO failed-zi_gate_head.

        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = |Please Fill Header Editable Data| )
                    ) TO reported-zi_gate_head.
    endif.

    if error is not initial.
        loop at error into data(ls_error).
            APPEND VALUE #( %key-ebeln = entities[ 1 ]-%key-ebeln ) TO failed-zi_gate_head.

            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = ls_error )
                        ) TO reported-zi_gate_head.
        endloop.
    endif.

    if success is not initial.
*        loop at success into data(ls_success).
*            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                              text     = ls_success )
*            ) TO reported-zi_gate_head.
*        endloop.
    endif.
    clear : ls_enty, ls_head, lv_user.
  ENDMETHOD.

  METHOD read.
    data(lo_read) = new zcl_gate_head(  ).

    call method lo_read->read_item
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported.
  ENDMETHOD.

  METHOD rba_Head.
  ENDMETHOD.

  METHOD precheck_update.
    types : begin of ty_menge,
              ebeln type ebeln,
              ebelp type ebelp,
              menge type menge_d,
            end of ty_menge.

    data : wa_quan type ty_menge,
           it_quan type standard table of ty_menge with default key.

    if entities is not initial.
        loop at entities into data(wa_enty).
          wa_quan-menge = COND #( WHEN wa_enty-%control-menge eq '01' then wa_enty-menge ).
          wa_quan-ebeln = wa_enty-ebeln.
          wa_quan-ebelp = wa_enty-ebelp.

          append : wa_quan to it_quan.
           clear : wa_quan.
        endloop.

        delete it_quan where menge eq 0.

        if it_quan is initial.
          APPEND VALUE #( %key-ebeln = entities[ 1 ]-%key-ebeln ) to failed-zi_gate_head.

          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                              text     = |Please Enter / Re-enter Quantity| )
            ) TO reported-zi_gate_head.
        endif.
    endif.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_GATE_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_GATE_HEAD IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.

  ENDMETHOD.

  METHOD save.
    data : it_tabl type STANDARD TABLE OF zdt_gate_man with default key,
           wa_tabl type zdt_gate_man.

    free : it_tabl.

    data(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    if lhc_buffer=>mt_buff is not initial.
        loop at lhc_buffer=>mt_buff into data(wa_buff).
            if wa_buff-stats eq 'CRTDAT'.
                select *
                  from zdt_gate_man
                 where ebeln eq @wa_buff-ebeln
                   and ebelp eq @wa_buff-ebelp
                   and ernam eq @lv_user
                  into table @data(it_temp).

                select *
                  from zdt_gate_head
                 where ebeln eq @wa_buff-ebeln
                   and ernam eq @lv_user
                  into table @data(it_head)."#EC CI_ALL_FIELDS_NEEDED

                if it_temp is not initial.
                    loop at it_temp into data(wa_temp).
                        wa_temp-zrgno = wa_buff-zrgno.
                        wa_temp-ztext = wa_buff-ztext.
                        if wa_temp-zrgno is not initial.
*                            CONCATENATE 'Gate Entry' wa_temp-zrgno 'Posted' wa_temp-ebeln wa_temp-ebelp into data(lv_msg) SEPARATED BY space.
*                            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                                                          text     = |For Invoice { wa_temp-xblnr }| )
*                                           ) TO reported-zi_gate_head.
                            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                          text     = |For { wa_temp-ebeln } - { wa_temp-ebelp }| )
                                           ) TO reported-zi_gate_head.
*                            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                                                          text     = |Gate Entry { wa_temp-zrgno } Posted| )
*                                           ) TO reported-zi_gate_head.
                            if wa_temp-ztext is not initial.
                                update zdt_gate_man
                                   set zrgno = @wa_temp-zrgno,
                                       ztext = @wa_temp-ztext
                                 where sap_uuid = @wa_temp-sap_uuid.

                            elseif wa_temp-ztext is initial.
                                update zdt_gate_man
                                   set zrgno = @wa_temp-zrgno,
                                       ztext = 'Gate Entry Created'
                                 where sap_uuid = @wa_temp-sap_uuid.
                            endif.
                        endif.
                        modify : it_temp from wa_temp.
                        clear : wa_temp." lv_msg.
                    endloop.

                    loop at it_head into data(wa_head).
                      wa_head-zrgno = wa_buff-zrgno.
                      wa_head-ztext = wa_buff-ztext.
                      modify : it_head from wa_head.
                      if wa_head-zrgno is not initial.
                          update zdt_gate_head
                             set zrgno = @wa_head-zrgno,
                                 ztext = @wa_head-ztext
                           where sap_uuid = @wa_head-sap_uuid.
                      endif.
                      clear : wa_head.
                    endloop.
                    free : it_temp, it_head.
                endif.
            endif.
            clear : wa_buff.
        endloop.

        read table lhc_buffer=>mt_buff into wa_buff index 1.

        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                      text     = |For Invoice - { wa_buff-xblnr }| )
                       ) TO reported-zi_gate_head.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                      text     = |Gate Entry { wa_buff-zrgno } Posted| )
                       ) TO reported-zi_gate_head.

    endif.
    clear : lv_user.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
