*&---------------------------------------------------------------------*
*& Report zdgp_test_category
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdgp_test_category.

DATA:o_appl_message  TYPE REF TO zif_appl_message,
     o_category_cntl TYPE REF TO zif_dpg_category_cntl.

DATA: s_category type zdpg_category,
       s_category_key TYPE zdpg_category_key.

INITIALIZATION.

  o_category_cntl ?= zcl_appl_cntl=>get_single_obj( 'DPG_CATEGORY_CNTL' ).
  o_appl_message = zcl_appl_cntl=>get_appl_message( ).

START-OF-SELECTION.

  BREAK-POINT.

  s_category-category = 'TEST_07'.

  DATA(lo_category) = o_category_cntl->create_category( s_category ).

  DATA(ls_category_fields) = lo_category->get_category_fields( ).

  ls_category_fields-customer = 'X'.
  ls_category_fields-cat_txt = 'Test Nummer 7'.

  lo_category->set_category_fields( ls_category_fields  ).

  zcl_appl_cntl=>save_all( ).
  o_appl_message->show_messages( 'M' ).

  BREAK-POINT .
