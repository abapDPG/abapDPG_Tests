*----------------------------------------------------------------------*
***INCLUDE ZDPG_TEST_TEXTEDIT_PBO_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.
  IF NOT o_editor_info_container IS BOUND.
    CREATE OBJECT o_editor_info_container
      EXPORTING
        container_name              = 'EDITOR_CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc NE 0.
*      add your handling
    ENDIF.
  ENDIF.

  IF o_editor IS NOT  BOUND.
    CREATE OBJECT o_editor
      EXPORTING
        parent = o_editor_info_container.

    o_editor->set_font_fixed(
      EXPORTING
        mode                   = 1             " true: set fixed font, false: wordwrap mode determines type
      EXCEPTIONS
        error_cntl_call_method = 1                " error in automation call (available after flush only)
        invalid_parameter      = 2                " invalid parameter
        OTHERS                 = 3
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    o_editor->set_wordwrap_behavior(
      wordwrap_mode              = 2 "off
      wordwrap_position          = 128
      wordwrap_to_linebreak_mode = 0 ).
  ENDIF.
ENDMODULE.
