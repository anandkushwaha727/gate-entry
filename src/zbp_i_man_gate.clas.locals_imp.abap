CLASS lhc_buffer DEFINITION.
  PUBLIC SECTION.

    TYPES : BEGIN OF ty_buff.
              INCLUDE TYPE zdt_gate_man AS data.
    TYPES :   stats TYPE c LENGTH 6,
            END OF ty_buff.

    TYPES tt_buff TYPE TABLE OF ty_buff WITH DEFAULT KEY.

    CLASS-DATA mt_buff TYPE tt_buff.

ENDCLASS.

CLASS lhc_ZI_MAN_GATE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_man_gate RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_man_gate RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_man_gate RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_man_gate.

    METHODS addline FOR MODIFY
      IMPORTING keys FOR ACTION zi_man_gate~addline.

    METHODS cretgate FOR MODIFY
      IMPORTING keys FOR ACTION zi_man_gate~cretgate RESULT result.

    METHODS getdata FOR MODIFY
      IMPORTING keys FOR ACTION zi_man_gate~getdata.

ENDCLASS.

CLASS lhc_ZI_MAN_GATE IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_man_gate IN LOCAL MODE
    ENTITY zi_man_gate
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

  METHOD read.
    DATA(lo_read) = NEW zcl_man_gate(  ).

    CALL METHOD lo_read->read
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD addline.
    TYPES : BEGIN OF ty_param,
              xblnr TYPE string,
              zxdat TYPE budat,
              lifnr TYPE lifnr,
              vehno TYPE string,
              matnr TYPE matnr,
              puord TYPE ebeln,
              schag TYPE ebeln,
              menge TYPE p LENGTH 13 DECIMALS 2,
            END OF ty_param.

    DATA : record   TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           exist    TYPE c,
           wa_param TYPE ty_param,
           it_param TYPE STANDARD TABLE OF ty_param WITH DEFAULT KEY.


    DATA(lo_addl) = NEW zcl_man_gate(  ).

    FREE : record, exist.

    SELECT *
      FROM zi_man_gate
      INTO TABLE @DATA(it_data)."#EC CI_NOWHERE

    IF it_data IS NOT INITIAL.
      IF keys IS NOT INITIAL.
        READ TABLE keys INTO DATA(wa_parm) INDEX 1.
        wa_param-lifnr = wa_parm-%param-vendor.
        wa_param-matnr = wa_parm-%param-product.
        wa_param-menge = wa_parm-%param-menge.
        wa_param-puord = wa_parm-%param-puord.
        wa_param-schag = wa_parm-%param-schag.
        wa_param-vehno = wa_parm-%param-vehno.
        wa_param-xblnr = wa_parm-%param-xblnr.
        wa_param-zxdat = wa_parm-%param-zxdat.
      ENDIF.

      IF wa_param IS NOT INITIAL.
        IF wa_param-matnr IS NOT INITIAL AND
           wa_param-menge GT 0 AND
           wa_param-puord IS NOT INITIAL OR
           wa_param-schag IS NOT INITIAL.

          lo_addl->addline(
            EXPORTING
              keys     = keys
            IMPORTING
              record   = record
              exist    = exist
            CHANGING
              mapped   = mapped
              failed   = failed
              reported = reported
          ).

          IF record IS NOT INITIAL.
            LOOP AT record INTO DATA(wa_rec).
              IF exist EQ 'X'.
                CONCATENATE 'For Material' wa_rec-matnr 'and PO' wa_rec-ebeln INTO DATA(lv_exit) SEPARATED BY space.
                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_exit )
                            ) TO reported-zi_man_gate.
                APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = 'Record Already Exists' )
                            ) TO reported-zi_man_gate.
              ELSE.
                IF exist EQ space.
                  IF wa_rec-zrgno IS INITIAL.
                    INSERT VALUE #( stats = 'ADDDAT' data = CORRESPONDING #( wa_rec ) ) INTO TABLE lhc_buffer=>mt_buff.
                  ENDIF.
                ENDIF.
              ENDIF.
              CLEAR : wa_rec.
            ENDLOOP.
          ENDIF.
        ELSE.
          IF   wa_param-matnr IS INITIAL.
            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = 'Please Enter Material No' )
                        ) TO reported-zi_man_gate.
          ENDIF.

          IF   wa_param-menge LE 0.
            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = 'Please Enter Quantity' )
                        ) TO reported-zi_man_gate.
          ENDIF.

          IF   wa_param-puord IS INITIAL AND
               wa_param-schag IS INITIAL.
            APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = 'Please Enter PO Or Scheduling Agreement No' )
                        ) TO reported-zi_man_gate.
          ENDIF.
        ENDIF.
      ELSE.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Please Enter Parameter Values' )
                         ) TO reported-zi_man_gate.
      ENDIF.
    ELSE.
      IF it_data IS INITIAL.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Please Click on Enter INV Details' )
                         ) TO reported-zi_man_gate.
      ENDIF.
    ENDIF.
    CLEAR : wa_param.
    FREE : it_param.
  ENDMETHOD.

  METHOD cretgate.
    DATA : cret_record TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           it_select   TYPE STANDARD TABLE OF zi_man_gate WITH DEFAULT KEY.

    DATA(lo_cman) = NEW zcl_man_gate(  ).

    FREE : cret_record.

    IF keys IS NOT INITIAL.
      lo_cman->cretgate(
        EXPORTING
          keys     = keys
        IMPORTING
          record   = cret_record
        CHANGING
          result   = result
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

      IF cret_record IS NOT INITIAL.
        LOOP AT cret_record INTO DATA(wa_cret).
          INSERT VALUE #( stats = 'CRTDAT' data = CORRESPONDING #( wa_cret ) ) INTO TABLE lhc_buffer=>mt_buff.
        ENDLOOP.
      ENDIF.
    ELSE.
      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                    text     = 'Please Select the record' )
                  ) TO reported-zi_man_gate.
    ENDIF.
  ENDMETHOD.

  METHOD getdata.
    TYPES : BEGIN OF ty_param,
              xblnr TYPE string,
              zxdat TYPE budat,
              lifnr TYPE lifnr,
              vehno TYPE string,
              matnr TYPE matnr,
              puord TYPE ebeln,
              schag TYPE ebeln,
              menge TYPE p LENGTH 13 DECIMALS 2,
            END OF ty_param.

    DATA : record   TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           exist    TYPE c,
           wa_param TYPE ty_param,
           it_param TYPE STANDARD TABLE OF ty_param WITH DEFAULT KEY.


    DATA(lo_data) = NEW zcl_man_gate(  ).

    FREE : record.

    call method zcl_clean_table=>clean_gate_man_dt( ).

    IF keys IS NOT INITIAL.
      READ TABLE keys INTO DATA(wa_parm) INDEX 1.
      wa_param-lifnr = wa_parm-%param-vendor.
      wa_param-matnr = wa_parm-%param-product.
      wa_param-menge = wa_parm-%param-menge.
      wa_param-puord = wa_parm-%param-puord.
      wa_param-schag = wa_parm-%param-schag.
      wa_param-vehno = wa_parm-%param-vehno.
      wa_param-xblnr = wa_parm-%param-xblnr.
      wa_param-zxdat = wa_parm-%param-zxdat.
    ENDIF.

    IF wa_param IS NOT INITIAL.
      IF wa_param-xblnr IS NOT INITIAL AND
         wa_param-zxdat IS NOT INITIAL AND
         wa_param-vehno IS NOT INITIAL AND
         wa_param-matnr IS NOT INITIAL AND
         wa_param-menge GT 0 AND
         wa_param-puord IS NOT INITIAL OR
         wa_param-schag IS NOT INITIAL.

        lo_data->getdata(
          EXPORTING
            keys     = keys
          IMPORTING
            record   = record
            avail    = exist
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported
        ).

        IF record IS NOT INITIAL.
          LOOP AT record INTO DATA(wa_rec).
            IF exist EQ 'X'.
              INSERT VALUE #( stats = 'EXIST' data = CORRESPONDING #( wa_rec ) ) INTO TABLE lhc_buffer=>mt_buff.
            ELSE.
              IF exist EQ space.
                IF wa_rec-zrgno IS INITIAL.
                  INSERT VALUE #( stats = 'GETDAT' data = CORRESPONDING #( wa_rec ) ) INTO TABLE lhc_buffer=>mt_buff.
                ENDIF.
              ENDIF.
            ENDIF.
            CLEAR : wa_rec.
          ENDLOOP.
        ENDIF.
      ELSE.
        IF   wa_param-xblnr IS INITIAL.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter Invoice No' )
                      ) TO reported-zi_man_gate.
        ENDIF.

        IF   wa_param-zxdat IS INITIAL.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter Invoice Date' )
                      ) TO reported-zi_man_gate.
        ENDIF.

        IF   wa_param-vehno IS INITIAL.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter Vehicle No' )
                      ) TO reported-zi_man_gate.
        ENDIF.

        IF   wa_param-matnr IS INITIAL.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter Material No' )
                      ) TO reported-zi_man_gate.
        ENDIF.

        IF   wa_param-menge LE 0.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter Quantity' )
                      ) TO reported-zi_man_gate.
        ENDIF.

        IF   wa_param-puord IS INITIAL AND
             wa_param-schag IS INITIAL.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please Enter PO Or Scheduling Agreement No' )
                      ) TO reported-zi_man_gate.
        ENDIF.
      ENDIF.
    ELSE.
      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text     = 'Please Enter Parameter Values' )
                       ) TO reported-zi_man_gate.
    ENDIF.
    CLEAR : wa_param.
    FREE : it_param.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_MAN_GATE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_MAN_GATE IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA : it_tabl TYPE STANDARD TABLE OF zdt_gate_man WITH DEFAULT KEY,
           wa_tabl TYPE zdt_gate_man.

    IF lhc_buffer=>mt_buff IS NOT INITIAL.
      LOOP AT lhc_buffer=>mt_buff INTO DATA(wa_buff).
        IF wa_buff-stats EQ 'GETDAT'.
          CALL METHOD zcl_clean_table=>clean_gate_man_dt
            RECEIVING
              rt_resp = DATA(lv_resp).
          FREE : it_tabl.
          wa_tabl = CORRESPONDING #( wa_buff-data ).
          APPEND : wa_tabl TO it_tabl.
          CLEAR : wa_tabl.

          SELECT *
            FROM zdt_gate_man
             FOR ALL ENTRIES IN @it_tabl
           WHERE lifnr EQ @it_tabl-lifnr
             AND matnr EQ @it_tabl-matnr
             AND xblnr EQ @it_tabl-xblnr
             AND ebeln EQ @it_tabl-ebeln
             AND ebelp EQ @it_tabl-ebelp
            INTO TABLE @DATA(it_temp)."#EC CI_NOWHERE

          IF it_temp IS NOT INITIAL.
            UPDATE zdt_gate_man FROM TABLE @it_tabl."#EC CI_NOWHERE
          ELSE.
            IF it_temp IS INITIAL.
              INSERT zdt_gate_man FROM TABLE @it_tabl."#EC CI_NOWHERE
              APPEND VALUE #(
                       %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-success
                                text     = 'Data Added'
                              )
                    ) TO reported-zi_man_gate.
            ENDIF.
          ENDIF.
        ENDIF.
        IF wa_buff-stats EQ 'CRTDAT'.
          FREE : it_tabl.
          wa_tabl = CORRESPONDING #( wa_buff-data ).
          APPEND : wa_tabl TO it_tabl.
          CLEAR : wa_tabl.

          IF it_tabl IS NOT INITIAL.
            "UPDATE zgate_man FROM TABLE @it_tabl.

            loop at it_tabl into wa_tabl.
                update zdt_gate_man
                   set zrgno = @wa_tabl-zrgno
                 where sap_uuid = @wa_tabl-sap_uuid."#EC CI_NOWHERE

               clear : wa_tabl.
            endloop.
          ENDIF.
        ENDIF.
        IF wa_buff-stats EQ 'EXIST'.
          DATA : lv_text TYPE string.

          FREE : it_tabl.
          wa_tabl = CORRESPONDING #( wa_buff-data ).
          wa_tabl-ztext = 'Gate Entry Already Exist'.
          APPEND : wa_tabl TO it_tabl.
          CLEAR : wa_tabl.

          SELECT *
            FROM zdt_gate_man
             FOR ALL ENTRIES IN @it_tabl
           WHERE lifnr EQ @it_tabl-lifnr
             AND matnr EQ @it_tabl-matnr
             AND xblnr EQ @it_tabl-xblnr
             AND ebeln EQ @it_tabl-ebeln
             AND ebelp EQ @it_tabl-ebelp
            INTO TABLE @DATA(it_exist)."#EC CI_NOWHERE

          IF it_exist IS NOT INITIAL.
            UPDATE zdt_gate_man FROM TABLE @it_tabl."#EC CI_NOWHERE
          ELSE.
            IF it_exist IS INITIAL.
              INSERT zdt_gate_man FROM TABLE @it_tabl."#EC CI_NOWHERE
            ENDIF.
          ENDIF.

          DATA(lv_year) = cl_abap_context_info=>get_system_date(  ).
          lv_year = lv_year(4).

          CLEAR : lv_text.
          CONCATENATE 'Year -' lv_year INTO lv_text SEPARATED BY space.

          APPEND VALUE #(   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = lv_text )
                         ) TO reported-zi_man_gate.

          CLEAR : lv_text.
          CONCATENATE 'Invoice -' wa_buff-xblnr INTO lv_text SEPARATED BY space.

          APPEND VALUE #(   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = lv_text )
                         ) TO reported-zi_man_gate.

          CLEAR : lv_text.
          CONCATENATE 'Vendor -' wa_buff-lifnr INTO lv_text SEPARATED BY space.

          APPEND VALUE #(   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = lv_text )
                         ) TO reported-zi_man_gate.

          CLEAR : lv_text.
          CONCATENATE 'Gate Entry -' wa_buff-zrgno INTO lv_text SEPARATED BY space.

          APPEND VALUE #(   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = lv_text )
                         ) TO reported-zi_man_gate.

          APPEND VALUE #(   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = 'Entry already Exists' )
                         ) TO reported-zi_man_gate.
        ENDIF.
        IF wa_buff-stats EQ 'ADDDAT'.
          FREE : it_tabl.
          wa_tabl = CORRESPONDING #( wa_buff-data ).
          APPEND : wa_tabl TO it_tabl.
          CLEAR : wa_tabl.

          INSERT zdt_gate_man FROM TABLE @it_tabl."#EC CI_NOWHERE

          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                        text     = 'Data Added' )
                        ) TO reported-zi_man_gate.
        endif.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    FREE : lhc_buffer=>mt_buff.
  ENDMETHOD.

  METHOD cleanup_finalize.
    FREE : lhc_buffer=>mt_buff.
  ENDMETHOD.

ENDCLASS.
