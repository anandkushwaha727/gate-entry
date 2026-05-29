@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Purchase Order Head'
@Metadata: { allowExtensions: true, ignorePropagatedAnnotations: true }
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PDET_HEAD as select from ZTF_PO_HEAD
{
   key ebeln,
   bukrs,
   bsart,
   lifnr,
   lname,
   tstmp_to_tims( tstmp_current_utctimestamp(),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client,
                     'NULL' )      as erzet 
                     
}
