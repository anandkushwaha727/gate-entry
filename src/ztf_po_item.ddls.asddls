@EndUserText.label: 'Table Function for Purchase Order Item'
@ClientHandling: { type : #CLIENT_DEPENDENT, algorithm: #SESSION_VARIABLE }
@AccessControl: { authorizationCheck: #NOT_REQUIRED }
@ClientHandling.clientSafe:true
define table function ZTF_PO_ITEM
//with parameters parameter_name : parameter_type
returns {
  client : abap.clnt;
  ebeln : ebeln;
  ebelp : ebelp;
  bukrs : bukrs;
  werks : werks_d;
  splnt : werks_d;
  lgort : lgort_d;
  matnr : matnr;
  maktx : maktx;
  meins : meins;
  waers : abap.cuky;
  netpr : abap.dec( 13, 2 );
  lifnr : lifnr;
  lname : abap.char(30);
  
}
implemented by method zcl_tab_func=>get_po_det;