@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Gate Entry - MAN Head'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_GATE_HEAD as select from ZI_PDET_HEAD
composition [1..*] of ZI_GATE_ITEM as _item
association [1..1] to zdt_gate_head as _tab on ZI_PDET_HEAD.ebeln = _tab.ebeln
                                           and _tab.ernam = $session.user
{
    key ZI_PDET_HEAD.ebeln as ebeln,
    cast('' as abap.char(3)) as xicon,
    case when _tab.ernam is initial then $session.user
         when _tab.ernam is not initial then _tab.ernam
         else $session.user
     end as ernam,
    case when _tab.erdat is initial then $session.system_date
         when _tab.erdat is not initial then _tab.erdat
         else $session.system_date 
    end as erdat,
//    tstmp_to_tims( tstmp_current_utctimestamp(),
//                     abap_system_timezone( $session.client,'NULL' ),
//                     $session.client,
//                     'NULL' )      as erzet,
//    ZSF_GATE_HEAD_DATE ( table_time=>_tab.erzet, system_time=>tstmp_to_tims( tstmp_current_utctimestamp(),
//                                                              abap_system_timezone( $session.client,'NULL' ),
//                                                              $session.client,'NULL' ) ) as comptime,
    ZI_PDET_HEAD.erzet as erzet,
    
    case when _tab.zrgno is initial then ''
         when ( _tab.erzet = ZI_PDET_HEAD.erzet ) then _tab.zrgno
         when ( _tab.erzet <> ZI_PDET_HEAD.erzet ) then ''
         else ''
     end as zrgno,
    case when _tab.ztext is initial then 'Ready to Post'
         when ( _tab.ztext is not initial and _tab.erzet = ZI_PDET_HEAD.erzet ) then _tab.ztext
         else 'Ready to Post'
     end as ztext,
    ZI_PDET_HEAD.bsart as bsart,
    case when ( ZI_PDET_HEAD.lifnr is initial and _tab.lifnr is not initial ) then _tab.lifnr
         when ZI_PDET_HEAD.lifnr is not initial then ZI_PDET_HEAD.lifnr
         else ZI_PDET_HEAD.lifnr
     end as lifnr,
    case when ( ZI_PDET_HEAD.lifnr is initial and _tab.lifnr is not initial ) then _tab.vname
         when ZI_PDET_HEAD.lifnr is not initial then ZI_PDET_HEAD.lname
         else ZI_PDET_HEAD.lname
     end as lname,
    ZI_PDET_HEAD.bukrs as bukrs,
    case when _tab.zrgno is initial then ''
         when ( _tab.erzet = ZI_PDET_HEAD.erzet and _tab.zrgno is not initial ) then _tab.xblnr
         when ( _tab.erzet <> ZI_PDET_HEAD.erzet and _tab.zrgno is not initial) then ''
         else ''
     end as xblnr,
//    case when _tab.zxdat is initial then ''
//         when ( _tab.zxdat is not initial and _tab.erzet = ZI_PDET_HEAD.erzet ) then _tab.zxdat
//         when ( _tab.zxdat is not initial and _tab.erzet <> ZI_PDET_HEAD.erzet ) then ''
//         else ''
//     end as zxdat,
    $session.system_date as zxdat,
    case when _tab.zgcat is initial then 'MAN'
         when _tab.zgcat is not initial then _tab.zgcat
         else 'MAN'
     end as zgcat,
    _tab.zcarr,    
    case when _tab.zmdir is initial then '1'
         when _tab.zmdir is not initial then _tab.zmdir
         else '1'
     end as zmdir,  
    case when _tab.zrgno is initial then 2
         when ( _tab.zrgno is not initial and _tab.erzet = ZI_PDET_HEAD.erzet )  then 3
         when ( _tab.zrgno is not initial and _tab.erzet <> ZI_PDET_HEAD.erzet )  then 2
         when _tab.zrgno = '0000000000' then 1
         else 2
    end                      as criticality,
    cast('' as abap.char(3)) as action,    
    
    /*Associations*/
    _tab,
    _item
}
