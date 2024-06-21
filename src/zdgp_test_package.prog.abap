*&---------------------------------------------------------------------*
*& Report ZDGP_TEST_PACKAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdgp_test_package.

DATA : o_appl_message TYPE REF TO zif_appl_message,
       o_cntl         TYPE REF TO zif_dpg_package_cntl,
       o_object       TYPE REF TO zif_appl_object,
       s_package      TYPE zdpg_packages,
       s_key          TYPE zdpg_package_key.

INITIALIZATION.

  o_cntl ?= zcl_appl_cntl=>get_single_obj( 'DPG_PACKAGE_CNTL' ).
  o_appl_message = zcl_appl_cntl=>get_appl_message( ).

START-OF-SELECTION.
  s_package-packet = '$DPG_BEHAVIORAL_PATTERNS'.

  DATA:
    lt_param TYPE abap_parmbind_tab,
    ls_param TYPE abap_parmbind.
  ls_param-name = 'IM_PACKAGE'.
  ls_param-kind = cl_abap_objectdescr=>exporting.
  GET REFERENCE OF s_package INTO ls_param-value.
  INSERT ls_param INTO TABLE lt_param.
  BREAK-POINT.

  CALL METHOD zcl_appl_cntl=>create_object
    EXPORTING
      im_obj_type  = 'DPG_PACKAGE'
      it_parameter = lt_param
    IMPORTING
      ex_object    = o_object.


  BREAK-POINT.



  o_cntl->add_package( s_package ).

  zcl_appl_cntl=>save_all( ).
  o_appl_message->show_messages( 'M' ).
  BREAK-POINT.
