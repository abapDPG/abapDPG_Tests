*&---------------------------------------------------------------------*
*& Report ZDPG_TEST_EXCEPTIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpg_test_exceptions.

DATA: o_category_cntl TYPE REF TO zif_dpg_category_cntl,
      s_category      TYPE zdpg_category,
      s_category_key  TYPE zdpg_category_key.

INITIALIZATION.

  o_category_cntl ?= zcl_appl_cntl=>get_single_obj( 'DPG_CATEGORY_CNTL' ).

START-OF-SELECTION.

  BREAK-POINT.

  s_category-category = 'TEST_07'.

  TRY.
      DATA(lo_category) = o_category_cntl->create_category( s_category ).
    CATCH BEFORE UNWIND zcx_dpg_category_exists.  " Exception Category exists
    CATCH BEFORE UNWIND zcx_dpg_wrong_parameters INTO DATA(lo_exc). " WRONG_PARAMETERS
  ENDTRY.

  BREAK-POINT.
