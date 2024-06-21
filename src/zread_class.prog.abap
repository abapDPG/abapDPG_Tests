*&---------------------------------------------------------------------*
*& Report ZREAD_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREAD_CLASS.

START-OF-SELECTION.

DATA(lo_type_desc) = cl_abap_typedescr=>describe_by_name( 'CL_GUI_ALV_GRID' ).

BREAK-POINT.
