CLASS zcl_tab_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_amdp_marker_hdb.
    CLASS-METHODS : get_po_head FOR TABLE FUNCTION ztf_po_head,
                    get_po_det FOR TABLE FUNCTION ztf_po_item,
                    get_uid for SCALAR FUNCTION zsf_gate_head_uid,
                    comp_time for SCALAR FUNCTION zsf_gate_head_date.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAB_FUNC IMPLEMENTATION.


  METHOD comp_time BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY .

  declare lv_res NVARCHAR;
  declare lv_time TIME;


  if table_time = system_time then result = '1' ;
  elseif table_time <> system_time then result = '0';
  end if;

  ENDMETHOD.


  METHOD get_po_det BY DATABASE FUNCTION FOR HDB LANGUAGE
                    SQLSCRIPT OPTIONS READ-ONLY USING zi_pord_f4 zi_schd_f4.

    it_data = select mandt as client,
                     porder as ebeln,
                     item as ebelp,
                     bukrs as bukrs,
                     plant as werks,
                     supplant as splnt,
                     strloc as lgort,
                     material as matnr,
                     description as maktx,
                     unit as meins,
                     currency as waers,
                     netprice as netpr,
                     supplier as lifnr,
                     name as lname
                  from zi_pord_f4
              UNION
               SELECT  mandt AS client,
                       orderno AS ebeln,
                       item AS ebelp,
                       bukrs as bukrs,
                       plant AS werks,
                       supplant as splnt,
                       strloc AS lgort,
                       material AS matnr,
                       description AS maktx,
                       unit as meins,
                       currency as waers,
                       netprice as netpr,
                       supplier AS lifnr,
                       name AS lname
                  FROM zi_schd_f4;

    return select * from :it_data;
  endmethod.


  METHOD get_po_head BY DATABASE FUNCTION FOR HDB LANGUAGE
                     SQLSCRIPT OPTIONS READ-ONLY USING zi_pord_f4 zi_schd_f4.

    it_data = select mandt as client,
                     porder as ebeln,
                     bukrs as bukrs,
                     doctype as bsart,
                     supplier as lifnr,
                     name as lname
                  from zi_pord_f4
              UNION
               SELECT  mandt AS client,
                       orderno AS ebeln,
                       bukrs as bukrs,
                       doctype as bsart,
                       supplier AS lifnr,
                       name AS lname
                  FROM zi_schd_f4;

    return select * from :it_data;

  ENDMETHOD.


  METHOD get_uid BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY .
    declare lv_cnt INT;

    lv_cnt = num + 1 ;

    result = lv_cnt;
  ENDMETHOD.
ENDCLASS.
