CLASS zcl_num_range DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : ty_num TYPE c LENGTH 10.
    CLASS-DATA : gv_num  TYPE n LENGTH 10,
                 ge_num  TYPE cl_numberrange_runtime=>nr_number.

    class-METHODS : get_ge_num_next RETURNING VALUE(rt_num) TYPE ty_num,
                    get_ge_out_num_next RETURNING VALUE(rt_num) TYPE ty_num.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_NUM_RANGE IMPLEMENTATION.


  METHOD get_ge_num_next.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*         ignore_buffer     =
          nr_range_nr       = '01'
          object            = 'ZGATE_ENT'
      IMPORTING
        number            = ge_num
        returncode        = DATA(ret_code)
      ).

      rt_num = ge_num+10(10).

      CATCH cx_number_ranges INTO DATA(cx_num).
        "handle exception
        RAISE SHORTDUMP cx_num.
    ENDTRY.
  ENDMETHOD.


  METHOD GET_GE_OUT_NUM_NEXT.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*         ignore_buffer     =
          nr_range_nr       = '02'
          object            = 'ZGATE_ENT'
      IMPORTING
        number            = ge_num
        returncode        = DATA(ret_code)
      ).

      rt_num = ge_num+10(10).

      CATCH cx_number_ranges INTO DATA(cx_num).
        "handle exception
        RAISE SHORTDUMP cx_num.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
