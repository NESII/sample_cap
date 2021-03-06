program sampleApp

  !-----------------------------------------------------------------------------
  ! Generic ESMF Main
  !-----------------------------------------------------------------------------

  use ESMF

  use sample_driver_mod, only: &
    driver_SS => SetServices

  implicit none
  
  integer                       :: rc, userRc
  type(ESMF_Config)             :: config
  type(ESMF_GridComp)           :: drvComp
  character(ESMF_MAXSTR)        :: drvName

  ! -> INITIALIZE ESMF
  call ESMF_Initialize(defaultCalkind=ESMF_CALKIND_GREGORIAN, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

#ifdef DEBUG
  ! -> FLUSH LOGS IMMEDIATELY
  call ESMF_LogSet(flush=.true., rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
#endif

  call ESMF_LogWrite("Sample App STARTING", ESMF_LOGMSG_INFO, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
   
  !-----------------------------------------------------------------------------
 
  ! -> CREATE THE CONFIG
  config = ESMF_ConfigCreate(rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  ! -> LOAD THE CONFIG
  call ESMF_ConfigLoadFile(config, "sample.rc", rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  ! -> SET THE DRIVER NAME
  call ESMF_ConfigGetAttribute(config, drvName, &
    label="driver_name:", default="DRIVER", rc=rc) 
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT) 

  ! -> CREATE THE DRIVER
  drvComp = ESMF_GridCompCreate(name=trim(drvName), rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  ! -> SET THE CONFIG
  call ESMF_GridCompSet(drvComp, config=config, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
    
  ! -> SET DRIVER SERVICES
  call ESMF_GridCompSetServices(drvComp, driver_SS, userRc=userRc, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
  if (ESMF_LogFoundError(rcToCheck=userRc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  ! -> INITIALIZE THE DRIVER
  call ESMF_GridCompInitialize(drvComp, userRc=userRc, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
  if (ESMF_LogFoundError(rcToCheck=userRc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
      
  ! -> RUN THE DRIVER
  call ESMF_GridCompRun(drvComp, userRc=userRc, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
  if (ESMF_LogFoundError(rcToCheck=userRc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
  
  ! -> FINALIZE THE DRIVER
  call ESMF_GridCompFinalize(drvComp, userRc=userRc, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)
  if (ESMF_LogFoundError(rcToCheck=userRc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  !-----------------------------------------------------------------------------
  
  call ESMF_LogWrite("Sample App FINISHED", ESMF_LOGMSG_INFO, rc=rc)
  if (ESMF_LogFoundError(rcToCheck=rc, msg=ESMF_LOGERR_PASSTHRU, &
    line=__LINE__, file=__FILE__)) &
    call ESMF_Finalize(endflag=ESMF_END_ABORT)

  ! FINALIZE ESMF
  call ESMF_Finalize()
  
end program  
