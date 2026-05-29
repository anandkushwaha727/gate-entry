@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Schd Agmt Value Help'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SCHD_F4
  as select from I_SchedgagrmthdrApi01
  association [1..*] to I_SchedgAgrmtItmApi01 as _item on I_SchedgagrmthdrApi01.SchedulingAgreement = _item.SchedulingAgreement
                                                      and _item.Material != ' '
  association [1..1] to I_Supplier            as _vend on I_SchedgagrmthdrApi01.Supplier = _vend.Supplier
{
      @EndUserText.label: 'Order No'
  key SchedulingAgreement                                       as orderno,
      @EndUserText.label: 'Item'
  key _item.SchedulingAgreementItem                             as item,
      @EndUserText.label: 'Doc Type'
      PurchasingDocumentType                                    as doctype,
      @EndUserText.label: 'Comp Code'
      cast ( _item.CompanyCode as bukrs preserving type )       as bukrs,
      @EndUserText.label: 'Plant'
      cast ( _item.Plant as werks_d preserving type )           as Plant,
      @EndUserText.label: 'Supp Plant'
      cast ( _item.Plant as werks_d preserving type )           as supplant,
      @EndUserText.label: 'Str Loc'
      cast ( _item.StorageLocation as lgort_d preserving type ) as strloc,
      @EndUserText.label: 'Material'
      cast ( _item.Material as matnr preserving type )          as material,
      @EndUserText.label: 'Description'
      _item.PurchasingDocumentItemText                          as description,
      @EndUserText.label: 'UoM'
      case when _item.OrderPriceUnit = _item.OrderQuantityUnit then _item.OrderPriceUnit
           when _item.OrderPriceUnit <> _item.OrderQuantityUnit then _item.OrderQuantityUnit
           else _item.OrderQuantityUnit
      end as unit,
//      cast ( _item.OrderPriceUnit as meins preserving type )    as unit,
      @EndUserText.label: 'Currency'
      cast( DocumentCurrency as waers preserving type ) as currency,
      @EndUserText.label: 'Net Price'
      @Semantics: { amount: { currencyCode: 'currency' } }
      _item.NetPriceAmount as netprice,
      @EndUserText.label: 'Vendor'
      cast ( Supplier as lifnr preserving type )                as supplier,
      @EndUserText.label: 'Name'
      _vend.SupplierName                                        as Name
      

}
