*&---------------------------------------------------------------------*
*& Report ZCREATE_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcreate_class.

* TODO
" TODO



DATA: gv_count TYPE char04.

DATA: gs_class TYPE vseoclass.

DATA: gv_package TYPE devclass VALUE '$TMP',
      gv_corrnr  TYPE  trkorr.

DATA: gt_attributes     TYPE seo_attributes,
      gs_inheritance    TYPE vseoextend, " (Vererbung)
      gt_implementings  TYPE seo_implementings, " IMPLEMENTING (Interfaces)
      gt_types          TYPE seo_types,
      " Methods
      gt_methods        TYPE seo_methods,
      gt_method_sources TYPE seo_method_source_table,

      " Parameters
      gt_parameters     TYPE  seo_parameters,
      " Exceptions
      gt_exceptions     TYPE seo_exceptions,

      " Redefinitions
      gt_redefinitions  TYPE seo_redefinitions,

      " Aliases
      gt_aliases        TYPE seoo_aliases_r.

" locals
DATA:
  gt_locals_def TYPE  rswsourcet, " Sourcetext klassenlokaler Klassen (Definitionsteil)
  gt_locals_imp TYPE  rswsourcet, " Sourcetext klassenlokaler Klassen (Implementierungsteil)
  gs_locals_mac TYPE  rswsourcet. " ABAP-Source

" Descriptions
DATA: gt_class_descriptions        TYPE STANDARD TABLE OF seoclasstx, " Short description class/interface
      gt_component_descriptions    TYPE STANDARD TABLE OF seocompotx, " Short description class/interface component
      gt_subcomponent_descriptions TYPE STANDARD TABLE OF seosubcotx. " Class/interface subcomponent short description

SELECTION-SCREEN BEGIN OF BLOCK bl01.
  PARAMETERS: pa_cname TYPE seoclsname DEFAULT 'ZCL_TEST'.
SELECTION-SCREEN END OF BLOCK bl01.

START-OF-SELECTION.
*  BREAK-POINT.
  SELECT COUNT(*) FROM seoclass WHERE clsname LIKE 'ZCL_TEST%'.

  IF sy-dbcnt GT 0.
    gv_count = sy-dbcnt.
    SHIFT gv_count RIGHT DELETING TRAILING space.
    OVERLAY gv_count WITH '0000'.
    gs_class-clsname = pa_cname && '_' && gv_count.
  ENDIF.

  " CLASS DEFINITION
  PERFORM class_definition CHANGING gs_class.

  " INHERITANCE (Vererbung)
  PERFORM class_inheritance USING    gs_class
                                     pa_cname
                            CHANGING gs_inheritance.

  " IMPLEMENTING (Interfaces)
  PERFORM class_implementing USING    gs_class
                             CHANGING gt_implementings.

  " ATTRIBUTES
  PERFORM class_attributes USING gs_class
                           CHANGING gt_attributes.

  " TYPES
  PERFORM class_types USING    gs_class
                      CHANGING gt_types.

  " METHODS
  PERFORM class_methods USING     gs_class
                        CHANGING  gt_methods
                                 gt_parameters
                                 gt_method_sources
                                 gt_exceptions .

  " Implementings sourcecode (from Interface)
  PERFORM class_implementings_src USING   gs_class
                                          gt_implementings
                                 CHANGING gt_method_sources.

  " ALIASES
  PERFORM class_aliases USING     gs_class
                                  gs_inheritance
                                  gt_implementings
                        CHANGING  gt_aliases.


*----------------------------------------------------------------------*
  CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
    EXPORTING
      corrnr                     = gv_corrnr
      devclass                   = gv_package
      version                    = seoc_version_active
      genflag                    = seox_true
      authority_check            = seox_true
      overwrite                  = seox_false
      suppress_method_generation = seox_false
*     SUPPRESS_REFACTORING_SUPPORT         = SEOX_TRUE
      method_sources             = gt_method_sources
      locals_def                 = gt_locals_def
      locals_imp                 = gt_locals_imp
      locals_mac                 = gs_locals_mac
*     SUPPRESS_INDEX_UPDATE      = SEOX_FALSE
*     SUPPRESS_CORR              = SEOX_FALSE
*     SUPPRESS_DIALOG            =
*     LIFECYCLE_MANAGER          =
*     LOCALS_AU                  =
*     LOCK_HANDLE                =
*     SUPPRESS_UNLOCK            = SEOX_FALSE
*     SUPPRESS_COMMIT            = SEOX_FALSE
*     GENERATE_METHOD_IMPLS_WO_FRAME       = SEOX_FALSE
* IMPORTING
*     KORRNR                     =
    TABLES
      class_descriptions         = gt_class_descriptions
      component_descriptions     = gt_component_descriptions
      subcomponent_descriptions  = gt_subcomponent_descriptions
    CHANGING
      class                      = gs_class
      inheritance                = gs_inheritance
*     REDEFINITIONS              =
      implementings              = gt_implementings
*     IMPL_DETAILS               =
      attributes                 = gt_attributes
      methods                    = gt_methods
*     EVENTS                     =
      types                      = gt_types
*     type_source                = lt_type_sources
      parameters                 = gt_parameters
      exceps                     = gt_exceptions
      aliases                    = gt_aliases
*     TYPEPUSAGES                =
*     CLSDEFERRDS                =
*     INTDEFERRDS                =
*     FRIENDSHIPS                =
    EXCEPTIONS
      existing                   = 1
      is_interface               = 2
      db_error                   = 3
      component_error            = 4
      no_access                  = 5
      other                      = 6
      OTHERS                     = 7.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE cx_ble_internal_error
      EXPORTING
        textid = cx_ble_internal_error=>class_creation_error
        param1 = CONV #( gs_class-clsname ).
  ENDIF.




*&---------------------------------------------------------------------*
*& Form class_definition
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_CLASS
*&---------------------------------------------------------------------*
FORM class_definition  CHANGING cs_class TYPE vseoclass.
* CLASS DEFINITION :
*  cs_class-clsname = clsname.

  " 0   Only modeled
  " 1   Implemented
  " 2 modeled and implemented
  cs_class-state = seoc_state_implemented.

  " 0  Private
  " 1   Protected
  " 2   Public
  cs_class-exposure = seoc_exposure_public.

  cs_class-langu = 'EN'.
  cs_class-descript = 'Generated Testclass'.                "#EC NOTEXT
  cs_class-clsccincl = 'X'.
  cs_class-unicode = 'X'.
  cs_class-author = sy-uname.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_inheritance
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      <-- LS_INHERITANCE
*&---------------------------------------------------------------------*
FORM class_inheritance  USING    is_class TYPE vseoclass
                                 iv_clsname TYPE seoclsname
                        CHANGING cs_inheritance TYPE vseoextend.
  cs_inheritance-clsname = is_class-clsname.
  cs_inheritance-refclsname = iv_clsname. " erbt von


  cs_inheritance-state = seoc_state_implemented.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_IMPLEMENTING
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      <-- CT_IMPLEMENTING
*&---------------------------------------------------------------------*
FORM class_IMPLEMENTING  USING    is_class TYPE vseoclass
                         CHANGING ct_implementing TYPE seo_implementings.

  DATA: ls_implementing TYPE vseoimplem.

  ls_implementing-clsname = is_class-clsname.
  ls_implementing-refclsname = 'ZIF_TEST'.
  ls_implementing-state = seoc_state_implemented.
  APPEND ls_implementing TO ct_implementing.

  CLEAR: ls_implementing.

  ls_implementing-clsname = is_class-clsname.
  ls_implementing-refclsname = 'ZIF_TESTER'.
  ls_implementing-state = seoc_state_implemented.
  APPEND ls_implementing TO ct_implementing.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_attributes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      <-- LT_ATTRIBUTES
*&---------------------------------------------------------------------*
FORM class_attributes  USING    is_class TYPE vseoclass
                       CHANGING ct_attributes TYPE seo_attributes.

  DATA ls_attributes TYPE vseoattrib.

  ls_attributes-clsname = is_class-clsname.
  ls_attributes-cmpname = 'ATTRIB_1'.
  ls_attributes-descript = 'private attribute of type int4'. "#EC NOTEXT
  ls_attributes-state =  seoc_state_implemented.
  ls_attributes-exposure = seoc_exposure_private.
  ls_attributes-attdecltyp = seoo_attdecltyp_data.
  ls_attributes-typtype = seoo_typtype_type.
  ls_attributes-type = 'INT4'.
  ls_attributes-attvalue = '10'.
  APPEND ls_attributes TO ct_attributes.



  CLEAR ls_attributes.
  ls_attributes-clsname = is_class-clsname.
  ls_attributes-cmpname = 'ATTRIB_2'.
  ls_attributes-descript = 'private attribute of type CL_OO_CLASS'. "#EC NOTEXT
  ls_attributes-state =  seoc_state_implemented.
  ls_attributes-exposure = seoc_exposure_private.
  ls_attributes-attdecltyp = seoo_attdecltyp_data.
  ls_attributes-typtype = seoo_typtype_ref_to.
  ls_attributes-type = 'CL_OO_CLASS'.
  APPEND ls_attributes TO ct_attributes.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_types
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      --> LT_TYPE_SOURCES
*&      <-- LT_TYPES
*&---------------------------------------------------------------------*
FORM class_types  USING    is_class TYPE vseoclass
                  CHANGING ct_types TYPE seo_types.
  DATA: src      TYPE seo_section_source,
        ls_types TYPE vseotype.

  APPEND ' begin of global_type , '  TO src.
  APPEND '        cmp1 type string  , '  TO src.
  APPEND '        cmp2 type i       , '  TO src.
  APPEND '        cmp3 type flag    , '  TO src.
  APPEND '        cmp4 type string  , '  TO src.
  APPEND '     end of global_type   . '  TO src.

  ls_types-clsname = is_class-clsname.
  ls_types-cmpname = 'LOCAL_TYPE'  .
  ls_types-descript = 'local type'.                         "#EC NOTEXT
  ls_types-state =  seoc_state_implemented.
  ls_types-exposure = seoc_exposure_public.
  ls_types-typtype = seoo_typtype_others.
  ls_types-typesrc = cl_oo_section_source=>convert_table_to_string( p_source = src ).
  APPEND ls_types TO ct_types.

  CLEAR ls_types.

  ls_types-clsname = is_class-clsname.
  ls_types-cmpname = 'CARRID_TYPE'  .
  ls_types-descript = 'carrid type'.                        "#EC NOTEXT
  ls_types-state =  seoc_state_implemented.
  ls_types-exposure = seoc_exposure_public.
  ls_types-typtype = seoo_typtype_type.
  ls_types-type = 'S_CARR_ID'.
  APPEND ls_types TO ct_types.

  CLEAR ls_types.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_methods
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      <-- LT_METHODS
*&---------------------------------------------------------------------*
FORM class_methods  USING    is_class          TYPE vseoclass
                    CHANGING ct_methods        TYPE seo_methods
                             ct_parameters     TYPE seo_parameters
                             ct_method_sources TYPE seo_method_source_table
                             ct_exceptions     TYPE seo_exceptions .

  DATA: ls_method        TYPE vseomethod,
        ls_method_source TYPE seo_method_source,
        ls_parameter     TYPE vseoparam,
        ls_exception     TYPE vseoexcep.

*----------------------------------------------------------------------*
  ls_method-clsname = is_class-clsname.
  ls_method-cmpname = 'GET_ATTRIB_1'.
  ls_method-descript = 'public method with returning parameter'. "#EC NOTEXT
  ls_method-state =  seoc_state_implemented.
  ls_method-exposure = seoc_exposure_public.
  ls_method-mtddecltyp = seoo_mtddecltyp_method.
  APPEND ls_method TO ct_methods.

  " Parameters for Method
  ls_parameter-clsname = is_class-clsname.
  ls_parameter-cmpname = ls_method-cmpname.
  ls_parameter-sconame = 'RESULT'.
  ls_parameter-cmptype = seoo_cmptype_method.
  ls_parameter-pardecltyp = seos_pardecltyp_returning.
  ls_parameter-typtype = seoo_typtype_type.
  ls_parameter-type = 'INT4'.
  APPEND ls_parameter TO ct_parameters.

  " Sourcecode for Method
  ls_method_source-cpdname = ls_method-cmpname.
  ls_method_source-redefine = abap_false.
  APPEND ' result = attrib_1.' TO ls_method_source-source.
  APPEND ls_method_source TO ct_method_sources.

  " Exceptions for Method
  ls_exception-clsname  = is_class-clsname.
  ls_exception-cmpname  = ls_method-cmpname.
  ls_exception-sconame  = 'EXCEP_1'.
  ls_exception-descript = 'error occured'.                  "#EC NOTEXT
  APPEND ls_exception TO ct_exceptions.
  CLEAR ls_exception.
  ls_exception-clsname  = is_class-clsname.
  ls_exception-cmpname  = ls_method-cmpname.
  ls_exception-sconame  = 'EXCEP_2'.
  ls_exception-descript = 'error occured'.                  "#EC NOTEXT
  APPEND ls_exception TO ct_exceptions.
  CLEAR ls_exception.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_methods_coding
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      --> LT_METHODS
*&      <-- LT_METHOD_SOURCES
*&---------------------------------------------------------------------*
FORM class_methods_coding  USING    is_class TYPE vseoclass
                                    it_methods TYPE seo_methods
                           CHANGING ct_method_sources TYPE seo_method_source_table.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_parameters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      --> LT_METHODS
*&      <-- LT_PARAMETERS
*&---------------------------------------------------------------------*
FORM class_parameters  USING    is_class TYPE vseoclass
                                    it_methods TYPE seo_methods
                       CHANGING ct_parameters TYPE seo_parameters.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_exceptions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      --> LT_METHODS
*&      <-- LT_EXCEPTIONS
*&---------------------------------------------------------------------*
FORM class_exceptions  USING   is_class TYPE vseoclass
                               it_methods TYPE seo_methods
                       CHANGING ct_exceptions TYPE seo_exceptions.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_implementings_src
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_CLASS
*&      --> LT_IMPLEMENTINGS
*&      <-- LT_METHOD_SOURCES
*&---------------------------------------------------------------------*
FORM class_implementings_src  USING   is_class TYPE vseoclass
                                      it_implementing TYPE seo_implementings
                              CHANGING ct_method_sources TYPE seo_method_source_table.

  DATA: ls_method_source TYPE seo_method_source.

*  BREAK-POINT.
  LOOP AT it_implementing ASSIGNING FIELD-SYMBOL(<implementing>).
    DATA(lo_type_desc) = cl_abap_typedescr=>describe_by_name( <implementing>-refclsname ).
    CASE lo_type_desc->kind.
      WHEN cl_abap_typedescr=>kind_intf.
        DATA(lo_if_desc) = CAST cl_abap_intfdescr( lo_type_desc ).
        LOOP AT lo_if_desc->methods ASSIGNING FIELD-SYMBOL(<inf>).
          ls_method_source-cpdname = lo_if_desc->absolute_name+11(30) && '~' && <inf>-name.
          APPEND '*code for interface methode' TO ls_method_source-source.
          APPEND  ls_method_source TO ct_method_sources.
          CLEAR ls_method_source.
        ENDLOOP.
    ENDCASE.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form class_aliases
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_CLASS
*&      --> GS_INHERITANCE
*&      --> GT_IMPLEMENTINGS
*&      <-- GT_ALIASES
*&---------------------------------------------------------------------*
FORM class_aliases  USING    is_class TYPE vseoclass
                             is_inheritance TYPE vseoextend
                             it_implementing TYPE seo_implementings
                    CHANGING ct_aliases TYPE seoo_aliases_r.

ENDFORM.
