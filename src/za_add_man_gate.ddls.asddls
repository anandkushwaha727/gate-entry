@EndUserText.label: 'Abstract Interface View for GE - Manual'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'xblnr', 'zxdat', 'menge', 'vehno' ]
define abstract entity ZA_ADD_MAN_GATE
{
    xblnr : abap.char(16);
    zxdat : abap.dats;
    vehno : abap.char(10);
    puord : ebeln; 
    schag : ebeln;
    vendor : lifnr;
    product : matnr;
    menge : abap.dec( 13, 2 );
}
