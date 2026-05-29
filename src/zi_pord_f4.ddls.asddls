@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of PORD Value Help'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_PORD_F4
  as select from I_PurchaseOrderAPI01
  association [1..1] to I_PurchaseOrderItemAPI01 as _item on I_PurchaseOrderAPI01.PurchaseOrder = _item.PurchaseOrder
                                                         and _item.Material != ' '
  association [1..1] to I_Supplier as _vend on I_PurchaseOrderAPI01.Supplier = _vend.Supplier
{
      @EndUserText.label: 'Order No'
  key I_PurchaseOrderAPI01.PurchaseOrder                        as porder,
      @EndUserText.label: 'Item'
  key _item.PurchaseOrderItem                                   as item,
      @EndUserText.label: 'Doc Type'
      I_PurchaseOrderAPI01.PurchaseOrderType                    as doctype,
      @EndUserText.label: 'Comp Code'
      cast ( _item.CompanyCode as bukrs preserving type )       as bukrs,
      @EndUserText.label: 'Plant'
      cast ( _item.Plant as werks_d preserving type )           as plant,
      @EndUserText.label: 'Supplying Plant'
      cast( I_PurchaseOrderAPI01.SupplyingPlant as werks_d preserving type ) as supplant,
      @EndUserText.label: 'Str Loc'
      cast ( _item.StorageLocation as lgort_d preserving type ) as strloc,
      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MAT_F4', element: 'Product' }}]
      cast ( _item.Material as matnr preserving type )          as material,
      @EndUserText.label: 'Description'
      _item.PurchaseOrderItemText as description,
      @EndUserText.label: 'UoM'
      case when _item.OrderPriceUnit = _item.PurchaseOrderQuantityUnit then _item.OrderPriceUnit
           when _item.OrderPriceUnit <> _item.PurchaseOrderQuantityUnit then _item.PurchaseOrderQuantityUnit
           else _item.PurchaseOrderQuantityUnit
      end as unit,
 //     cast ( _item.PurchaseOrderQuantityUnit as meins preserving type ) as unit,
      @EndUserText: {label: 'Currency'}
      cast( I_PurchaseOrderAPI01.DocumentCurrency as waers preserving type ) as currency,
      @EndUserText: {label: 'Net Price'}
      @Semantics: {
          amount: { currencyCode: 'currency' }
      }
      _item.NetPriceAmount as netprice,
      @EndUserText.label: 'Vendor'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_VEND_F4', element: 'Supplier' }}]
      cast ( Supplier as lifnr preserving type )                as supplier,
      @EndUserText.label: 'Name'
      _vend.SupplierName                                        as name
      
      
}
