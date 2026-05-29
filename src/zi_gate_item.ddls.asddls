@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Gate Entry - MAN Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GATE_ITEM as select from ZI_PDET_ITEM
association to parent ZI_GATE_HEAD as _head on $projection.ebeln = _head.ebeln
association [1..*] to zdt_gate_man as _table on ZI_PDET_ITEM.ebeln = _table.ebeln
                                            and ZI_PDET_ITEM.ebelp = _table.ebelp
{
    key ebeln,
    key ebelp,
    case when ( _table.zrgno is not initial and _table.erzet = ZI_PDET_ITEM.erzet) then _table.zrgno
         when _table.zrgno is initial then ''
         when ( _table.zrgno is not initial and _table.erzet <> ZI_PDET_ITEM.erzet) then ''
         else '' 
     end as zrgno,
    werks,
    lgort,
    matnr,
    maktx,
    case when ( _table.lsmng > 0 and _table.erzet = ZI_PDET_ITEM.erzet ) then _table.lsmng 
         when ( _table.lsmng > 0 and _table.erzet <> ZI_PDET_ITEM.erzet ) then 0
         when _table.lsmng = 0 then 0
         else 0 
     end as menge,
    meins,
    waers,
    netpr,
    _table.xblnr as xblnr,
    case when _table.zxdat is initial then $session.system_date
         else _table.zxdat
     end as zxdat,
    _table.zcarr,
    cast('' as abap.char(3)) as xicon,
    case when _table.zrgno = '' then 2
         when _table.zrgno != '' then 3
         when _table.zrgno = '0000000000' then 1
         else 2
    end                      as criticality,
    case when _table.ztext is initial then 'Ready to Post'
         when _table.ztext is not initial then _table.ztext
         else 'Ready to Post'
     end as ztext,
    cast('' as abap.char(3)) as action,
    
    /* Associations */
    _head,
    _table   
}
