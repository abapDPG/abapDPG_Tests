*&---------------------------------------------------------------------*
*& Report ZCREATE_CLASS_DB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcreate_class_db.

DATA:
  o_category_db TYPE REF TO zif_appl_object_db,
  o_project_db  TYPE REF TO zif_appl_object_db,
  o_package_db  TYPE REF TO zif_appl_object_db.

START-OF-SELECTION.

  BREAK-POINT.
  o_project_db  ?= zcl_appl_cntl=>get_single_obj( 'DPG_PROJECT_DB' ).
  BREAK-POINT.
  o_package_db ?= zcl_appl_cntl=>get_single_obj( 'DPG_PACKAGE_DB' ).
  BREAK-POINT.
  o_category_db  ?= zcl_appl_cntl=>get_single_obj( 'DPG_CATEGORY_DB' ).
  BREAK-POINT.
