@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View Of Gate Entry-MAN ITEM'
@Metadata: { allowExtensions: true, ignorePropagatedAnnotations: true }
define view entity ZC_GATE_ITEM as projection on ZI_GATE_ITEM
{
    key ebeln,
    key ebelp,
    zrgno,
    werks,
    lgort,
    matnr,
    maktx,
    @ObjectModel: { virtualElementCalculatedBy: 'ABAP:ZCL_GATE_HEAD' }
    @EndUserText: { label: 'Open Qty'}
    virtual opqty : abap.dec( 13, 2 ),
    menge,
    meins,
    waers,
    netpr,
    xblnr,
    zxdat,
    zcarr,
    @ObjectModel: { virtualElementCalculatedBy: 'ABAP:ZCL_GATE_HEAD' }
    @EndUserText: { label: 'Total Amt'}
    virtual dmbtr : abap.dec( 13, 2 ),
    xicon,
    criticality,
    ztext,
    action,
    /* Associations */
    _head : redirected to parent ZC_GATE_HEAD,
    _table
}
