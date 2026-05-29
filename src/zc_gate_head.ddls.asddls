@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View Of Gate Entry-MAN HEAD'
@Metadata: { allowExtensions: true, ignorePropagatedAnnotations: true }
define root view entity ZC_GATE_HEAD
  provider contract transactional_query as projection on ZI_GATE_HEAD
{
    key ebeln,
    xicon,
    zrgno,
    ztext,
    bsart,
    lifnr,
    lname,
    bukrs,
    xblnr,
    zxdat,
    ernam,
    erdat,
    erzet,
    zgcat,
    zcarr,
    zmdir,
    criticality,
    action,
    /* Associations */
    _item : redirected to composition child ZC_GATE_ITEM,
    _tab
} where ernam = $session.user
