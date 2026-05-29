@EndUserText.label: 'Table Function for Purchase Order Header'
@ClientHandling: { type : #CLIENT_DEPENDENT, algorithm: #SESSION_VARIABLE }
@AccessControl: { authorizationCheck: #NOT_REQUIRED }
@ClientHandling.clientSafe:true
define table function ZTF_PO_HEAD
//with parameters parameter_name : parameter_type
returns {
  client : abap.clnt;
  ebeln : ebeln;
  bukrs : bukrs;
  bsart : abap.char(4);
  lifnr : lifnr;
  lname : abap.char(30);
  
}
implemented by method zcl_tab_func=>get_po_head;