*&---------------------------------------------------------------------*
*& Report ZDPG_TEST_PKG_CNTL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpg_test_pkg_cntl.


DATA lo_plg_cntl TYPE REF TO zif_dpg_core_plg_cntl.



START-OF-SELECTION.


  lo_plg_cntl  ?= zcl_appl_cntl=>get_single_obj( 'DPG_PLG_CNTL' ).
  DATA(lt_pointer) = lo_plg_cntl->get_plugin_tab( ).
  BREAK-POINT.
