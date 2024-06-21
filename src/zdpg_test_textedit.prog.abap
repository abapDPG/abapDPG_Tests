*&---------------------------------------------------------------------*
*& Report ZDPG_TEST_TEXTEDIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpg_test_textedit.

TYPE-POOLS: abap.
TYPES: ty_t_text     TYPE TABLE OF zdpg_c_ltxt
                     WITH DEFAULT KEY.
TYPES: BEGIN OF ty_s_outtab.
TYPES: language TYPE spras.
TYPES: text     TYPE ty_t_text.
TYPES: END OF ty_s_outtab.
TYPES: ty_t_outtab    TYPE STANDARD TABLE OF ty_s_outtab
                      WITH DEFAULT KEY.

DATA: gt_outtab TYPE ty_t_outtab,
      gs_outtab TYPE ty_s_outtab.
DATA: gd_language     TYPE spras.
DATA:
  t_sourcecode            TYPE TABLE OF text1000,
  o_editor                TYPE REF TO cl_gui_textedit,
  o_editor_info_container TYPE REF TO cl_gui_custom_container.

INITIALIZATION.

  INCLUDE zdpg_test_textedit_pbo_0100f01.
  INCLUDE zdpg_test_textedit_pbo_0100o01.
  INCLUDE zdpg_test_textedit_pai_0100i01.

START-OF-SELECTION.
  CALL SCREEN 0100.
