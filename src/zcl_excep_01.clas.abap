CLASS zcl_excep_01 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor .
    METHODS proceed
      RAISING
        zcx_dpg_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS work_01
      RAISING
        zcx_dpg_not_found.
    METHODS work_02 .
    METHODS work_03 .
ENDCLASS.



CLASS ZCL_EXCEP_01 IMPLEMENTATION.


  METHOD constructor.
  ENDMETHOD.


  METHOD proceed.
    TRY .
        work_01( ).
      CATCH zcx_dpg_not_found INTO DATA(lx_error).
*       RAISE EXCEPTION TYPE zcx_dpg_exception( previous =  lx_error ).
    ENDTRY.


  ENDMETHOD.


  METHOD work_01.

    RAISE RESUMABLE EXCEPTION TYPE zcx_dpg_not_found.

  ENDMETHOD.


  METHOD work_02.
    RAISE RESUMABLE EXCEPTION TYPE cx_sy_arithmetic_overflow
      EXPORTING
        operation = 'test'.
  ENDMETHOD.


  METHOD work_03.

  ENDMETHOD.
ENDCLASS.
