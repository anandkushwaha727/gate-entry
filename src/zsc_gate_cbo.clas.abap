"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>YY1_GATE_CDS</em>
CLASS zsc_gate_cbo DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">I_LanguageType</p>
      BEGIN OF tys_i_language_type,
        "! <em>Key property</em> Language
        language         TYPE c LENGTH 2,
        "! Language_Text
        language_text    TYPE c LENGTH 16,
        "! LanguageISOCode
        language_isocode TYPE c LENGTH 2,
      END OF tys_i_language_type,
      "! <p class="shorttext synchronized">List of I_LanguageType</p>
      tyt_i_language_type TYPE STANDARD TABLE OF tys_i_language_type WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">I_Scbo_ILM_Status_TextType</p>
      BEGIN OF tys_i_scbo_ilm_status_text_typ,
        "! <em>Key property</em> language
        language    TYPE c LENGTH 2,
        "! <em>Key property</em> code
        code        TYPE c LENGTH 10,
        "! description
        description TYPE c LENGTH 60,
      END OF tys_i_scbo_ilm_status_text_typ,
      "! <p class="shorttext synchronized">List of I_Scbo_ILM_Status_TextType</p>
      tyt_i_scbo_ilm_status_text_typ TYPE STANDARD TABLE OF tys_i_scbo_ilm_status_text_typ WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">I_UnitOfMeasureDimensionType</p>
      BEGIN OF tys_i_unit_of_measure_dimens_2,
        "! <em>Key property</em> UnitOfMeasureDimension
        unit_of_measure_dimension  TYPE c LENGTH 6,
        "! UnitOfMeasureDimension_Text
        unit_of_measure_dimensio_2 TYPE c LENGTH 20,
        "! LengthExponent
        length_exponent            TYPE int2,
        "! MassExponent
        mass_exponent              TYPE int2,
        "! TimeExponent
        time_exponent              TYPE int2,
        "! ElectricCurrentExponent
        electric_current_exponent  TYPE int2,
        "! TemperatureExponent
        temperature_exponent       TYPE int2,
        "! MoleQuantityExponent
        mole_quantity_exponent     TYPE int2,
        "! LuminosityExponent
        luminosity_exponent        TYPE int2,
        "! UnitOFMeasureSiUnit
        unit_ofmeasure_si_unit     TYPE c LENGTH 3,
        "! HasUnitsWithTemperatureSpec
        has_units_with_temperature TYPE abap_bool,
        "! HasUnitsWithPressureSpec
        has_units_with_pressure_sp TYPE abap_bool,
      END OF tys_i_unit_of_measure_dimens_2,
      "! <p class="shorttext synchronized">List of I_UnitOfMeasureDimensionType</p>
      tyt_i_unit_of_measure_dimens_2 TYPE STANDARD TABLE OF tys_i_unit_of_measure_dimens_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">I_UnitOfMeasureISOCodeType</p>
      BEGIN OF tys_i_unit_of_measure_isocod_2,
        "! <em>Key property</em> UnitOfMeasureISOCode
        unit_of_measure_isocode    TYPE c LENGTH 3,
        "! UnitOfMeasureISOCode_Text
        unit_of_measure_isocode_te TYPE c LENGTH 25,
      END OF tys_i_unit_of_measure_isocod_2,
      "! <p class="shorttext synchronized">List of I_UnitOfMeasureISOCodeType</p>
      tyt_i_unit_of_measure_isocod_2 TYPE STANDARD TABLE OF tys_i_unit_of_measure_isocod_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">I_UnitOfMeasureTextType</p>
      BEGIN OF tys_i_unit_of_measure_text_typ,
        "! <em>Key property</em> Language
        language                   TYPE c LENGTH 2,
        "! <em>Key property</em> UnitOfMeasure
        unit_of_measure            TYPE c LENGTH 3,
        "! UnitOfMeasureLongName
        unit_of_measure_long_name  TYPE c LENGTH 30,
        "! UnitOfMeasureName
        unit_of_measure_name       TYPE c LENGTH 10,
        "! UnitOfMeasureTechnicalName
        unit_of_measure_technical  TYPE c LENGTH 6,
        "! UnitOfMeasure_E
        unit_of_measure_e          TYPE c LENGTH 3,
        "! UnitOfMeasureCommercialName
        unit_of_measure_commercial TYPE c LENGTH 3,
      END OF tys_i_unit_of_measure_text_typ,
      "! <p class="shorttext synchronized">List of I_UnitOfMeasureTextType</p>
      tyt_i_unit_of_measure_text_typ TYPE STANDARD TABLE OF tys_i_unit_of_measure_text_typ WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">I_UnitOfMeasureType</p>
      BEGIN OF tys_i_unit_of_measure_type,
        "! <em>Key property</em> UnitOfMeasure
        unit_of_measure            TYPE c LENGTH 3,
        "! UnitOfMeasure_Text
        unit_of_measure_text       TYPE c LENGTH 30,
        "! UnitOfMeasureSAPCode
        unit_of_measure_sapcode    TYPE c LENGTH 3,
        "! UnitOfMeasureISOCode
        unit_of_measure_isocode    TYPE c LENGTH 3,
        "! IsPrimaryUnitForISOCode
        is_primary_unit_for_isocod TYPE abap_bool,
        "! UnitOfMeasureNumberOfDecimals
        unit_of_measure_number_of  TYPE int2,
        "! UnitOfMeasureIsCommercial
        unit_of_measure_is_commerc TYPE abap_bool,
        "! UnitOfMeasureDimension
        unit_of_measure_dimension  TYPE c LENGTH 6,
        "! SIUnitCnvrsnRateNumerator
        siunit_cnvrsn_rate_numerat TYPE int4,
        "! SIUnitCnvrsnRateDenominator
        siunit_cnvrsn_rate_denomin TYPE int4,
        "! SIUnitCnvrsnRateExponent
        siunit_cnvrsn_rate_exponen TYPE int2,
        "! SIUnitCnvrsnAdditiveValue
        siunit_cnvrsn_additive_val TYPE p LENGTH 5 DECIMALS 6,
        "! UnitOfMeasureDspExponent
        unit_of_measure_dsp_expone TYPE int2,
        "! UnitOfMeasureDspNmbrOfDcmls
        unit_of_measure_dsp_nmbr_o TYPE int2,
        "! UnitOfMeasureTemperature
        unit_of_measure_temperatur TYPE /iwbep/v4_float,
        "! UnitOfMeasureTemperatureUnit
        unit_of_measure_temperat_2 TYPE c LENGTH 3,
        "! UnitOfMeasurePressure
        unit_of_measure_pressure   TYPE /iwbep/v4_float,
        "! UnitOfMeasurePressureUnit
        unit_of_measure_pressure_u TYPE c LENGTH 3,
      END OF tys_i_unit_of_measure_type,
      "! <p class="shorttext synchronized">List of I_UnitOfMeasureType</p>
      tyt_i_unit_of_measure_type TYPE STANDARD TABLE OF tys_i_unit_of_measure_type WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">P_Scbo_UserType</p>
      BEGIN OF tys_p_scbo_user_type,
        "! <em>Key property</em> name
        name        TYPE c LENGTH 12,
        "! description
        description TYPE c LENGTH 80,
      END OF tys_p_scbo_user_type,
      "! <p class="shorttext synchronized">List of P_Scbo_UserType</p>
      tyt_p_scbo_user_type TYPE STANDARD TABLE OF tys_p_scbo_user_type WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">YY1_GATEType</p>
      BEGIN OF tys_yy_1_gatetype,
        "! <em>Key property</em> SAP_UUID
        sap_uuid                   TYPE sysuuid_x16,
        "! ZRGNO
        zrgno                      TYPE c LENGTH 10,
        "! ZSCPN
        zscpn                      TYPE c LENGTH 10,
        "! XBLNR
        xblnr                      TYPE c LENGTH 16,
        "! ZXDAT
        zxdat                      TYPE datn,
        "! ZCARR
        zcarr                      TYPE c LENGTH 10,
        "! LIFNR
        lifnr                      TYPE c LENGTH 10,
        "! VNAME
        vname                      TYPE c LENGTH 35,
        "! EBELN
        ebeln                      TYPE c LENGTH 10,
        "! EBELP
        ebelp                      TYPE c LENGTH 6,
        "! BUKRS
        bukrs                      TYPE c LENGTH 4,
        "! WERKS
        werks                      TYPE c LENGTH 4,
        "! LGORT
        lgort                      TYPE c LENGTH 4,
        "! MATNR
        matnr                      TYPE c LENGTH 18,
        "! TXZ01
        txz_01                     TYPE c LENGTH 40,
        "! MENGE_V
        menge_v                    TYPE p LENGTH 8 DECIMALS 3,
        "! MENGE_U
        menge_u                    TYPE c LENGTH 3,
        "! MENGE_U_Text
        menge_u_text               TYPE c LENGTH 30,
        "! MEINS_V
        meins_v                    TYPE p LENGTH 8 DECIMALS 3,
        "! MEINS_U
        meins_u                    TYPE c LENGTH 3,
        "! MEINS_U_Text
        meins_u_text               TYPE c LENGTH 30,
        "! LSMNG_V
        lsmng_v                    TYPE p LENGTH 8 DECIMALS 3,
        "! LSMNG_U
        lsmng_u                    TYPE c LENGTH 3,
        "! LSMNG_U_Text
        lsmng_u_text               TYPE c LENGTH 30,
        "! LSMEH_V
        lsmeh_v                    TYPE p LENGTH 8 DECIMALS 3,
        "! LSMEH_U
        lsmeh_u                    TYPE c LENGTH 3,
        "! LSMEH_U_Text
        lsmeh_u_text               TYPE c LENGTH 30,
        "! KDMAT
        kdmat                      TYPE c LENGTH 35,
        "! MBLNR
        mblnr                      TYPE c LENGTH 10,
        "! MJAHR
        mjahr                      TYPE c LENGTH 4,
        "! ZEILE
        zeile                      TYPE c LENGTH 4,
        "! ZDINV
        zdinv                      TYPE c LENGTH 1,
        "! VBELN
        vbeln                      TYPE c LENGTH 10,
        "! POSNR
        posnr                      TYPE c LENGTH 10,
        "! KUNNR
        kunnr                      TYPE c LENGTH 10,
        "! CNAME
        cname                      TYPE c LENGTH 36,
        "! ZEDIN
        zedin                      TYPE c LENGTH 10,
        "! AUFNR
        aufnr                      TYPE c LENGTH 12,
        "! ZCONF
        zconf                      TYPE c LENGTH 10,
        "! ZGCAT
        zgcat                      TYPE c LENGTH 4,
        "! ZMDIR
        zmdir                      TYPE c LENGTH 1,
        "! ZSTAT
        zstat                      TYPE c LENGTH 1,
        "! GRUND
        grund                      TYPE c LENGTH 50,
        "! SAP_CreatedDateTime
        sap_created_date_time      TYPE timestampl,
        "! SAP_CreatedByUser
        sap_created_by_user        TYPE c LENGTH 12,
        "! SAP_CreatedByUser_Text
        sap_created_by_user_text   TYPE c LENGTH 80,
        "! SAP_LastChangedDateTime
        sap_last_changed_date_time TYPE timestampl,
        "! SAP_LastChangedByUser
        sap_last_changed_by_user   TYPE c LENGTH 12,
        "! SAP_LastChangedByUser_Text
        sap_last_changed_by_user_t TYPE c LENGTH 80,
        "! SAP_LifecycleStatus
        sap_lifecycle_status       TYPE c LENGTH 1,
        "! SAP_LifecycleStatus_Text
        sap_lifecycle_status_text  TYPE c LENGTH 60,
        "!ERNAM
        ernam                      TYPE c LENGTH 20,
      END OF tys_yy_1_gatetype,
      "! <p class="shorttext synchronized">List of YY1_GATEType</p>
      tyt_yy_1_gatetype TYPE STANDARD TABLE OF tys_yy_1_gatetype WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! I_Language
        "! <br/> Collection of type 'I_LanguageType'
        i_language                 TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_LANGUAGE',
        "! I_Scbo_ILM_Status_Text
        "! <br/> Collection of type 'I_Scbo_ILM_Status_TextType'
        i_scbo_ilm_status_text     TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_SCBO_ILM_STATUS_TEXT',
        "! I_UnitOfMeasure
        "! <br/> Collection of type 'I_UnitOfMeasureType'
        i_unit_of_measure          TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_UNIT_OF_MEASURE',
        "! I_UnitOfMeasureDimension
        "! <br/> Collection of type 'I_UnitOfMeasureDimensionType'
        i_unit_of_measure_dimensio TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_UNIT_OF_MEASURE_DIMENSIO',
        "! I_UnitOfMeasureISOCode
        "! <br/> Collection of type 'I_UnitOfMeasureISOCodeType'
        i_unit_of_measure_isocode  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_UNIT_OF_MEASURE_ISOCODE',
        "! I_UnitOfMeasureText
        "! <br/> Collection of type 'I_UnitOfMeasureTextType'
        i_unit_of_measure_text     TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'I_UNIT_OF_MEASURE_TEXT',
        "! P_Scbo_User
        "! <br/> Collection of type 'P_Scbo_UserType'
        p_scbo_user                TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'P_SCBO_USER',
        "! YY1_GATE
        "! <br/> Collection of type 'YY1_GATEType'
        yy_1_gate                  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'YY_1_GATE',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for I_LanguageType</p>
        "! See also structure type {@link ..tys_i_language_type}
        BEGIN OF i_language_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF i_language_type,
        "! <p class="shorttext synchronized">Internal names for I_Scbo_ILM_Status_TextType</p>
        "! See also structure type {@link ..tys_i_scbo_ilm_status_text_typ}
        BEGIN OF i_scbo_ilm_status_text_typ,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF i_scbo_ilm_status_text_typ,
        "! <p class="shorttext synchronized">Internal names for I_UnitOfMeasureDimensionType</p>
        "! See also structure type {@link ..tys_i_unit_of_measure_dimens_2}
        BEGIN OF i_unit_of_measure_dimens_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF i_unit_of_measure_dimens_2,
        "! <p class="shorttext synchronized">Internal names for I_UnitOfMeasureISOCodeType</p>
        "! See also structure type {@link ..tys_i_unit_of_measure_isocod_2}
        BEGIN OF i_unit_of_measure_isocod_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF i_unit_of_measure_isocod_2,
        "! <p class="shorttext synchronized">Internal names for I_UnitOfMeasureTextType</p>
        "! See also structure type {@link ..tys_i_unit_of_measure_text_typ}
        BEGIN OF i_unit_of_measure_text_typ,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_Language
            to_language        TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_LANGUAGE',
            "! to_UnitOfMeasure
            to_unit_of_measure TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_UNIT_OF_MEASURE',
          END OF navigation,
        END OF i_unit_of_measure_text_typ,
        "! <p class="shorttext synchronized">Internal names for I_UnitOfMeasureType</p>
        "! See also structure type {@link ..tys_i_unit_of_measure_type}
        BEGIN OF i_unit_of_measure_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_Dimension
            to_dimension TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_DIMENSION',
            "! to_ISOCode
            to_isocode   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ISOCODE',
          END OF navigation,
        END OF i_unit_of_measure_type,
        "! <p class="shorttext synchronized">Internal names for P_Scbo_UserType</p>
        "! See also structure type {@link ..tys_p_scbo_user_type}
        BEGIN OF p_scbo_user_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF p_scbo_user_type,
        "! <p class="shorttext synchronized">Internal names for YY1_GATEType</p>
        "! See also structure type {@link ..tys_yy_1_gatetype}
        BEGIN OF yy_1_gatetype,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! to_ILM_Status_Text
            to_ilm_status_text         TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_ILM_STATUS_TEXT',
            "! to_LSMEH
            to_lsmeh                   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_LSMEH',
            "! to__LSMEH
            to_lsmeh_2                 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_LSMEH_2',
            "! to_LSMNG
            to_lsmng                   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_LSMNG',
            "! to__LSMNG
            to_lsmng_2                 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_LSMNG_2',
            "! to_MEINS
            to_meins                   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_MEINS',
            "! to__MEINS
            to_meins_2                 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_MEINS_2',
            "! to_MENGE
            to_menge                   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_MENGE',
            "! to__MENGE
            to_menge_2                 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_MENGE_2',
            "! to_SAPSysAdminDataChangeUser
            to_sapsys_admin_data_chang TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_SAPSYS_ADMIN_DATA_CHANG',
            "! to_SAPSysAdminDataCreateUser
            to_sapsys_admin_data_creat TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TO_SAPSYS_ADMIN_DATA_CREAT',
          END OF navigation,
        END OF yy_1_gatetype,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define I_LanguageType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_language_type RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define I_Scbo_ILM_Status_TextType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_scbo_ilm_status_text_typ RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define I_UnitOfMeasureDimensionType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_unit_of_measure_dimens_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define I_UnitOfMeasureISOCodeType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_unit_of_measure_isocod_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define I_UnitOfMeasureTextType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_unit_of_measure_text_typ RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define I_UnitOfMeasureType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_i_unit_of_measure_type RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define P_Scbo_UserType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_p_scbo_user_type RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define YY1_GATEType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_yy_1_gatetype RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZSC_GATE_CBO IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'YY1_GATE_CDS' ) ##NO_TEXT.

    def_i_language_type( ).
    def_i_scbo_ilm_status_text_typ( ).
    def_i_unit_of_measure_dimens_2( ).
    def_i_unit_of_measure_isocod_2( ).
    def_i_unit_of_measure_text_typ( ).
    def_i_unit_of_measure_type( ).
    def_p_scbo_user_type( ).
    def_yy_1_gatetype( ).

  ENDMETHOD.


  METHOD def_i_language_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_LANGUAGE_TYPE'
                                    is_structure              = VALUE tys_i_language_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_LanguageType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_LANGUAGE' ).
    lo_entity_set->set_edm_name( 'I_Language' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'Language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE_TEXT' ).
    lo_primitive_property->set_edm_name( 'Language_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 16 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE_ISOCODE' ).
    lo_primitive_property->set_edm_name( 'LanguageISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_i_scbo_ilm_status_text_typ.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_SCBO_ILM_STATUS_TEXT_TYP'
                                    is_structure              = VALUE tys_i_scbo_ilm_status_text_typ( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_Scbo_ILM_Status_TextType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_SCBO_ILM_STATUS_TEXT' ).
    lo_entity_set->set_edm_name( 'I_Scbo_ILM_Status_Text' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CODE' ).
    lo_primitive_property->set_edm_name( 'code' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'description' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_i_unit_of_measure_dimens_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_UNIT_OF_MEASURE_DIMENS_2'
                                    is_structure              = VALUE tys_i_unit_of_measure_dimens_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_UnitOfMeasureDimensionType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_UNIT_OF_MEASURE_DIMENSIO' ).
    lo_entity_set->set_edm_name( 'I_UnitOfMeasureDimension' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_DIMENSION' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureDimension' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_DIMENSIO_2' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureDimension_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LENGTH_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'LengthExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MASS_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'MassExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TIME_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'TimeExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ELECTRIC_CURRENT_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'ElectricCurrentExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TEMPERATURE_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'TemperatureExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MOLE_QUANTITY_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'MoleQuantityExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LUMINOSITY_EXPONENT' ).
    lo_primitive_property->set_edm_name( 'LuminosityExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OFMEASURE_SI_UNIT' ).
    lo_primitive_property->set_edm_name( 'UnitOFMeasureSiUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HAS_UNITS_WITH_TEMPERATURE' ).
    lo_primitive_property->set_edm_name( 'HasUnitsWithTemperatureSpec' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HAS_UNITS_WITH_PRESSURE_SP' ).
    lo_primitive_property->set_edm_name( 'HasUnitsWithPressureSpec' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_i_unit_of_measure_isocod_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_UNIT_OF_MEASURE_ISOCOD_2'
                                    is_structure              = VALUE tys_i_unit_of_measure_isocod_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_UnitOfMeasureISOCodeType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_UNIT_OF_MEASURE_ISOCODE' ).
    lo_entity_set->set_edm_name( 'I_UnitOfMeasureISOCode' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_ISOCODE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_ISOCODE_TE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureISOCode_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 25 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_i_unit_of_measure_text_typ.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_UNIT_OF_MEASURE_TEXT_TYP'
                                    is_structure              = VALUE tys_i_unit_of_measure_text_typ( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_UnitOfMeasureTextType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_UNIT_OF_MEASURE_TEXT' ).
    lo_entity_set->set_edm_name( 'I_UnitOfMeasureText' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'Language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasure' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_LONG_NAME' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureLongName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_NAME' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_TECHNICAL' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureTechnicalName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_E' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasure_E' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_COMMERCIAL' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureCommercialName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_LANGUAGE' ).
    lo_navigation_property->set_edm_name( 'to_Language' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_LANGUAGE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_UNIT_OF_MEASURE' ).
    lo_navigation_property->set_edm_name( 'to_UnitOfMeasure' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

  ENDMETHOD.


  METHOD def_i_unit_of_measure_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'I_UNIT_OF_MEASURE_TYPE'
                                    is_structure              = VALUE tys_i_unit_of_measure_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'I_UnitOfMeasureType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'I_UNIT_OF_MEASURE' ).
    lo_entity_set->set_edm_name( 'I_UnitOfMeasure' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasure' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_TEXT' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasure_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_SAPCODE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureSAPCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_ISOCODE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IS_PRIMARY_UNIT_FOR_ISOCOD' ).
    lo_primitive_property->set_edm_name( 'IsPrimaryUnitForISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_NUMBER_OF' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureNumberOfDecimals' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_IS_COMMERC' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureIsCommercial' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_DIMENSION' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureDimension' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIUNIT_CNVRSN_RATE_NUMERAT' ).
    lo_primitive_property->set_edm_name( 'SIUnitCnvrsnRateNumerator' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIUNIT_CNVRSN_RATE_DENOMIN' ).
    lo_primitive_property->set_edm_name( 'SIUnitCnvrsnRateDenominator' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIUNIT_CNVRSN_RATE_EXPONEN' ).
    lo_primitive_property->set_edm_name( 'SIUnitCnvrsnRateExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIUNIT_CNVRSN_ADDITIVE_VAL' ).
    lo_primitive_property->set_edm_name( 'SIUnitCnvrsnAdditiveValue' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 9 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_DSP_EXPONE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureDspExponent' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_DSP_NMBR_O' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureDspNmbrOfDcmls' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_TEMPERATUR' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureTemperature' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Double' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_TEMPERAT_2' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasureTemperatureUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_PRESSURE' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasurePressure' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Double' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_OF_MEASURE_PRESSURE_U' ).
    lo_primitive_property->set_edm_name( 'UnitOfMeasurePressureUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_DIMENSION' ).
    lo_navigation_property->set_edm_name( 'to_Dimension' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_DIMENS_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ISOCODE' ).
    lo_navigation_property->set_edm_name( 'to_ISOCode' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_ISOCOD_2' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

  ENDMETHOD.


  METHOD def_p_scbo_user_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'P_SCBO_USER_TYPE'
                                    is_structure              = VALUE tys_p_scbo_user_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'P_Scbo_UserType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'P_SCBO_USER' ).
    lo_entity_set->set_edm_name( 'P_Scbo_User' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'NAME' ).
    lo_primitive_property->set_edm_name( 'name' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'description' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_yy_1_gatetype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'YY_1_GATETYPE'
                                    is_structure              = VALUE tys_yy_1_gatetype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'YY1_GATEType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'YY_1_GATE' ).
    lo_entity_set->set_edm_name( 'YY1_GATE' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_UUID' ).
    lo_primitive_property->set_edm_name( 'SAP_UUID' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZRGNO' ).
    lo_primitive_property->set_edm_name( 'ZRGNO' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZSCPN' ).
    lo_primitive_property->set_edm_name( 'ZSCPN' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'XBLNR' ).
    lo_primitive_property->set_edm_name( 'XBLNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 16 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZXDAT' ).
    lo_primitive_property->set_edm_name( 'ZXDAT' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZCARR' ).
    lo_primitive_property->set_edm_name( 'ZCARR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LIFNR' ).
    lo_primitive_property->set_edm_name( 'LIFNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VNAME' ).
    lo_primitive_property->set_edm_name( 'VNAME' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EBELN' ).
    lo_primitive_property->set_edm_name( 'EBELN' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EBELP' ).
    lo_primitive_property->set_edm_name( 'EBELP' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BUKRS' ).
    lo_primitive_property->set_edm_name( 'BUKRS' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WERKS' ).
    lo_primitive_property->set_edm_name( 'WERKS' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LGORT' ).
    lo_primitive_property->set_edm_name( 'LGORT' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATNR' ).
    lo_primitive_property->set_edm_name( 'MATNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TXZ_01' ).
    lo_primitive_property->set_edm_name( 'TXZ01' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MENGE_V' ).
    lo_primitive_property->set_edm_name( 'MENGE_V' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MENGE_U' ).
    lo_primitive_property->set_edm_name( 'MENGE_U' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MENGE_U_TEXT' ).
    lo_primitive_property->set_edm_name( 'MENGE_U_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MEINS_V' ).
    lo_primitive_property->set_edm_name( 'MEINS_V' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MEINS_U' ).
    lo_primitive_property->set_edm_name( 'MEINS_U' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MEINS_U_TEXT' ).
    lo_primitive_property->set_edm_name( 'MEINS_U_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMNG_V' ).
    lo_primitive_property->set_edm_name( 'LSMNG_V' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMNG_U' ).
    lo_primitive_property->set_edm_name( 'LSMNG_U' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMNG_U_TEXT' ).
    lo_primitive_property->set_edm_name( 'LSMNG_U_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMEH_V' ).
    lo_primitive_property->set_edm_name( 'LSMEH_V' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMEH_U' ).
    lo_primitive_property->set_edm_name( 'LSMEH_U' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LSMEH_U_TEXT' ).
    lo_primitive_property->set_edm_name( 'LSMEH_U_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'KDMAT' ).
    lo_primitive_property->set_edm_name( 'KDMAT' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MBLNR' ).
    lo_primitive_property->set_edm_name( 'MBLNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MJAHR' ).
    lo_primitive_property->set_edm_name( 'MJAHR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZEILE' ).
    lo_primitive_property->set_edm_name( 'ZEILE' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZDINV' ).
    lo_primitive_property->set_edm_name( 'ZDINV' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VBELN' ).
    lo_primitive_property->set_edm_name( 'VBELN' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'POSNR' ).
    lo_primitive_property->set_edm_name( 'POSNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'KUNNR' ).
    lo_primitive_property->set_edm_name( 'KUNNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CNAME' ).
    lo_primitive_property->set_edm_name( 'CNAME' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 36 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZEDIN' ).
    lo_primitive_property->set_edm_name( 'ZEDIN' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AUFNR' ).
    lo_primitive_property->set_edm_name( 'AUFNR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZCONF' ).
    lo_primitive_property->set_edm_name( 'ZCONF' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZGCAT' ).
    lo_primitive_property->set_edm_name( 'ZGCAT' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZMDIR' ).
    lo_primitive_property->set_edm_name( 'ZMDIR' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ZSTAT' ).
    lo_primitive_property->set_edm_name( 'ZSTAT' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GRUND' ).
    lo_primitive_property->set_edm_name( 'GRUND' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 50 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_CREATED_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'SAP_CreatedDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_CREATED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'SAP_CreatedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_CREATED_BY_USER_TEXT' ).
    lo_primitive_property->set_edm_name( 'SAP_CreatedByUser_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_LAST_CHANGED_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'SAP_LastChangedDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_LAST_CHANGED_BY_USER' ).
    lo_primitive_property->set_edm_name( 'SAP_LastChangedByUser' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_LAST_CHANGED_BY_USER_T' ).
    lo_primitive_property->set_edm_name( 'SAP_LastChangedByUser_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_LIFECYCLE_STATUS' ).
    lo_primitive_property->set_edm_name( 'SAP_LifecycleStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SAP_LIFECYCLE_STATUS_TEXT' ).
    lo_primitive_property->set_edm_name( 'SAP_LifecycleStatus_Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_ILM_STATUS_TEXT' ).
    lo_navigation_property->set_edm_name( 'to_ILM_Status_Text' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_SCBO_ILM_STATUS_TEXT_TYP' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_LSMEH' ).
    lo_navigation_property->set_edm_name( 'to_LSMEH' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_LSMEH_2' ).
    lo_navigation_property->set_edm_name( 'to__LSMEH' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TEXT_TYP' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_LSMNG' ).
    lo_navigation_property->set_edm_name( 'to_LSMNG' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_LSMNG_2' ).
    lo_navigation_property->set_edm_name( 'to__LSMNG' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TEXT_TYP' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_MEINS' ).
    lo_navigation_property->set_edm_name( 'to_MEINS' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_MEINS_2' ).
    lo_navigation_property->set_edm_name( 'to__MEINS' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TEXT_TYP' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_MENGE' ).
    lo_navigation_property->set_edm_name( 'to_MENGE' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_MENGE_2' ).
    lo_navigation_property->set_edm_name( 'to__MENGE' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'I_UNIT_OF_MEASURE_TEXT_TYP' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_SAPSYS_ADMIN_DATA_CHANG' ).
    lo_navigation_property->set_edm_name( 'to_SAPSysAdminDataChangeUser' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'P_SCBO_USER_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TO_SAPSYS_ADMIN_DATA_CREAT' ).
    lo_navigation_property->set_edm_name( 'to_SAPSysAdminDataCreateUser' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'P_SCBO_USER_TYPE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).

  ENDMETHOD.
ENDCLASS.
