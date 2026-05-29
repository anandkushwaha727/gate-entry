@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Material Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{ 
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_F4 as select from I_ProductDescription
{
    key cast ( Product as matnr preserving type) as Product,
    ProductDescription,
    cast ( Language as spras preserving type ) as Language
} where Language = 'E'
