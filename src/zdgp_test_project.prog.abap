*&---------------------------------------------------------------------*
*& Report ZDGP_TEST_PROJECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdgp_test_project.

DATA:
  s_project_01     TYPE zdpg_project,

  s_project_key_01 TYPE zdpg_project_key,
  s_project_02     TYPE zdpg_project,
  s_project_key_02 TYPE zdpg_project_key,
  lo_project       TYPE REF TO zif_dpg_project,
  o_appl_message   TYPE REF TO zif_appl_message,
  o_cntl           TYPE REF TO zif_dpg_project_cntl.


INITIALIZATION.

  o_cntl ?= zcl_appl_cntl=>get_single_obj( 'DPG_PROJECT_CNTL' ).
  o_appl_message = zcl_appl_cntl=>get_appl_message( ).

START-OF-SELECTION.
  BREAK-POINT.
*  DATA(lt_project_tab) = o_cntl->get_project_tab( ).
  s_project_01-identifier = 'TEST_03'.
   lo_project ?= o_cntl->create_project( s_project_01 ).
*  s_project_01 = lo_project->get_project( ).

  lo_project->get_project_fields( ).

  s_project_02-identifier = 'TEST_04'.
  lo_project ?= o_cntl->create_project( s_project_02 ).
*  s_project_02 = lo_project->get_project( ).

  zcl_appl_cntl=>save_all( ).
  o_appl_message->show_messages( 'M' ).

  BREAK-POINT.

  o_cntl->delete_project( s_project_02 ).

  zcl_appl_cntl=>save_all( ).
  o_appl_message->show_messages( 'M' ).
