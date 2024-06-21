*&---------------------------------------------------------------------*
*& Report ZDPG_TEST_CLASS_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdpg_test_class_read.
DATA  rs_class TYPE zzdpg_s_class  .
DATA clskey TYPE  seoclskey.

START-OF-SELECTION.

*  BREAK-POINT.

  clskey-clsname = 'CL_GUI_ALV_GRID'.

  CALL FUNCTION 'SEO_CLASS_TYPEINFO_GET'
    EXPORTING
      clskey            = clskey
      version           = seoc_version_active
      state             = '1'
      with_descriptions = abap_true
*     resolve_eventhandler_typeinfo =
*     with_master_language          =
*     with_enhancements =
*     read_active_enha  =
*     enha_action       =
*     ignore_switches   = 'X'
    IMPORTING
      class             = rs_class-s_class
      attributes        = rs_class-include_cl_intf-t_attributes
      methods           = rs_class-include_cl_intf-t_methods
      events            = rs_class-include_cl_intf-t_events
      types             = rs_class-include_cl_intf-t_types
      parameters        = rs_class-include_cl_intf-t_parameters
      exceps            = rs_class-include_cl_intf-t_exceptions
      implementings     = rs_class-include_cl-t_implementings
      inheritance       = rs_class-include_cl-s_inheritance
      redefinitions     = rs_class-include_cl-t_redefinitions
      impl_details      = rs_class-include_cl-t_impl_details
      friendships       = rs_class-include_cl-t_friendships
      typepusages       = rs_class-include_cl_intf-t_typepusages
      clsdeferrds       = rs_class-include_cl_intf-t_clsdeferrds
      intdeferrds       = rs_class-include_cl_intf-t_intdeferreds
*     explore_inheritance           =
*     explore_implementings         =
      aliases           = rs_class-include_cl_intf-t_aliases
*     enhancement_methods           =
*     enhancement_attributes        =
*     enhancement_events            =
*     enhancement_implementings     =
*     enhancement_types =
    EXCEPTIONS
      not_existing      = 1
      is_interface      = 2
      model_only        = 3
      OTHERS            = 4.
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  BREAK-POINT.

  DATA mtdkey TYPE  seocpdkey.
  DATA source_expanded TYPE  seop_source_string.
  DATA source TYPE  seop_source.
  data incname TYPE program .
  data resolved_method_key  type seocpdkey  .

  LOOP AT rs_class-include_cl_intf-t_methods ASSIGNING FIELD-SYMBOL(<method>).
    mtdkey-clsname = <method>-clsname.
    mtdkey-cpdname = <method>-cmpname.

    CALL FUNCTION 'SEO_METHOD_GET_SOURCE'
      EXPORTING
        mtdkey          = mtdkey
        state           = 'A'
*       WITH_ENHANCEMENTS                   = SEOX_FALSE
      IMPORTING
        source          = source
        source_expanded = source_expanded
       INCNAME         = incname
       RESOLVED_METHOD_KEY                 = resolved_method_key
*     EXCEPTIONS
*       _INTERNAL_METHOD_NOT_EXISTING       = 1
*       _INTERNAL_CLASS_NOT_EXISTING        = 2
*       VERSION_NOT_EXISTING                = 3
*       INACTIVE_NEW    = 4
*       INACTIVE_DELETED                    = 5
*       OTHERS          = 6
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


        APPEND INITIAL LINE TO rs_class-include_cl-t_method_sources ASSIGNING FIELD-SYMBOL(<method_sources>).
        <method_sources>-cpdname = <method>-cmpname.
        <method_sources>-redefine = <method>-redefin.
        <method_sources>-source = source_expanded.


  ENDLOOP.
  BREAK-POINT.





  BREAK-POINT.
