@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Gate Entry - MAN'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MAN_GATE
  as select from zdt_gate_man 
{
  key sap_uuid                 as SapUuid,
  key ebeln                    as Ebeln,
  key ebelp                    as Ebelp,
  key lifnr                    as Lifnr,
  key matnr                    as Matnr,
      txz01                    as Txz01,
      zrgno                    as Zrgno,
      xblnr                    as Xblnr,
      zxdat                    as Zxdat,
      ernam                    as Ernam,
      erdat                    as Erdat,
      bukrs                    as Bukrs,
      werks                    as Werks,
      lgort                    as Lgort,
      lsmng                    as Lsmng,
      lsmeh                    as Lsmeh,
      zmdir                    as Zmdir,
      zcarr                    as Zcarr,
      kdmat                    as Kdmat,
      vname                    as Vname,
      case when ztext = '' then 'Gate Entry Can be Created'
           when ztext != '' then ztext
           else 'Gate Entry Can be Created'
      end                      as Ztext,
      zgcat                    as Zgcat,
      cast('' as abap.char(3)) as xicon,
      cast('' as abap.char(3)) as action,
      case when zrgno != '' then 3
           when zrgno = '' then 2
           else 1
      end                      as criticality
}//#EC CI_NOWHERE  
