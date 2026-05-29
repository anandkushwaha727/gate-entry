@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Purchase Order Item'
@Metadata: { allowExtensions: true, ignorePropagatedAnnotations: true }
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PDET_ITEM as select from ZTF_PO_ITEM
{
    key ebeln,
    key ebelp,
    bukrs,
    werks,
    splnt,
    lgort,
    matnr,
    maktx,
    waers,
    netpr,
    meins,
    lifnr,
    lname,
    tstmp_to_tims( tstmp_current_utctimestamp(),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client,
                     'NULL' )      as erzet 
                     
}
