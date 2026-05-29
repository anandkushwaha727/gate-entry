CLASS zcl_gate_crud DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: ty_bus_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
           gt_bus_data TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
           ty_num      TYPE c LENGTH 10,
           ty_range_zrgno      TYPE RANGE OF string,
           ty_range_zscpn      TYPE RANGE OF string,
           ty_range_lifnr      TYPE RANGE OF string,
           ty_range_xblnr      TYPE RANGE OF string,
           ty_range_zxdat      TYPE RANGE OF string,
           ty_range_ebeln      type range of string,
           ty_range_vbeln      type range of string.

    DATA:
      ls_business_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
      ls_output_data   TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
      ls_entity_key    TYPE zsc_gate_cbo=>tys_yy_1_gatetype,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request_cret  TYPE REF TO /iwbep/if_cp_request_create,
      lo_response_cret TYPE REF TO /iwbep/if_cp_response_create,
      lo_request_read  TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response_read TYPE REF TO /iwbep/if_cp_response_read_lst,
      lo_request_updt  TYPE REF TO /iwbep/if_cp_request_update,
      lo_response_updt TYPE REF TO /iwbep/if_cp_response_update,
      lo_resource_updt TYPE REF TO /iwbep/if_cp_resource_entity.


    DATA:
      lt_business_data TYPE TABLE OF zsc_gate_cbo=>tys_yy_1_gatetype,
      ls_message       TYPE zdt_message.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_3    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
      lt_range_zrgno      TYPE RANGE OF string,
      lt_range_zscpn      TYPE RANGE OF string,
      lt_range_lifnr      TYPE RANGE OF string,
      lt_range_xblnr      TYPE RANGE OF string,
      lt_range_zxdat      TYPE RANGE OF string,
      lt_range_ebeln      type range of string,
      lt_range_zgcat      type range of string,
      lt_range_vbeln      type range of string,
      lt_range_mblnr      type range of string.

    DATA : lv_user      TYPE string,
           lv_user_text TYPE string,
           lv_uname type string,
           lv_passd type string.

    data: lr_cscn type if_com_scenario_factory=>ty_query-cscn_id_range,
          lv_comm_scn type if_com_management=>ty_cscn_id,
          lv_comm_sys type if_com_management=>ty_cs_id,
          lv_outb_serv_id type if_com_management=>ty_cscn_outb_srv_id.

    METHODS : gate_cret IMPORTING ip_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype
                        EXPORTING ep_resp TYPE string
                                  ep_eror type string,
      gate_read IMPORTING ip_zrgno TYPE ty_num  OPTIONAL
                          ip_zscpn TYPE ty_num  OPTIONAL
                EXPORTING ep_data  TYPE gt_bus_data
                          ep_eror type string,
      gate_updt IMPORTING ip_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype
                EXPORTING ep_data TYPE zsc_gate_cbo=>tys_yy_1_gatetype
                          ep_resp TYPE  string
                          ep_eror type string,
      gate_dupl IMPORTING ip_lifnr TYPE string optional
                          ip_xblnr TYPE string optional
                          ip_zxdat TYPE budat optional
                EXPORTING ep_gedat TYPE gt_bus_data
                          ep_eror type string,
      gate_dout IMPORTING ip_vbeln TYPE string optional
                          ip_mblnr TYPE string optional
                          ip_xblnr TYPE string optional
                EXPORTING ep_gedat TYPE gt_bus_data
                          ep_eror type string,
      gate_cent importing ip_range_zrgno type ty_range_zrgno OPTIONAL
                          ip_range_xblnr type ty_range_xblnr OPTIONAL
                          ip_range_zxdat type ty_range_zxdat OPTIONAL
                          ip_top type i optional
                          ip_skip type i optional
                EXPORTING ep_gedat TYPE gt_bus_data
                          ep_eror type string,
      gate_b2s2 importing ip_sdate type budat optional
                          ip_edate type budat optional
                exporting ep_gedat TYPE gt_bus_data
                          ep_eror type string.

    INTERFACES : zif_cons_var.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS : get_fiscal_dates IMPORTING ip_zxdat TYPE budat
                                     EXPORTING ep_fdate TYPE budat
                                               ep_ldate TYPE budat.
ENDCLASS.



CLASS ZCL_GATE_CRUD IMPLEMENTATION.


  METHOD gate_b2s2.
    DATA : lt_properties TYPE TABLE OF string,
           lv_budat type budat,
           exc TYPE REF TO cx_http_dest_provider_error,
           exc_1 TYPE REF TO cx_abap_context_info_error.

    TRY.
        FREE :  lt_range_zxdat, lt_range_zgcat.
        clear : lv_budat.

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        clear : lv_uname , lv_passd.

        read table it_user into data(wa_user) index 1.

        lv_uname = wa_user-uname.
        lv_passd = wa_user-passd.

        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        FREE : lt_range_zxdat, lt_range_zgcat.

        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'B2S2' ) TO lt_range_zgcat.

        IF ip_sdate IS NOT INITIAL AND ip_edate IS NOT INITIAL.
           cl_abap_tstmp=>systemtstmp_syst2utc( EXPORTING   syst_date       = ip_sdate
                                                            syst_time       = '000000'
                                                IMPORTING   utc_tstmp       = data(lv_ftmp) ).

           cl_abap_tstmp=>systemtstmp_syst2utc( EXPORTING   syst_date       = ip_edate
                                                            syst_time       = '235959'
                                                IMPORTING   utc_tstmp       = data(lv_etmp) ).

           APPEND VALUE #( sign = 'I' option = 'BT' low = lv_ftmp high = lv_etmp ) TO lt_range_zxdat.
        ENDIF.
        clear : lv_ftmp, lv_etmp.

        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request_read = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_read( ).

        " Create the filter tree

        lo_filter_factory = lo_request_read->create_filter_factory( ).

        IF lt_range_lifnr IS NOT INITIAL.
          lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'ZGCAT'
                                                                  it_range             = lt_range_zgcat ).
        ENDIF.

        IF lt_range_zxdat IS NOT INITIAL.
          lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'SAP_CREATED_DATE_TIME'
                                                                  it_range             =  lt_range_zxdat ).
        ENDIF.
        IF lt_range_lifnr IS NOT INITIAL AND
           lt_range_zxdat IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).

*        CATCH /iwbep/cx_gateway.
          lo_request_read->set_filter( lo_filter_node_root ).
        ENDIF.

        lo_request_read->set_top( 99999 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response_read = lo_request_read->execute( ).
        lo_response_read->get_business_data( IMPORTING et_business_data = lt_business_data ).
        IF lt_business_data IS NOT INITIAL.
          ep_gedat = lt_business_data.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
         DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
         exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
        ep_eror = |{ exception_message }|.

      CATCH cx_http_dest_provider_error into exc.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.
      CATCH cx_abap_context_info_error into exc_1.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.

    ENDTRY.

    free : lv_uname, lv_passd, wa_user, it_user.
  ENDMETHOD.


  METHOD gate_cent.
    data : ls_order type /iwbep/if_cp_runtime_types=>ty_s_sort_order,
           lt_order type /iwbep/if_cp_runtime_types=>ty_t_sort_order.

    TRY.
        FREE : lt_business_data, lt_range_zxdat.
        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        read table it_user into data(wa_user) index 1.
        CONDENSE wa_user-uname NO-GAPS.
        lv_uname = wa_user-uname.
        CONDENSE wa_user-passd NO-GAPS.
        lv_passd = wa_user-passd.

        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request_read = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_read( ).

        " Create the filter tree

        lo_filter_factory = lo_request_read->create_filter_factory( ).

        ls_order-property_path = 'ZRGNO'.
        ls_order-descending = space.

        append : ls_order to lt_order.
         clear : ls_order.

        lo_request_read->set_orderby(
          EXPORTING
            it_orderby_property = lt_order
*          RECEIVING
*            ro_request          =
        ).
*        CATCH /iwbep/cx_gateway.

        IF ip_range_zrgno IS NOT INITIAL.
          lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'ZRGNO'
                                                                  it_range             = ip_range_zrgno ).
        ENDIF.
        IF ip_range_xblnr IS NOT INITIAL.
          lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'XBLNR'
                                                                  it_range             = ip_range_xblnr ).
        ENDIF.
        IF ip_range_zxdat IS NOT INITIAL.
          lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'ZXDAT'
                                                                  it_range             = ip_range_zxdat ).
        elseif ip_range_zxdat is initial.

            data(lv_budat) = cl_abap_context_info=>get_system_date( ).

            CALL METHOD zcl_gate_crud=>get_fiscal_dates
              EXPORTING
               ip_zxdat = lv_budat
              IMPORTING
               ep_fdate = data(lv_fdate)
               ep_ldate = data(lv_ldate).

            IF lv_fdate IS NOT INITIAL AND lv_ldate IS NOT INITIAL.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lv_fdate high = lv_ldate ) TO lt_range_zxdat.

              lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'ZXDAT'
                                                                      it_range             = lt_range_zxdat ).
            ENDIF.
        ENDIF.


        if ip_range_zrgno is not initial and ip_range_xblnr is not initial.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 )->and( lo_filter_node_3 ).
          lo_request_read->set_filter( lo_filter_node_root ).
        elseif ip_range_zrgno is not initial and ip_range_xblnr is initial.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_3 ).
          lo_request_read->set_filter( lo_filter_node_root ).
        elseif ip_range_zrgno is initial and ip_range_xblnr is not initial.
          lo_filter_node_root = lo_filter_node_2->and( lo_filter_node_3 ).
          lo_request_read->set_filter( lo_filter_node_root ).
        elseif ip_range_zrgno is initial and ip_range_xblnr is initial.
          lo_filter_node_root = lo_filter_node_3 .
          lo_request_read->set_filter( lo_filter_node_root ).
        endif.

        if ip_top gt 0.
            lo_request_read->set_top( ip_top )->set_skip( ip_skip ).
        else.
            lo_request_read->set_top( 500 )->set_skip( 0 ).
        endif.

        " Execute the request and retrieve the business data
        lo_response_read = lo_request_read->execute( ).
        lo_response_read->get_business_data( IMPORTING et_business_data = lt_business_data ).
        IF lt_business_data IS NOT INITIAL.
          ep_gedat = lt_business_data.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection
        ep_eror = |{ exception_message }|.
        RAISE SHORTDUMP lx_remote.

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
        " Handle Exception
        ep_eror = |{ exception_message }|.

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        ##NO_HANDLER
         exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.

      CATCH cx_http_dest_provider_error into data(lx_dest).
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_dest )->if_message~get_longtext( ).
        ##NO_HANDLER
        ep_eror = |{ exception_message }|.

      CATCH cx_abap_context_info_error.
       ##NO_HANDLER
        ep_eror = |{ exception_message }|.

    ENDTRY.
    clear : wa_user, lv_uname, lv_passd.
    free : it_user.
  ENDMETHOD.


  METHOD gate_cret.

    DATA: exc TYPE REF TO cx_abap_context_info_error,
          exc_1 TYPE REF TO cx_http_dest_provider_error,
          exc_2 TYPE REF TO cx_uuid_error,
          lv_user_t type cl_abap_context_info=>ty_user_name.
    TRY.
        " Create http client
        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        clear : lv_uname , lv_passd.

        read table it_user into data(wa_user) index 1.

        lv_uname = wa_user-uname.
        lv_passd = wa_user-passd.

        CLEAR : ls_business_data, ls_output_data.
        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.
        CLEAR : lv_user, lv_user_text, lv_user_t.
        DATA(lv_data) = cl_abap_context_info=>get_system_date( ) && cl_abap_context_info=>get_system_time( ).
        lv_user      = cl_abap_context_info=>get_user_technical_name( ). "cl_abap_context_info=>get_user_business_partner_id( ).
        lv_user_t = lv_user.
        lv_user_text = cl_abap_context_info=>get_user_description( iv_buser = lv_user_t ).
        DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).
        DATA(uuid_x16)    = system_uuid->create_uuid_x16( ).
*        data(lv_num)   = zcl_gate_cbo_crud=>get_num_next( ).

* Prepare business data
        ls_business_data = VALUE #(
                  sap_uuid                    = uuid_x16
                  zrgno                       = ip_data-zrgno
                  zscpn                       = ip_data-zscpn
                  xblnr                       = ip_data-xblnr
                  zxdat                       = ip_data-zxdat
                  zcarr                       = ip_data-zcarr
                  lifnr                       = ip_data-lifnr
                  vname                       = ip_data-vname
                  ebeln                       = ip_data-ebeln
                  ebelp                       = ip_data-ebelp
                  bukrs                       = ip_data-bukrs
                  werks                       = ip_data-werks
                  lgort                       = ip_data-lgort
                  matnr                       = ip_data-matnr
                  txz_01                      = ip_data-txz_01
                  menge_v                     = ip_data-menge_v
                  menge_u                     = ip_data-menge_u
                  menge_u_text                = ip_data-menge_u_text
                  meins_v                     = ''
                  meins_u                     = ''
                  meins_u_text                = ''
                  lsmng_v                     = ip_data-lsmng_v
                  lsmng_u                     = ip_data-lsmng_u
                  lsmng_u_text                = ip_data-lsmng_u_text
                  lsmeh_v                     = ''
                  lsmeh_u                     = ''
                  lsmeh_u_text                = ''
                  kdmat                       = ip_data-kdmat
                  mblnr                       = ip_data-mblnr
                  mjahr                       = ip_data-mjahr
                  zeile                       = ip_data-zeile
                  zdinv                       = ip_data-zdinv
                  vbeln                       = ip_data-vbeln
                  posnr                       = ip_data-posnr
                  kunnr                       = ip_data-kunnr
                  cname                       = ip_data-cname
                  zedin                       = ip_data-zedin
                  aufnr                       = ip_data-aufnr
                  zconf                       = ip_data-zconf
                  zgcat                       = ip_data-zgcat
                  zmdir                       = ip_data-zmdir
                  zstat                       = ip_data-zstat
                  grund                       = ip_data-grund
                  ernam                       = ip_data-ernam
                  sap_created_date_time       = lv_data
                  sap_created_by_user         = lv_user
                  sap_created_by_user_text    = lv_user_text
                  sap_last_changed_date_time  = lv_data
                  sap_last_changed_by_user    = lv_user
                  sap_last_changed_by_user_t  = lv_user_text
                  sap_lifecycle_status        = ''
                  sap_lifecycle_status_text   = '' ).


        " Navigate to the resource and create a request for the create operation
        lo_request_cret = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_create( ).

        " Set the business data for the created entity
        lo_request_cret->set_business_data( ls_business_data ).

        " Execute the request
        lo_response_cret = lo_request_cret->execute( ).

        " Get the after image
        lo_response_cret->get_business_data( IMPORTING es_business_data = ls_output_data ).
        IF ls_output_data IS NOT INITIAL.
          IF ls_business_data-zrgno EQ ls_output_data-zrgno.
            ep_resp = 'Gate entry created'.
          ELSE.
            ep_resp = 'Gate entry not created'.
          ENDIF.
        ELSE.
          ep_resp  = 'Gate entry not created'.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection
        " RAISE SHORTDUMP lx_remote.
        data(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
        ep_resp = 'problems of your http(s) connection'.
        ep_eror = |{ exception_message }|.

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
        ep_resp = 'problems of your http(s) gateway'.
        ep_eror = |{ exception_message }|.

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
        ep_eror = |{ exception_message }|.
        RAISE SHORTDUMP lx_web_http_client_error.

      CATCH cx_abap_context_info_error into exc.
        exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        ep_eror = |{ exception_message }|.
        "handle exception
      CATCH cx_http_dest_provider_error into exc_1.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        "handle exception
      CATCH cx_uuid_error into exc_2.
             exception_message = cl_message_helper=>get_latest_t100_exception( exc_2 )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.

    ENDTRY.
    free : wa_user, lv_uname, lv_passd, it_user.

  ENDMETHOD.


  METHOD gate_dout.
 DATA : lt_properties TYPE TABLE OF string,
           lv_budat type budat,
           exc TYPE REF TO cx_http_dest_provider_error,
           exc_1 TYPE REF TO cx_abap_context_info_error.

    TRY.
        FREE : lt_business_data, lt_range_mblnr, lt_range_vbeln, lt_range_xblnr.
        clear : lv_budat.

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        clear : lv_uname , lv_passd.

        read table it_user into data(wa_user) index 1.

        lv_uname = wa_user-uname.
        lv_passd = wa_user-passd.

        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        FREE : lt_range_zrgno, lt_range_zscpn, lt_range_zxdat.
        IF ip_vbeln IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_vbeln ) TO lt_range_vbeln.
        ENDIF.
        IF ip_mblnr IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_mblnr ) TO lt_range_mblnr.
        ENDIF.
        if ip_xblnr is not initial.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_xblnr ) TO lt_range_xblnr.
        endif.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request_read = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_read( ).

        " Create the filter tree

        lo_filter_factory = lo_request_read->create_filter_factory( ).


        IF lt_range_vbeln IS NOT INITIAL.
          lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'VBELN'
                                                              it_range             = lt_range_vbeln ).
        ENDIF.
        IF lt_range_mblnr IS NOT INITIAL.
          lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'MBLNR'
                                                                it_range             =  lt_range_mblnr ).
        ENDIF.
        IF lt_range_xblnr IS NOT INITIAL.
          lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'XBLNR'
                                                                it_range             =  lt_range_xblnr ).
        ENDIF.

        IF lt_range_vbeln IS NOT INITIAL AND
           lt_range_mblnr IS NOT INITIAL AND
           lt_range_xblnr IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 )->and( lo_filter_node_3 ).

*        CATCH /iwbep/cx_gateway.
          lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_vbeln IS NOT INITIAL AND
               lt_range_mblnr IS NOT INITIAL AND
               lt_range_zxdat IS INITIAL.
               lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_vbeln IS NOT INITIAL AND
               lt_range_mblnr IS INITIAL AND
               lt_range_xblnr IS INITIAL.
               lo_filter_node_root = lo_filter_node_1.
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_vbeln IS INITIAL AND
               lt_range_mblnr IS NOT INITIAL AND
               lt_range_xblnr IS INITIAL.
               lo_filter_node_root = lo_filter_node_2.
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_vbeln IS INITIAL AND
               lt_range_mblnr IS INITIAL AND
               lt_range_xblnr IS NOT INITIAL.
               lo_filter_node_root = lo_filter_node_3.
               lo_request_read->set_filter( lo_filter_node_root ).
        ENDIF.

        lo_request_read->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response_read = lo_request_read->execute( ).
        lo_response_read->get_business_data( IMPORTING et_business_data = lt_business_data ).
        IF lt_business_data IS NOT INITIAL.
          ep_gedat = lt_business_data.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
         DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
         exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
        ep_eror = |{ exception_message }|.

      CATCH cx_http_dest_provider_error into exc.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.
      CATCH cx_abap_context_info_error into exc_1.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.

    ENDTRY.

    free : lv_uname, lv_passd, wa_user, it_user.
  ENDMETHOD.


  METHOD gate_dupl.
    DATA : lt_properties TYPE TABLE OF string,
           lv_budat type budat,
           exc TYPE REF TO cx_http_dest_provider_error,
           exc_1 TYPE REF TO cx_abap_context_info_error.

    TRY.
        FREE : lt_business_data, lt_range_lifnr, lt_range_xblnr, lt_range_zxdat.
        clear : lv_budat.

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        clear : lv_uname , lv_passd.

        read table it_user into data(wa_user) index 1.

        lv_uname = wa_user-uname.
        lv_passd = wa_user-passd.

        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        FREE : lt_range_zrgno, lt_range_zscpn, lt_range_zxdat.
        IF ip_lifnr IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_lifnr ) TO lt_range_lifnr.
        ENDIF.
        IF ip_xblnr IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_xblnr ) TO lt_range_xblnr.
        ENDIF.
        IF ip_zxdat IS NOT INITIAL.
          CALL METHOD zcl_gate_crud=>get_fiscal_dates
            EXPORTING
              ip_zxdat = ip_zxdat
            IMPORTING
              ep_fdate = DATA(lv_fdate)
              ep_ldate = DATA(lv_ldate).

          IF lv_fdate IS NOT INITIAL AND lv_ldate IS NOT INITIAL.
            APPEND VALUE #( sign = 'I' option = 'BT' low = lv_fdate high = lv_ldate ) TO lt_range_zxdat.
          ENDIF.
        elseif ip_zxdat is initial.
            clear : lv_fdate, lv_ldate.

            lv_budat = cl_abap_context_info=>get_system_date( ).

            CALL METHOD zcl_gate_crud=>get_fiscal_dates
              EXPORTING
               ip_zxdat = lv_budat
              IMPORTING
               ep_fdate = lv_fdate
               ep_ldate = lv_ldate.

            IF lv_fdate IS NOT INITIAL AND lv_ldate IS NOT INITIAL.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lv_fdate high = lv_ldate ) TO lt_range_zxdat.
            ENDIF.
        ENDIF.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request_read = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_read( ).

        " Create the filter tree

        lo_filter_factory = lo_request_read->create_filter_factory( ).


        IF lt_range_lifnr IS NOT INITIAL.
          lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'LIFNR'
                                                              it_range             = lt_range_lifnr ).
        ENDIF.
        IF lt_range_xblnr IS NOT INITIAL.
          lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'XBLNR'
                                                                it_range             =  lt_range_xblnr ).
        ENDIF.
        IF lt_range_zxdat IS NOT INITIAL.
          lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'ZXDAT'
                                                                it_range             =  lt_range_zxdat ).
        ENDIF.
        IF lt_range_lifnr IS NOT INITIAL AND
           lt_range_xblnr IS NOT INITIAL AND
           lt_range_zxdat IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 )->and( lo_filter_node_3 ).

*        CATCH /iwbep/cx_gateway.
          lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_lifnr IS NOT INITIAL AND
               lt_range_xblnr IS NOT INITIAL AND
               lt_range_zxdat IS INITIAL.
               lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_lifnr IS NOT INITIAL AND
               lt_range_xblnr IS INITIAL AND
               lt_range_zxdat IS INITIAL.
               lo_filter_node_root = lo_filter_node_1.
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_lifnr IS INITIAL AND
               lt_range_xblnr IS NOT INITIAL AND
               lt_range_zxdat IS INITIAL.
               lo_filter_node_root = lo_filter_node_2.
               lo_request_read->set_filter( lo_filter_node_root ).
        elseif lt_range_lifnr IS INITIAL AND
               lt_range_xblnr IS INITIAL AND
               lt_range_zxdat IS NOT INITIAL.
               lo_filter_node_root = lo_filter_node_3.
               lo_request_read->set_filter( lo_filter_node_root ).
        ENDIF.

        lo_request_read->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response_read = lo_request_read->execute( ).
        lo_response_read->get_business_data( IMPORTING et_business_data = lt_business_data ).
        IF lt_business_data IS NOT INITIAL.
          ep_gedat = lt_business_data.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
         DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
         exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
        ep_eror = |{ exception_message }|.

      CATCH cx_http_dest_provider_error into exc.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.
      CATCH cx_abap_context_info_error into exc_1.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
        "handle exception
        ep_eror = |{ exception_message }|.

    ENDTRY.

    free : lv_uname, lv_passd, wa_user, it_user.
  ENDMETHOD.


  METHOD gate_read.
    DATA: exc TYPE REF TO cx_http_dest_provider_error.

    TRY.
        FREE : lt_business_data, lt_range_zrgno, lt_range_zscpn.
        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        FREE : lt_range_zrgno, lt_range_zscpn.
        IF ip_zrgno IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_zrgno ) TO lt_range_zrgno.
        ENDIF.
        IF ip_zscpn IS NOT INITIAL.
          APPEND VALUE #( sign = 'I' option = 'EQ' low = ip_zscpn ) TO lt_range_zscpn.
        ENDIF.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        read table it_user into data(wa_user) index 1.
        CONDENSE wa_user-uname NO-GAPS.
        lv_uname = wa_user-uname.
        CONDENSE wa_user-passd NO-GAPS.
        lv_passd = wa_user-passd.

        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request_read = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->create_request_for_read( ).

        " Create the filter tree

        lo_filter_factory = lo_request_read->create_filter_factory( ).

        IF lt_range_zrgno IS NOT INITIAL.
          lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'ZRGNO'
                                                              it_range             = lt_range_zrgno ).
        ENDIF.
        IF lt_range_zscpn IS NOT INITIAL.
          lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'ZSCPN'
                                                                it_range             =  lt_range_zscpn ).
        ENDIF.
        IF lt_range_zrgno IS NOT INITIAL AND lt_range_zscpn IS NOT INITIAL.
          lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
          lo_request_read->set_filter( lo_filter_node_root ).
        ELSE.
          IF lt_range_zrgno IS NOT INITIAL AND lt_range_zscpn IS INITIAL.
            lo_filter_node_root = lo_filter_node_1.
            lo_request_read->set_filter( lo_filter_node_root ).
          ELSE.
            IF lt_range_zrgno IS INITIAL AND lt_range_zscpn IS NOT INITIAL.
              lo_filter_node_root = lo_filter_node_2.
              lo_request_read->set_filter( lo_filter_node_root ).
            ENDIF.
          ENDIF.
        ENDIF.

        lo_request_read->set_top( 50 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response_read = lo_request_read->execute( ).
        lo_response_read->get_business_data( IMPORTING et_business_data = lt_business_data ).
        IF lt_business_data IS NOT INITIAL.
          ep_data = lt_business_data.
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection
        ep_eror = |{ exception_message }|.
        RAISE SHORTDUMP lx_remote.

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
        " Handle Exception
        ep_eror = |{ exception_message }|.

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        ##NO_HANDLER
         exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
         ep_eror = |{ exception_message }|.

      CATCH cx_http_dest_provider_error into exc.
        exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
        ##NO_HANDLER
        ep_eror = |{ exception_message }|.

      CATCH cx_abap_context_info_error into data(lx_ceror).
      exception_message = cl_message_helper=>get_latest_t100_exception( lx_ceror )->if_message~get_longtext( ).
       ##NO_HANDLER
    ENDTRY.
    clear : wa_user, lv_uname, lv_passd.
    free : it_user.
  ENDMETHOD.


  METHOD gate_updt.
    DATA: exc TYPE REF TO cx_http_dest_provider_error,
          exc_1 TYPE REF TO cx_abap_context_info_error,
          lv_user_t type cl_abap_context_info=>ty_user_name.
    TRY.
        CLEAR : ls_business_data.

        select *
          from zdt_comm_user
         where uname eq 'ZGATE_CBO'
          into table @data(it_user)."#EC CI_NOWHERE

        clear : lv_uname , lv_passd.

        read table it_user into data(wa_user) index 1.

        lv_uname = wa_user-uname.
        lv_passd = wa_user-passd.

        DATA(lv_cotx_url) = cl_abap_context_info=>get_system_url( ).
        CONCATENATE 'https://' lv_cotx_url ':443' INTO DATA(lv_url)  .
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = lv_url ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
          EXPORTING
            i_username = lv_uname "zif_cons_var=>c_user-scm_user
            i_password = lv_passd "zif_cons_var=>c_user-scm_pass
        ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSC_GATE_CBO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YY1_GATE_CDS/' ).

        ASSERT lo_http_client IS BOUND.
        CLEAR : lv_user, lv_user_text, lv_user_t.
        DATA(lv_data) = cl_abap_context_info=>get_system_date( ) && cl_abap_context_info=>get_system_time( ).
        lv_user       = cl_abap_context_info=>get_user_technical_name( )."cl_abap_context_info=>get_user_business_partner_id( ).
        lv_user_t     = lv_user.
        lv_user_text  = cl_abap_context_info=>get_user_description( iv_buser = lv_user_t ).

        " Set entity key
        ls_entity_key = VALUE #( sap_uuid  = ip_data-sap_uuid ).

        " Prepare the business data
        ls_business_data = VALUE #(
              sap_uuid                    = ip_data-sap_uuid
              zrgno                       = ip_data-zrgno
              zscpn                       = ip_data-zscpn
              xblnr                       = ip_data-xblnr
              zxdat                       = ip_data-zxdat
              zcarr                       = ip_data-zcarr
              lifnr                       = ip_data-lifnr
              vname                       = ip_data-vname
              ebeln                       = ip_data-ebeln
              ebelp                       = ip_data-ebelp
              bukrs                       = ip_data-bukrs
              werks                       = ip_data-werks
              lgort                       = ip_data-lgort
              matnr                       = ip_data-matnr
              txz_01                      = ip_data-txz_01
              menge_v                     = ip_data-menge_v
              menge_u                     = ip_data-menge_u
              menge_u_text                = ip_data-menge_u_text
              meins_v                     = ''
              meins_u                     = ''
              meins_u_text                = ''
              lsmng_v                     = ip_data-lsmng_v
              lsmng_u                     = ip_data-lsmng_u
              lsmng_u_text                = ip_data-lsmng_u_text
              lsmeh_v                     = ''
              lsmeh_u                     = ''
              lsmeh_u_text                = ''
              kdmat                       = ip_data-kdmat
              mblnr                       = ip_data-mblnr
              mjahr                       = ip_data-mjahr
              zeile                       = ip_data-zeile
              zdinv                       = ip_data-zdinv
              vbeln                       = ip_data-vbeln
              posnr                       = ip_data-posnr
              kunnr                       = ip_data-kunnr
              cname                       = ip_data-cname
              zedin                       = ip_data-zedin
              aufnr                       = ip_data-aufnr
              zconf                       = ip_data-zconf
              zgcat                       = ip_data-zgcat
              zmdir                       = ip_data-zmdir
              zstat                       = ip_data-zstat
              grund                       = ip_data-grund
              sap_created_date_time       = ip_data-sap_created_date_time
              sap_created_by_user         = ip_data-sap_created_by_user
              sap_created_by_user_text    = ip_data-sap_created_by_user_text
              sap_last_changed_date_time  = lv_data
              sap_last_changed_by_user    = lv_user
              sap_last_changed_by_user_t  = lv_user_text
              sap_lifecycle_status        = ''
              sap_lifecycle_status_text   = '' ).

        " Navigate to the resource and create a request for the update operation
        lo_resource_updt = lo_client_proxy->create_resource_for_entity_set( 'YY_1_GATE' )->navigate_with_key( ls_entity_key ).
        lo_request_updt = lo_resource_updt->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put ).

        " ETag is needed
        " You need to retrieve it and then set it here
*lo_request->set_if_match( ls_business_data-etag ).

        lo_request_updt->set_business_data( ls_business_data ).

        " Execute the request and retrieve the business data
        lo_response_updt = lo_request_updt->execute( ).

        " Get updated entity
*        CLEAR ls_business_data.
*        lo_response_updt->get_business_data( importing es_business_data = ls_business_data ).

        if ls_business_data is not initial.
           ep_resp = |SM: Gate Entry { ls_business_data-zrgno } Updated|.
           ep_data = ls_business_data.
        else.
           ep_resp = |EM: Gate Entry { ls_business_data-zrgno } Not Updated|.
        endif.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_remote )->if_message~get_longtext( ).
        ep_resp = |EM: { exception_message }|.
        "RAISE SHORTDUMP lx_remote.

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_gateway )->if_message~get_longtext( ).
        ep_resp = |EM: { exception_message }|.
        "RAISE SHORTDUMP lx_gateway.

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        exception_message = cl_message_helper=>get_latest_t100_exception( lx_web_http_client_error )->if_message~get_longtext( ).
        ep_resp = |EM: { exception_message }|.
        "RAISE SHORTDUMP lx_web_http_client_error.

      CATCH cx_http_dest_provider_error into exc.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc )->if_message~get_longtext( ).
         ep_resp = |EM: { exception_message }|.
         "handle exception
      CATCH cx_abap_context_info_error into exc_1.
         exception_message = cl_message_helper=>get_latest_t100_exception( exc_1 )->if_message~get_longtext( ).
         ep_resp = |EM: { exception_message }|.
         "handle exception
    ENDTRY.
    free : lv_uname, lv_passd, wa_user, it_user.

  ENDMETHOD.


  METHOD get_fiscal_dates.
    DATA : lv_budat    TYPE budat,
           lv_fyear    TYPE n LENGTH 4,
           lv_pfyear   TYPE n LENGTH 4,
           lv_nfyear   TYPE n LENGTH 4,
           lv_chk_fdat TYPE budat,
           lv_chk_ldat TYPE budat.

    IF ip_zxdat IS NOT INITIAL.
      lv_budat = ip_zxdat.
      lv_fyear = lv_budat(4).

      IF lv_budat IS NOT INITIAL.
        CONCATENATE lv_fyear '0101' INTO lv_chk_fdat.
        CONCATENATE lv_fyear '0331' INTO lv_chk_ldat.

        IF lv_budat GE lv_chk_fdat AND lv_budat LE lv_chk_ldat.
          lv_pfyear = lv_fyear - 1.
          CONCATENATE lv_pfyear '0401' INTO ep_fdate.
          CONCATENATE lv_fyear '0331' INTO ep_ldate.
        ELSE.
          IF lv_budat GT lv_chk_ldat.
            lv_nfyear = lv_fyear + 1.
            CONCATENATE lv_fyear '0401' INTO ep_fdate.
            CONCATENATE lv_nfyear '0331' INTO ep_ldate.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR : lv_budat, lv_fyear, lv_pfyear, lv_nfyear, lv_chk_fdat, lv_chk_ldat.
  ENDMETHOD.
ENDCLASS.
