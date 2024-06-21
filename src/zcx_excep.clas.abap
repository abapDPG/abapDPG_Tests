CLASS zcx_excep DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF error_001,
        msgid TYPE symsgid VALUE 'ZTEST',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'PERSA',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF error_001 .
    DATA msgv1 TYPE symsgv READ-ONLY .
    DATA msgv2 TYPE symsgv READ-ONLY .
    DATA msgv3 TYPE symsgv READ-ONLY .
    DATA msgv4 TYPE symsgv READ-ONLY .
    CONSTANTS c_generic_error_msg TYPE string VALUE `An error occured (ZCX_EXCEP)` ##NO_TEXT.
    DATA persa TYPE persa .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !msgv1    TYPE symsgv OPTIONAL
        !msgv2    TYPE symsgv OPTIONAL
        !msgv3    TYPE symsgv OPTIONAL
        !msgv4    TYPE symsgv OPTIONAL .
    CLASS-METHODS raise_t100
      IMPORTING
        VALUE(iv_msgid) TYPE symsgid DEFAULT sy-msgid
        VALUE(iv_msgno) TYPE symsgno DEFAULT sy-msgno
        VALUE(iv_msgv1) TYPE symsgv DEFAULT sy-msgv1
        VALUE(iv_msgv2) TYPE symsgv DEFAULT sy-msgv2
        VALUE(iv_msgv3) TYPE symsgv DEFAULT sy-msgv3
        VALUE(iv_msgv4) TYPE symsgv DEFAULT sy-msgv4
        !ix_previous    TYPE REF TO cx_root OPTIONAL
      RAISING
        zcx_excep .
    CLASS-METHODS raise
      IMPORTING
        !iv_text     TYPE clike
        !ix_previous TYPE REF TO cx_root OPTIONAL
      RAISING
        zcx_excep .
  PROTECTED SECTION.
  PRIVATE SECTION.

    ALIASES default_textid
      FOR if_t100_message~default_textid .
    ALIASES t100key
      FOR if_t100_message~t100key .

    CLASS-METHODS split_text_to_symsg
      IMPORTING
        !iv_text      TYPE string
      RETURNING
        VALUE(rs_msg) TYPE symsg .

ENDCLASS.



CLASS zcx_excep IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    me->msgv1 = msgv1.
    me->msgv2 = msgv2.
    me->msgv3 = msgv3.
    me->msgv4 = msgv4.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.


  METHOD raise.

    DATA lv_text TYPE string.

    IF iv_text IS INITIAL.
      lv_text = c_generic_error_msg.
    ELSE.
      lv_text = iv_text.
    ENDIF.

    split_text_to_symsg( lv_text ).

    raise_t100(
      ix_previous = ix_previous ).

  ENDMETHOD.


  METHOD raise_t100.

    DATA: ls_t100_key TYPE scx_t100key.

    ls_t100_key-msgid = iv_msgid.
    ls_t100_key-msgno = iv_msgno.
    ls_t100_key-attr1 = 'MSGV1'.
    ls_t100_key-attr2 = 'MSGV2'.
    ls_t100_key-attr3 = 'MSGV3'.
    ls_t100_key-attr4 = 'MSGV4'.

    IF iv_msgid IS INITIAL.
      CLEAR ls_t100_key.
    ENDIF.

    RAISE EXCEPTION TYPE zcx_excep
      EXPORTING
        textid   = ls_t100_key
        msgv1    = iv_msgv1
        msgv2    = iv_msgv2
        msgv3    = iv_msgv3
        msgv4    = iv_msgv4
        previous = ix_previous.
  ENDMETHOD.


  METHOD split_text_to_symsg.
    CONSTANTS:
      lc_length_of_msgv           TYPE i VALUE 50,
      lc_offset_of_last_character TYPE i VALUE 49.

    DATA:
      lv_text    TYPE c LENGTH 200,
      lv_rest    TYPE c LENGTH 200,
      ls_msg     TYPE symsg,
      lv_msg_var TYPE c LENGTH lc_length_of_msgv,
      lv_index   TYPE sy-index.

    lv_text = iv_text.

    DO 4 TIMES.

      lv_index = sy-index.

      CALL FUNCTION 'TEXT_SPLIT'
        EXPORTING
          length = lc_length_of_msgv
          text   = lv_text
        IMPORTING
          line   = lv_msg_var
          rest   = lv_rest.

      IF lv_msg_var+lc_offset_of_last_character(1) = space OR
         lv_text+lc_length_of_msgv(1) = space.
        " keep the space at the beginning of the rest
        " because otherwise it's lost
        lv_rest = | { lv_rest }|.
      ENDIF.

      lv_text = lv_rest.

      CASE lv_index.
        WHEN 1.
          ls_msg-msgv1 = lv_msg_var.
        WHEN 2.
          ls_msg-msgv2 = lv_msg_var.
        WHEN 3.
          ls_msg-msgv3 = lv_msg_var.
        WHEN 4.
          ls_msg-msgv4 = lv_msg_var.
      ENDCASE.

    ENDDO.

    " Set syst using generic error message
    MESSAGE e001(00) WITH ls_msg-msgv1 ls_msg-msgv2 ls_msg-msgv3 ls_msg-msgv4 INTO sy-lisel.

    rs_msg = ls_msg.
  ENDMETHOD.
ENDCLASS.
