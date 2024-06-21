*&---------------------------------------------------------------------*
*& Include          ZDPG_TEST_TEXTEDIT_PBO_0100F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_TEXT_EDITOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_text_editor .

  CLEAR: gs_outtab.

  CALL METHOD o_editor->get_text_as_stream
    EXPORTING
      only_when_modified     = cl_gui_textedit=>true
    IMPORTING
      text                   = gs_outtab-text
*     is_modified            =
    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  DATA  lt_textlines    TYPE bcwbn_textlines.
  o_editor->get_text_as_r3table( EXPORTING  only_when_modified = 1
                                 IMPORTING  table              = lt_textlines
                                            is_modified        = DATA(modified)
                                 EXCEPTIONS OTHERS             = 1 ).


  MODIFY gt_outtab FROM gs_outtab
    TRANSPORTING text
    WHERE ( language = gd_language ).


ENDFORM.                    " GET_TEXT_EDITOR
*&---------------------------------------------------------------------*
*&      Form  SET_TEXT_EDITOR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_text_editor .


  CLEAR: gs_outtab.
  READ TABLE gt_outtab INTO gs_outtab
       WITH KEY language = gd_language.


  CALL METHOD o_editor->set_text_as_stream
    EXPORTING
      text            = gs_outtab-text
    EXCEPTIONS
      error_dp        = 1
      error_dp_create = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " SET_TEXT_EDITOR
