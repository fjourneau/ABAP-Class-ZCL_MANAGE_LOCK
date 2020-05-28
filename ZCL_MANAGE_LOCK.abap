class ZCL_MANAGE_LOCK definition                                                                     
  public                                                                                             
  final                                                                                              
  create public .                                                                                    
                                                                                                     
public section.                                                                                      
                                                                                                     
  class-methods CHECK_LOCK_OBJECT                                                                    
    importing                                                                                        
      !IW_LOCK_ENTRY type EQEGRANAME                                                                 
      !IW_KEY type EQEGRAARG                                                                         
      !IW_USER type SY-UNAME default ''                                                              
      !IW_MAX_WAIT_TIME type I default 0                                                             
    returning                                                                                        
      value(RW_SUBRC) type SUBRC .                                                                   
  class-methods CHECK_LOCK_TRANSFER_REQUEST                                                          
    importing                                                                                        
      !IW_LGNUM type LGNUM                                                                           
      !IW_TBNUM type TBNUM                                                                           
      !IW_USER type SY-UNAME default ''                                                              
      !IW_MAX_WAIT_TIME type I default 0                                                             
    returning                                                                                        
      value(RW_SUBRC) type SUBRC .                                                                   
protected section.                                                                                   
private section.                                                                                     
                                                                                                     
  class-methods READ_ENQUEUE                                                                         
    importing                                                                                        
      !IW_LOCK_ENTRY type EQEGRANAME                                                                 
      !IW_KEY type EQEGRAARG                                                                         
      !IW_USER type SY-UNAME default ''                                                              
    returning                                                                                        
      value(RW_SUBRC) type SUBRC .                                                                   
ENDCLASS.                                                                                            
                                                                                                     
                                                                                                     
                                                                                                     
CLASS ZCL_MANAGE_LOCK IMPLEMENTATION.                                                                
                                                                                                     
                                                                                                     
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MANAGE_LOCK=>CHECK_LOCK_OBJECT                                          
* +-------------------------------------------------------------------------------------------------+
* | [--->] IW_LOCK_ENTRY                  TYPE        EQEGRANAME                                     
* | [--->] IW_KEY                         TYPE        EQEGRAARG                                      
* | [--->] IW_USER                        TYPE        SY-UNAME (default ='')                         
* | [--->] IW_MAX_WAIT_TIME               TYPE        I (default =0)                                 
* | [<-()] RW_SUBRC                       TYPE        SUBRC                                          
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_lock_object.                                                                          
                                                                                                     
    rw_subrc = read_enqueue( iw_lock_entry = iw_lock_entry                                           
                             iw_key        = iw_key                                                  
                             iw_user       = iw_user ).                                              
                                                                                                     
    IF rw_subrc IS INITIAL.                                                                          
      RETURN.                                                                                        
    ENDIF.                                                                                           
                                                                                                     
    IF iw_max_wait_time IS NOT INITIAL.                                                              
                                                                                                     
      DO iw_max_wait_time TIMES.                                                                     
                                                                                                     
        WAIT UP TO 1 SECONDS.                                                                        
                                                                                                     
        rw_subrc = read_enqueue( iw_lock_entry = iw_lock_entry                                       
                                 iw_key        = iw_key                                              
                                 iw_user       = iw_user ).                                          
                                                                                                     
        IF rw_subrc IS INITIAL.                                                                      
          RETURN.                                                                                    
        ENDIF.                                                                                       
                                                                                                     
      ENDDO.                                                                                         
                                                                                                     
    ENDIF.                                                                                           
                                                                                                     
                                                                                                     
  ENDMETHOD.                                                                                         
                                                                                                     
                                                                                                     
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MANAGE_LOCK=>CHECK_LOCK_TRANSFER_REQUEST                                
* +-------------------------------------------------------------------------------------------------+
* | [--->] IW_LGNUM                       TYPE        LGNUM                                          
* | [--->] IW_TBNUM                       TYPE        TBNUM                                          
* | [--->] IW_USER                        TYPE        SY-UNAME (default ='')                         
* | [--->] IW_MAX_WAIT_TIME               TYPE        I (default =0)                                 
* | [<-()] RW_SUBRC                       TYPE        SUBRC                                          
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_lock_transfer_request.                                                                
                                                                                                     
    DATA : lw_key TYPE eqegraarg.                                                                    
                                                                                                     
    CONCATENATE sy-mandt iw_lgnum iw_tbnum INTO lw_key.                                              
                                                                                                     
    rw_subrc = check_lock_object( iw_lock_entry    = 'LTBK'                                          
                                  iw_key           = lw_key                                          
                                  iw_user          = iw_user                                         
                                  iw_max_wait_time = iw_max_wait_time ).                             
                                                                                                     
  ENDMETHOD.                                                                                         
                                                                                                     
                                                                                                     
* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_MANAGE_LOCK=>READ_ENQUEUE                                              
* +-------------------------------------------------------------------------------------------------+
* | [--->] IW_LOCK_ENTRY                  TYPE        EQEGRANAME                                     
* | [--->] IW_KEY                         TYPE        EQEGRAARG                                      
* | [--->] IW_USER                        TYPE        SY-UNAME (default ='')                         
* | [<-()] RW_SUBRC                       TYPE        SUBRC                                          
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_enqueue.                                                                               
                                                                                                     
    DATA : li_enq    TYPE  STANDARD TABLE OF seqg3,                                                  
           lw_number TYPE sy-tabix.                                                                  
                                                                                                     
    CALL FUNCTION 'ENQUEUE_READ'                                                                     
      EXPORTING                                                                                      
        gclient               = sy-mandt                                                             
        gname                 = iw_lock_entry                                                        
        garg                  = iw_key                                                               
        guname                = iw_user                                                              
        local                 = ' '                                                                  
        fast                  = ' '                                                                  
        gargnowc              = ' '                                                                  
      IMPORTING                                                                                      
        number                = lw_number                                                            
*       subrc                 = lw_subrc                                                             
      TABLES                                                                                         
        enq                   = li_enq                                                               
      EXCEPTIONS                                                                                     
        communication_failure = 1                                                                    
        system_failure        = 2                                                                    
        OTHERS                = 3.                                                                   
                                                                                                     
    IF sy-subrc <> 0.                                                                                
      rw_subrc = sy-subrc.                                                                           
    ELSE.                                                                                            
      IF lw_number IS NOT INITIAL.                                                                   
        rw_subrc = 8.                                                                                
      ENDIF.                                                                                         
                                                                                                     
    ENDIF.                                                                                           
                                                                                                     
  ENDMETHOD.                                                                                         
ENDCLASS.                                                                                            

