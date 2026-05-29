@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Supplier Value Help'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VEND_F4 as select from I_Supplier
{
    key Supplier,
    SupplierName,
    cast ( SupplierAccountGroup as ktokk preserving type ) as SupplierAccountGroup
}
