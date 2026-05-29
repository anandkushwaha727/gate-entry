@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View Of Gate Entry-MAN'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'Zrgno', 'Xblnr', 'Matnr', 'Lifnr' ]
@ObjectModel.usageType:{
        dataClass: #MIXED,
        serviceQuality: #X,
        sizeCategory: #S
}
define root view entity ZC_MAN_GATE
  provider contract transactional_query
  as projection on ZI_MAN_GATE
{
  key SapUuid,
  key Ebeln,
  key Ebelp,
  key Lifnr,
  key Matnr,
      Txz01,
      Zrgno,
      Xblnr,
      Zxdat,
      Ernam,
      Erdat,
      Bukrs,
      Werks,
      Lgort,
      @ObjectModel: { virtualElementCalculatedBy: 'ABAP:ZCL_MAN_GATE' }
      @EndUserText: { label: 'Schd Open Qty'}
      virtual soqty : abap.dec( 13, 2 ),
      Lsmng,
      Lsmeh,
      Zmdir,
      Zcarr,
      Kdmat,
      Vname,
      Ztext,
      Zgcat,
      xicon,
      action,
      criticality
}
