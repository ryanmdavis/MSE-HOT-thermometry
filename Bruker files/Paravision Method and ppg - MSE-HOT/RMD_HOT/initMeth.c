/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/initMeth.c,v $
 *
 * Copyright (c) 2001 - 2004
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 * $Id: initMeth.c,v 1.16.2.3 2009/09/10 16:25:22 mawi Exp $
 *
 ****************************************************************/

static const char resid[] = "$Id: initMeth.c,v 1.16.2.3 2009/09/10 16:25:22 mawi Exp $ (C) 2001-2004 Bruker BioSpin MRI GmbH";

#define DEBUG		0
#define DB_MODULE	1
#define DB_LINE_NR	1


/****************************************************************/
/****************************************************************/
/*		I N T E R F A C E   S E C T I O N		*/
/****************************************************************/
/****************************************************************/

/****************************************************************/
/*		I N C L U D E   F I L E S			*/
/****************************************************************/

#include "method.h"

/****************************************************************/
/*	I M P L E M E N T A T I O N   S E C T I O N		*/
/****************************************************************/


/****************************************************************/
/*		G L O B A L   F U N C T I O N S			*/
/****************************************************************/


/*:=MPB=:=======================================================*
 *
 * Global Function: initMeth
 *
 * Description: This procedure is implicitly called when this
 *	method is selected.
 *
 * Error History: 
 *
 * Interface:							*/

void initMeth()
/*:=MPE=:=======================================================*/
{


  DB_MSG(( "Entering singlepulse:initMeth()" ));

  int dimRange[2] = { 2,3 };
  int lowMat[3]   = { 32, 32, 8 };
  int upMat[3]    = { 2048, 2048, 256 };


  /* which version of toolboxes should be active */
  PTB_VersionRequirement( Yes,20090101,"");
  
 
  
  /*  Initialize PVM_NAverages PVM_NRepetitions see code in parsRelations.c */
  Local_NAveragesRange();
  NrepRange();

  if(ParxRelsParHasValue("Exp_type") == No)
	Exp_type = CRAZED;

  /* Initialisation of rf pulse parameters */

  /* 1: flip angle in the scan edidor */
  if(ParxRelsParHasValue("PVM_ExcPulseAngle") == No)
      PVM_ExcPulseAngle = 30.0;
  ParxRelsShowInEditor("PVM_ExcPulseAngle");



  /* 2: pulses declared in parDefinitions.h 
     in this case - ExcPulse. We initalise it to default name, 
     1ms, and the flip angle given in PVM_ExcPulseAngle*/

  if(ParxRelsParHasValue("ExcPulse") == No)
    STB_InitRFPulse(&ExcPulse,
		    CFG_RFPulseDefaultShapename(LIB_EXCITATION),
		    1.0,  /* default duration in ms */
		    90.0);
  ExcPulseRange();
  if(ParxRelsParHasValue("RefPulse") == No)
    STB_InitRFPulse(&RefPulse,
		    CFG_RFPulseDefaultShapename(LIB_REFOCUS),
		    1.0, /* default duration in ms */
		    180.);
  RefPulseRange();

  if(ParxRelsParHasValue("MixPulse") == No)
    STB_InitRFPulse(&MixPulse,
		    CFG_RFPulseDefaultShapename(LIB_EXCITATION),
		    1.0, /* default duration in ms */
		    PVM_ExcPulseAngle);
//   MixPulseRange();
  if(ParxRelsParHasValue("ExcPulseSel") == No)
    STB_InitRFPulse(&ExcPulseSel,
		    CFG_RFPulseDefaultShapename(LIB_EXCITATION),
		    1.0,  /* default duration in ms */
		    90.0);
  ExcPulseSelRange();
  if(ParxRelsParHasValue("RefPulseSel") == No)
    STB_InitRFPulse(&RefPulseSel,
		    CFG_RFPulseDefaultShapename(LIB_REFOCUS),
		    1.0, /* default duration in ms */
		    180.);
  RefPulseSelRange();

  if(ParxRelsParHasValue("BIRPulse") == No)
    STB_InitRFPulse(&BIRPulse,
		    CFG_RFPulseDefaultShapename(LIB_REFOCUS),
		    1.0, /* default duration in ms */
		    180.);
  if(ParxRelsParHasValue("InvPulseSel") == No)
    STB_InitRFPulse(&InvPulseSel,
		    CFG_RFPulseDefaultShapename(LIB_INVERSION),
		    4.0, /* default duration in ms */
		    180.);
  
  /* 3: the corresponding pulse enums */

  STB_InitExcPulseEnum("ExcPulseEnum");
  STB_InitExcPulseEnum("ExcPulseSelEnum");
  STB_InitRfcPulseEnum("RefPulseEnum");
  STB_InitRfcPulseEnum("RefPulseSelEnum");
  STB_InitExcPulseEnum("MixPulseEnum");
  STB_InitExcPulseEnum("BIRPulseEnum");
  STB_InitExcPulseEnum("InvPulseSelEnum");

  /* Initialisation of nucleus */  
   if (ParxRelsParHasValue("PVM_Nucleus1") == 0)
     PVM_Nucleus1Enum = (STANDARD_NUCLEUS_TYPE)0;

 if(ParxRelsParHasValue("phase_enc_vector") == No)
	{
	PARX_change_dims("phase_enc_vector",1);
	phase_enc_vector[0] = 0;
	}

 if(ParxRelsParHasValue("PulseCycleOnOff") == No) PulseCycleOnOff = Off;
 if(ParxRelsParHasValue("RMD_ramp_time_adjust") == No) RMD_ramp_time_adjust = 0.0;
 if((ParxRelsParHasValue("num_echoes") == No) || (num_echoes == 0)) num_echoes = 2;
 ParxRelsMakeNonEditable("min_time_bw_rfc_pulses");
  if(ParxRelsParHasValue("time_bw_rfc_pulses") == No) time_bw_rfc_pulses = 1.;
  if(ParxRelsParHasValue("RARE_mode") == No) RARE_mode = one_image;
  if(ParxRelsParHasValue("exc_slc_sel_grad_percent") == No) exc_slc_sel_grad_percent = 2.;
  if(ParxRelsParHasValue("rl_thickness") == No) rl_thickness = 4.;
  if(ParxRelsParHasValue("ap_thickness") == No) ap_thickness = 4.;
  if(ParxRelsParHasValue("hf_thickness") == No) hf_thickness = 4.;
  if(ParxRelsParHasValue("rl_offset_mm") == No) rl_offset_mm = 0.;
  if(ParxRelsParHasValue("ap_offset_mm") == No) ap_offset_mm = 0.;
  if(ParxRelsParHasValue("hf_offset_mm") == No) hf_offset_mm = 0.;
  if(ParxRelsParHasValue("rl_offset_hz") == No) rl_offset_hz = 0.;
  if(ParxRelsParHasValue("ap_offset_hz") == No) ap_offset_hz = 0.;
  if(ParxRelsParHasValue("hf_offset_hz") == No) hf_offset_hz = 0.;
  if(ParxRelsParHasValue("te_adjust_ms") == No) te_adjust_ms = 0.6;
  if(ParxRelsParHasValue("RMD_grad_stabilization_time_ms") == No) RMD_grad_stabilization_time_ms = 0.25;
  if(ParxRelsParHasValue("MSE_slice_sel_mode") == No) MSE_slice_sel_mode = No;
  if(ParxRelsParHasValue("slice_sel_grad_adjust") == No) slice_sel_grad_adjust = 80.;
  if(ParxRelsParHasValue("read_rephase_adjust") == No) read_rephase_adjust = 0.;
   STB_InitNuclei(1);

//   /* Initialisation of modules */
// 
//    STB_InitEpi(UserSlope, No_navigators);

  /* initialisation of spectroscopy */


  ParxRelsHideInEditor("PVM_SpecOffsetHz,PVM_SpecOffsetppm");


  STB_InitSpectroscopy( 1, 1, 1 ,  PVM_Nucleus1 , 200.0, 1000000 );

  /* 
   * Initialisation of geometry parameters 
   * A: in-plane 
   */

  STB_InitStandardInplaneGeoPars(2,dimRange,lowMat,upMat,No);
  
  /* B: slice geometry */

  STB_InitSliceGeoPars(0,0,0);

  /* Initialize multi receiver parameters */

  STB_InitEncoding();

  /*Initialize EPI variables */

//   STB_InitEpi(UserSlope, No_navigators);
 
  NdummyRange();

  /* initialisation of DeadTime */
  DeadTimeRange();

  /* setting for Pipeline filter Combine_Spec in case of multi channel acquisition */
  PVM_RefScanPCYN = No;
 
  /* Once all parameters have initial values, the backbone is called
     to assure they are consistent */
   if (ParxRelsParHasValue("NSegments") == 0)  NSegments = 1;
  
  backbone();
 

  DB_MSG(( "Exiting singlepulse:initMeth()" ));

}



/****************************************************************/
/*		E N D   O F   F I L E				*/
/****************************************************************/









