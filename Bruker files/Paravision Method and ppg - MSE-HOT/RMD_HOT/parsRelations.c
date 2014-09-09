/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/parsRelations.c,v $
 *
 * RMD_HOT
 *
 * Copyright (c) 2002 -2003
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 * $Id: parsRelations.c,v 1.19.2.4 2008/04/25 15:03:40 sako Exp $
 *
 ****************************************************************/

static const char resid[] = "$Id: parsRelations.c,v 1.19.2.4 2008/04/25 15:03:40 sako Exp $ (C) 2002 Bruker BioSpin MRI GmbH";

#define DEBUG		1
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


/* ------------------------------------------------------------ 
  backbone 
  The main part of method code. The consitency of all parameters is checked
  chere, relations between them are resolved and, finally, functions setting
  the base level parameters are called.
  --------------------------------------------------------------*/
void backbone( void )
{
  YesNo refAttIsAvailable=No;
  double referenceAttenuation=0;
//  double minFov[3] = {1e-3, 1e-3, 1e-3};
//  int seg_size=1;       
  
  
  DB_MSG(("Entering einpuls:backbone"));

  /****************adjust experiment type depending on whether is imaging or spectroscopy************/



  /*
   *  control appearance in GeoEditor: method doesn't support any geometric operation
   */

  GeoModeRange();

  /* Nucleus and  PVM_GradCalConst
     are handled by this funtion: */
  STB_UpdateNuclei(Yes);
 
  DB_MSG(("nucleus ok"));

  /* handle RF pulse */   

  if(PVM_DeriveGains == Yes)
    refAttIsAvailable =
      STB_GetRefAtt(1,PVM_Nucleus1,&referenceAttenuation);
  else
    refAttIsAvailable = No;

  STB_UpdateRFPulse("ExcPulse",
		    &ExcPulse,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateExcPulseEnum("ExcPulseEnum",
			 &ExcPulseEnum,
			 ExcPulse.Filename,
			 ExcPulse.Classification);
  STB_UpdateRFPulse("ExcPulseSel",
		    &ExcPulseSel,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateExcPulseEnum("ExcPulseSelEnum",
			 &ExcPulseSelEnum,
			 ExcPulseSel.Filename,
			 ExcPulseSel.Classification);
  
  STB_UpdateRFPulse("RefPulse",
		    &RefPulse,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateRfcPulseEnum("RefPulseEnum",
			 &RefPulseEnum,
			 RefPulse.Filename,
			 RefPulse.Classification);
  STB_UpdateRFPulse("RefPulseSel",
		    &RefPulseSel,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateRfcPulseEnum("RefPulseSelEnum",
			 &RefPulseSelEnum,
			 RefPulseSel.Filename,
			 RefPulseSel.Classification);
  STB_UpdateRFPulse("BIRPulse",
		    &BIRPulse,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateRfcPulseEnum("BIRPulseEnum",
			 &BIRPulseEnum,
			 BIRPulse.Filename,
			 BIRPulse.Classification);
  STB_UpdateRFPulse("InvPulseSel",
		    &InvPulseSel,
		    refAttIsAvailable,
		    referenceAttenuation);
  STB_UpdateRfcPulseEnum("InvPulseSelEnum",
			 &InvPulseSelEnum,
			 InvPulseSel.Filename,
			 InvPulseSel.Classification);

  PVM_ExcPulseAngle = ExcPulse.FlipAngle;
  


  /* excitation pulse */
  PVM_ExSlicePulseLength   = ExcPulse.Length;
  PVM_ExSliceBandWidth     = ExcPulse.Bandwidth* 
                             PVM_SliceBandWidthScale/100.0;
  PVM_ExSliceRephaseFactor = ExcPulse.RephaseFactor* 
                             ExcPulse.TrimRephase / 100.0;
  
  PVM_NEchoImages = 1;

  /* ------------- spectroscopy part ----------------------- */
  STB_UpdateSpectroscopy( PVM_Nucleus1 );
  DB_MSG(("spectro ok"));

  /* --------------handling decoupling modules ------------- */

  /* update Encoding parclass for multi receiver experiment */



//   if (Exp_type != SE_EPI)
// 
// 	{
// 		  PARX_change_dims("PVM_AntiAlias", 1);
// 		  PVM_AntiAlias[0] = 1.0;
// 		  STB_UpdateEncoding(1,
// 		     PVM_SpecMatrix,
// 		     PVM_AntiAlias,
// 		     &seg_size,
// 		     SEG_SEQUENTIAL,
// 		     No,
// 		     No,
// 		     No);
// 
// 	}
//   else 
// 	{
// // /*		
// // 				/*** encoding */
// // 		/* note: Grappa reference lines are disabled. Grappa coeeficients will be set
// // 		* in a special adjustment. */
// // 		  PARX_change_dims("PVM_AntiAlias", 2);
// // 		  PVM_AntiAlias[0] = 1.0;
// // 		PVM_AntiAlias[1] = 1.0;
// // 		STB_UpdateEncodingForEpi(PTB_GetSpatDim(),  /* total dimensions */
// // 				PVM_Matrix,        /* image size */ 
// // 				PVM_AntiAlias,     /* a-alias */
// // 				&NSegments,        /* segment size */
// // 				Yes,               /* ppi in 2nd dim allowed */
// // 				No,                /* ppi ref lines in 2nd dim allowed */
// // 				Yes);              /* partial ft in 2nd dim allowed */ 
// // // 		
// // 		/** Update EPI parameter group */
// // 		int ret,dim,nImagesPerRep;
// // 		nImagesPerRep = PVM_NEchoImages * GTB_NumberOfSlices( PVM_NSPacks, PVM_SPackArrNSlices );
// //   		dim = PTB_GetSpatDim();
// // 		ret = STB_EpiUpdate(dim,
// // 				PVM_EncMatrix, 
// // 				PVM_AntiAlias,
// // 				PVM_Fov, 
// // 				minFov, 
// // 				&PVM_EffSWh, 
// // 				PVM_GradCalConst, 
// // 				nImagesPerRep,
// // 				PVM_NRepetitions,
// // 				NSegments,
// // 				PVM_EncCentralStep1,
// // 				PVM_EncPpiAccel1,
// // 				PVM_EncNReceivers);
// // 		
// // 		if(ret <0)
// // 		DB_MSG(("--!!!!!!!!!!!!!!! Illegal arguments for STB_UpdateEPI: EPI Module not ready !"));
// // 		
// // 		/* minFov is now known; we update geometry again */
// // 		STB_StandardInplaneGeoParHandler(minFov,2.0);*/
// 	}
  //if (Exp_type == CRAZED_2D) PVM_NAverages = 8; 
  /* DeadTime */

  expTypeRels();
  pressRelations();
  subrRelations();
  rareRelations();
  updateDeadTime();

  /* repetition time */
  repetitionTimeRels();
  DB_MSG(("TR ok"));

  crazedParametersRelations();

  spatialEncodingGradientRelations();
  /* set GS parameters */
  SetGSparameters();

 

  //EPItimingRels();

//The following two lines were added because these two dur variables are set to 0 by the method code and I am not sure why:
  if (grad_spoil_dur < 3.*PVM_RiseTime) grad_spoil_dur = 0.7;
  if (dephase_grad_dur < 2.*PVM_RiseTime) dephase_grad_dur = 0.5;
  if (phase_mat_size < 1 || !ParxRelsParHasValue("phase_mat_size")) phase_mat_size = 32;
  phaseVectRelsNB();

  /* set baselevel acquisition parameter */
  SetBaseLevelParam();
  DB_MSG(("baselev ok"));

  /* set baselevel reconstruction parameter */
  SetRecoParam();

  DB_MSG(("Exiting einpuls:backbone"));
}

void crazedParametersRelations(void)
{
//double grad_m,grad_2m,gradCalConst,exc_slice_rephase_area;
DB_MSG(("-->dsRelations\n"));

//grad m and grad_2m are the gradient strength in tesla/m needed to acheive gradient of GT (not mGT,nGT, etc...) if duration is MQFilterGradientDuration (grad_m) or MQFilterGraqdientDuration2m(grad_2m)
//
//grad_m = 3.14159/((267.5 * 1000000.0) * (CorrelationDistance / 1000000.0) * ((MQFilterGradientDuration - PVM_RiseTime) / 1000.0)); //in tesla per meter
//
//grad_2m = 3.14159/((267.5 * 1000000.0) * (CorrelationDistance / 1000000.0) * ((MQFilterGradientDuration2m - PVM_RiseTime) / 1000.0)); //in tesla per //meter

//gradCalConst = PVM_GradCalConst * 1000. / (42.576 * 1000000.0); //in Tesla per meter;
//
//FirstMQFilterGradientTrim = 100. * grad_m/gradCalConst;
//MQFilterGradientTrim2m = 100. * grad_2m/gradCalConst;
//
//DB_MSG(("FirstMQFilterGradientTrim %f",FirstMQFilterGradientTrim));
//
//SecondMQFilterGradientTrim = CoherenceOrder * FirstMQFilterGradientTrim;


if ((Exp_type == HOT) || (Exp_type == HOT_2D) || (Exp_type == HOT_2D_1win) || (Exp_type == HOT_2D_SLI) || (Exp_type == HOT_2D_SLI_ZQSQ)  || (Exp_type == HOT_2D_RARE_ZQSQ) || (Exp_type == HOT_2D_RARE_ZQSQ2) || (Exp_type == HOT_2D_RARE_ZQSQ3)  || (Exp_type == HOT_2D_1win_PRESS)) nn = 1. + mm;

FirstMQFilterGradientTrim = mm*(100./PVM_GradCalConst)/(2.*(CorrelationDistance/1000.)*((MQFilterGradientDuration - PVM_RiseTime)/1000.));
MQFilterGradientTrim2m = 2.*mm*(100./PVM_GradCalConst)/(2.*(CorrelationDistance/1000.)*((MQFilterGradientDuration2m - PVM_RiseTime)/1000.));
MQFilterGradientTrim_n = FirstMQFilterGradientTrim*(nn/mm);
MQFilterGradientTrim_mpn = FirstMQFilterGradientTrim*((mm+nn)/(mm));
MQFilterGradientTrim_mln = (mm-nn)*(100./PVM_GradCalConst)/(2.*(CorrelationDistance/1000.)*((MQFilterGradientDuration2m - PVM_RiseTime)/1000.));

//Add the rephase area back into the correlation gradient area:
exc_slice_percent = (100./PVM_GradCalConst)*ExcPulse.Bandwidth/SliceThickness;
slice_rephase_area = -0.5*(ExcPulse.Bandwidth/SliceThickness)*(ExcPulse.Length/1000.+PVM_RiseTime/1000.); //units are [per mm]
MQFilterGradientTrim_mlsr = FirstMQFilterGradientTrim + (100./PVM_GradCalConst)*slice_rephase_area/((MQFilterGradientDuration - PVM_RiseTime)/1000.);

if (((Exp_type == CRAZED || Exp_type == CRAZED_2D) && ((fabs(FirstMQFilterGradientTrim) > 100.) || (fabs(MQFilterGradientTrim2m) > 100.))) || !(Exp_type == CRAZED || Exp_type == CRAZED_2D) && ((fabs(2.*mm*MQFilterGradientTrim2m) > 100.) || (fabs(nn*FirstMQFilterGradientTrim) > 100.) || (fabs(2.*(mm + nn)*FirstMQFilterGradientTrim) > 100.)))
  {
  SecondMQFilterGradientTrim = 0.;
  FirstMQFilterGradientTrim = 0.;
  CorrelationDistance = 0.;
  DB_MSG(("Error, MQ gradients exceed maximum possible value"));
}


DB_MSG(("<--dsRelations\n"));
}
/* ------------------------------------------------------------
   relations of DeadTime
   -------------------------------------------------------------*/
void DeadTimeRels(void)
{
  DeadTimeRange();
  backbone();
}

void DeadTimeRange(void)
{
  if(ParxRelsParHasValue("DeadTime") == No)
    DeadTime = 0.05;
  DeadTime = MAX_OF(0.001, DeadTime);
  DeadTime = MIN_OF(5.0, DeadTime);
}

void updateDeadTime(void)
{
  double min_us;
  
  /* The minimum delay between RF pulse and ACQ_START is given by the
   * base-level parameter DE. This parameter was set during the update of
   * spectorscopy. */

  min_us = DE; 

  DeadTime =  MAX_OF(DeadTime, min_us*1e-3);
}

/*--------------------------------------------------------------
  ExcPulseAngleRelation
  Redirected relation of PVM_ExcPulseAngle
  -------------------------------------------------------------*/
void ExcPulseAngleRelation(void)
{
  DB_MSG(("-->ExcPulseAngleRelation"));
  ExcPulse.FlipAngle = PVM_ExcPulseAngle;
  ExcPulseRange();
  backbone();
  DB_MSG(("<--ExcPulseAngleRelation"));
}

/*===========================================================
 *
 *  examples for relations concearning special pulses and 
 *  pulselists
 *
 *==========================================================*/



/* --------------------------------------------------------------
   ExcPulseEnumRelation
   Relation of ExcPulseEnum (a dynamic enmueration parameter which
   allows to select one of the existing library exc. pulses)
   Sets the name and the clasification  of the pulse perameter ExcPulse 
   according to the selected enum value.
   --------------------------------------------------------------*/
void ExcPulseEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->ExcPulsesEnumRelation"));
  
  /* set the name and clasification of ExcPulse: */
  status = STB_UpdateExcPulseName("ExcPulseEnum",
				  &ExcPulseEnum,
				  ExcPulse.Filename,
				  &ExcPulse.Classification);

  /* call the method relations */
  backbone();

  DB_MSG(("<--ExcPulseEnumRelation status = %s",
	  status == Yes? "Yes":"No"));
}

void ExcPulseSelEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->ExcPulseSelEnumRelation"));
  
  /* set the name and clasification of ExcPulse: */
  status = STB_UpdateExcPulseName("ExcPulseSelEnum",
				  &ExcPulseSelEnum,
				  ExcPulseSel.Filename,
				  &ExcPulseSel.Classification);

  /* call the method relations */
  backbone();

  DB_MSG(("<--ExcPulseSelEnumRelation status = %s",
	  status == Yes? "Yes":"No"));
}

void RefPulseEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->RefPulsesEnumRelation\n"));

  /* set the name and clasification of RefPulse: */
  status = STB_UpdateRfcPulseName("RefPulseEnum",
				  &RefPulseEnum,
				  RefPulse.Filename,
				  &RefPulse.Classification);

  /* ref pulse changed - check it */
  RefPulseRange();

  /* call the method relations */
  backbone();

  DB_MSG(("<--RefPulseEnumRelation\n"));

}

void BIRPulseEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->BIRPulsesEnumRelation\n"));

  /* set the name and clasification of RefPulse: */
  status = STB_UpdateRfcPulseName("BIRPulseEnum",
				  &BIRPulseEnum,
				  BIRPulse.Filename,
				  &BIRPulse.Classification);

  /* ref pulse changed - check it */
  BIRPulseRange();

  /* call the method relations */
  backbone();

  DB_MSG(("<--BIRPulseEnumRelation\n"));

}

void RefPulseSelEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->RefPulseSelEnumRelation\n"));

  /* set the name and clasification of RefPulse: */
  status = STB_UpdateRfcPulseName("RefPulseSelEnum",
				  &RefPulseSelEnum,
				  RefPulseSel.Filename,
				  &RefPulseSel.Classification);

  /* ref pulse changed - check it */
  RefPulseSelRange();

  /* call the method relations */
  backbone();

  DB_MSG(("<--RefPulsesSelEnumRelation\n"));

}

void InvPulseSelEnumRelation(void)
{
  YesNo status;
  DB_MSG(("-->InvPulseSelEnumRelation\n"));

  /* set the name and clasification of RefPulse: */
  status = STB_UpdateRfcPulseName("InvPulseSelEnum",
				  &InvPulseSelEnum,
				  InvPulseSel.Filename,
				  &InvPulseSel.Classification);
  
  /* ref pulse changed - check it */
  InvPulseSelRange();
  
  /* call the method relations */
  backbone();
  
  DB_MSG(("<--InvPulseEnumRelation\n"));

}

/* -----------------------------------------------------------
   Relation of ExcPulse
 
   All pulses of type PVM_RF_PULSE_TYPE must have relations like this.
   However, if you clone this funtion for a different pulse parameter
   remember to replace the param name in the call to UT_SetRequest!

   IMPORTANT: this function should not be invoked in the backbone!
   -----------------------------------------------------------*/
void ExcPulseRelation(void)
{
  DB_MSG(("-->ExcPulseRelation"));

  /* Tell the request handling system that the parameter
     ExcPulse has been edited */
  UT_SetRequest("ExcPulse");

  /* Check the values of ExcPulse */
  ExcPulseRange();

  /* call the backbone; further handling will take place there
     (by means of STB_UpdateRFPulse)  */
 
  backbone();

  DB_MSG(("-->ExcPulseRelation"));
}

void ExcPulseSelRelation(void)
{
  DB_MSG(("-->ExcPulseSelRelation"));

  /* Tell the request handling system that the parameter
     ExcPulse has been edited */
  UT_SetRequest("ExcPulseSel");

  /* Check the values of ExcPulse */
  ExcPulseSelRange();

  /* call the backbone; further handling will take place there
     (by means of STB_UpdateRFPulse)  */
 
  backbone();

  DB_MSG(("-->ExcPulseSelRelation"));
}

void InvPulseSelRelation(void)
{
  DB_MSG(("-->InvPulseSelRelation"));

  /* Tell the request handling system that the parameter
     ExcPulse has been edited */
  UT_SetRequest("InvPulseSel");

  /* Check the values of ExcPulse */
  InvPulseSelRange();

  /* call the backbone; further handling will take place there
     (by means of STB_UpdateRFPulse)  */
 
  backbone();

  DB_MSG(("-->InvPulseSelRelation"));
}

void RefPulseRelation(void)
{
  DB_MSG(("-->RefPulseRelation\n"));

  /*
   *  Tell the request handling system that the parameter
   *  RefPulse has been edited
   */

  UT_SetRequest("RefPulse");

  /* Check the values of RefPulse */
  RefPulseRange();

  /*
   * call the backbone; further handling will take place
   * there (by means of STB_UpdateRFPulse)
   */

  backbone();

  DB_MSG(("<--RefPulseRelation\n"));
}

void RefPulseSelRelation(void)
{
  DB_MSG(("-->RefPulseSelRelation\n"));

  /*
   *  Tell the request handling system that the parameter
   *  RefPulse has been edited
   */

  UT_SetRequest("RefPulseSel");

  /* Check the values of RefPulse */
  RefPulseSelRange();

  /*
   * call the backbone; further handling will take place
   * there (by means of STB_UpdateRFPulse)
   */

  backbone();

  DB_MSG(("<--RefPulseSelRelation\n"));
}

void BIRPulseRelation(void)
{
  DB_MSG(("-->BIRPulseRelation\n"));

  /*
   *  Tell the request handling system that the parameter
   *  RefPulse has been edited
   */

  UT_SetRequest("BIRPulse");

  /* Check the values of RefPulse */
  BIRPulseRange();

  /*
   * call the backbone; further handling will take place
   * there (by means of STB_UpdateRFPulse)
   */

  backbone();

  DB_MSG(("<--BIRPulseRelation\n"));
}
/****************************************************************/
/*	         L O C A L   F U N C T I O N S			*/
/****************************************************************/



void ExcPulseRange(void)
{
  DB_MSG(("-->ExcPulseRange"));
  
  /* allowed clasification */

  switch(ExcPulse.Classification)
  {
  default:
    ExcPulse.Classification = LIB_EXCITATION;
    break;
  case LIB_EXCITATION:
  case PVM_EXCITATION:
  case USER_PULSE:
    break;
  }

  /* allowed angle for this pulse */
 
  ExcPulse.FlipAngle = MIN_OF(90.0,ExcPulse.FlipAngle);


  /* general verifiation of all pulse atributes  */

  STB_CheckRFPulse(&ExcPulse);

  DB_MSG(("<--ExcPulseRange"));

}

void ExcPulseSelRange(void)
{
  DB_MSG(("-->ExcPulseSelRange"));
  
  /* allowed clasification */

  switch(ExcPulseSel.Classification)
  {
  default:
    ExcPulseSel.Classification = LIB_EXCITATION;
    break;
  case LIB_EXCITATION:
  case PVM_EXCITATION:
  case USER_PULSE:
    break;
  }

  /* allowed angle for this pulse */
 
  ExcPulseSel.FlipAngle = MIN_OF(90.0,ExcPulseSel.FlipAngle);


  /* general verifiation of all pulse atributes  */

  STB_CheckRFPulse(&ExcPulseSel);

  DB_MSG(("<--ExcPulseSelRange"));

}

void InvPulseSelRange(void)
{
  DB_MSG(("-->InvPulseSelRange"));
  
  /* allowed clasification */

  switch(InvPulseSel.Classification)
  {
  default:
    InvPulseSel.Classification = LIB_INVERSION;
    break;
  case LIB_EXCITATION:
  case PVM_EXCITATION:
  case USER_PULSE:
    break;
  }


  /* general verifiation of all pulse atributes  */

  STB_CheckRFPulse(&InvPulseSel);

  DB_MSG(("<--InvPulseSelRange"));

}


void RefPulseRange(void)
{
  DB_MSG(("-->RefPulseRange\n"));
  
  /* allowed classification */
  
  /*switch(RefPulse.Classification)
  {
    default:
      RefPulse.Classification = LIB_REFOCUS;
      break;
    case LIB_REFOCUS:
    case PVM_REFOCUS:
    case USER_PULSE:
      break;
  }*/
  
  /* allowed angle for this pulse */
 
  RefPulse.FlipAngle = MIN_OF(270,RefPulse.FlipAngle);
  

  /* general verifiation of all pulse attributes  */

  STB_CheckRFPulse(&RefPulse);

  DB_MSG(("<--RefPulseRange\n"));

}

void RefPulseSelRange(void)
{
  DB_MSG(("-->RefPulseSelRange\n"));

  /* allowed classification */

  /*switch(RefPulse.Classification)
  {
    default:
      RefPulse.Classification = LIB_REFOCUS;
      break;
    case LIB_REFOCUS:
    case PVM_REFOCUS:
    case USER_PULSE:
      break;
  }*/

  /* allowed angle for this pulse */

  RefPulseSel.FlipAngle = MIN_OF(270,RefPulseSel.FlipAngle);



  /* general verifiation of all pulse attributes  */

  STB_CheckRFPulse(&RefPulseSel);

  DB_MSG(("<--RefPulseSelRange\n"));

}

void BIRPulseRange(void)
{
  DB_MSG(("-->BIRPulseRange\n"));

  /* allowed classification */

  /*switch(RefPulse.Classification)
  {
    default:
      RefPulse.Classification = LIB_REFOCUS;
      break;
    case LIB_REFOCUS:
    case PVM_REFOCUS:
    case USER_PULSE:
      break;
  }*/

  /* allowed angle for this pulse */

  BIRPulse.FlipAngle = MIN_OF(270,BIRPulse.FlipAngle);



  /* general verifiation of all pulse attributes  */

  STB_CheckRFPulse(&BIRPulse);

  DB_MSG(("<--BIRPulseRange\n"));

}



void repetitionTimeRels( void )
{
  int i,dim;
  double TotalTime,amplifierenable;

  DB_MSG(("--> minRepetitionTimeRels"));

  TotalTime = 0.0;
  amplifierenable = CFG_AmplifierEnable();

  PVM_MinRepetitionTime =
    0.01                     +
    amplifierenable          +  /* time before RF-Pulse */
    ExcPulse.Length          +
    DeadTime                 +
    PVM_SpecAcquisitionTime  +
    6.0                      +  /* min d0 */
    1.01;

  PVM_RepetitionTime = ( PVM_RepetitionTime < PVM_MinRepetitionTime ?
			 PVM_MinRepetitionTime : PVM_RepetitionTime );
  
  /** Calculate Total Scan Time and Set for Scan Editor **/ 

  dim = PTB_GetSpecDim();
  TotalTime = PVM_RepetitionTime*PVM_NAverages;
  for(i=1; i<dim; i++)
     TotalTime *= PVM_SpecMatrix[i];

  TotalTime *= PVM_NRepetitions;

  UT_ScanTimeStr(PVM_ScanTimeStr,TotalTime);

  RMD_NA = PVM_NAverages;
 

  ParxRelsShowInEditor("PVM_ScanTimeStr");
  ParxRelsMakeNonEditable("PVM_ScanTimeStr");

  DB_MSG(("<-- repetitionTimeRels"));
}



void Local_NAveragesRange(void)
{
  int ival;
  DB_MSG(("Entering Local_NAveragesRange"));
  
  /* 
   *  Range check of PVM_NAverages: prevent it to be negative or 0
   */

  if(ParxRelsParHasValue("PVM_NAverages") == No)
    {
      PVM_NAverages = 1;
    }

  ival = PVM_NAverages;
  PVM_NAverages = MAX_OF(ival,1);
  
  DB_MSG(("Exiting Local_NAveragesRange"));

}


void Local_NAveragesHandler(void)
{

  DB_MSG(("Exiting Local_NAveragesHandler with value %d",PVM_NAverages));

  Local_NAveragesRange();

  /*
   *   Averages range check is finished, handle the request by
   *   the method:
   */

  
  backbone();


  DB_MSG(("Exiting Local_NAveragesHandler with value %d",PVM_NAverages));
  return;
}


void NrepRange(void)
{
  if(ParxRelsParHasValue("PVM_NRepetitions") ==No)
  {
    PVM_NRepetitions = 1;
  }    
  else
  {
     PVM_NRepetitions = MAX_OF(1,PVM_NRepetitions);
  }

}

void NrepRel(void)
{
  NrepRange();
  backbone();
}

void SpecHandler(void)
{
  DB_MSG(("-->SpecHandler\n"));

  backbone();

  DB_MSG(("<--SpecHandler\n"));
}

/*
 * set parameters of the GS class 
 */
void SetGSparameters(void)
{
  GS_info_normalized_area = Of_raw_data;
}



void GeoModeRange(void)
{
  
  PVM_GeoMode= GeoMRS;
  ParxRelsHideInEditor("PVM_GeoMode");
  ParxRelsShowInFile("PVM_GeoMode");

}

void NdummyRange(void)
{
  if(!ParxRelsParHasValue("Ndummy"))
  {
    Ndummy = 0;
  }
  else
  {
    Ndummy = MAX_OF(0,Ndummy);
  }
}


void NdummyRel(void)
{
  NdummyRange();
  backbone();

}

/* Relations of PVM_AutoRgInitHandler (see callbackDefs.h)
 * This function is called when the RG adjustment starts. It modifies
 * the state of the method just for the adjustment. Afterwards, the
 * original state is re-established. We use it to turn off the pipeline filter
 * during the RG adjustment.
 */
void MyRgInitRel(void)
{

  DB_MSG(("-->MyRgInitRel"));
 
  if(PVM_EncUseMultiRec == Yes)
  {
    int nrec,availrec,i;
    nrec = (int)PARX_get_dim("ACQ_ReceiverSelect",1);
    availrec = (int)PARX_get_dim("PVM_EncActReceivers",1);
    for(i=0;i<availrec;i++)
      ACQ_ReceiverSelect[i] = PVM_EncActReceivers[i]==On ? Yes:No;
    for(i=availrec;i<nrec;i++)
      ACQ_ReceiverSelect[i]=No;
    ACQ_user_filter = No;
    ParxRelsParRelations("ACQ_user_filter",Yes);
    ACQ_user_filter_size[0] = ACQ_user_filter_size[1] = ACQ_user_filter_size[2]= 0;
    ParxRelsParRelations("ACQ_user_filter_size",Yes);
  }

  ParxRelsParRelations("PVM_AutoRgInitHandler",Yes);
 
  DB_MSG(("<--MyRgInitRel"));
}

void   spatialEncodingGradientRelations(void)
{
	//Calculate Read dephase gradient strength:
//        readDephInteg = MRT_NormGradPulseTime( PVM_ReadDephaseTime,
// 					      0.249,
// // 					      50,
// 					      0.249,
// 					      50);
// 
//        readRampInteg = MRT_NormGradRampTime( 0.249,
// 					     50 );
// 
//        ReadGradRatio = MRT_ReadGradRatio( PVM_SpecAcquisitionTime,
// 					  50,	//PVM_EchoPosition
// 					  0.,	//PVM_AcqStartWaitTime
// 					  readDephInteg,
// 					  readRampInteg );

//       PVM_ReadGradient = MRT_ReadGrad( PVM_SpecSWH[0],
// 				      read_FOV,
// 				      PVM_GradCalConst );
//       PVM_ReadDephaseGradient = MRT_ReadDephaseGrad( ReadGradRatio,
// 						     PVM_ReadGradient );
// 	PVM_ReadDephaseGradient = 0.5*PVM_ReadGradient*(/*PVM_RiseTime*/ + PVM_SpecAcquisitionTime)/(PVM_ReadDephaseTime - PVM_RiseTime);
// 	//Calculate phase blip gradient strength
// 	double effective_phase_gradon_time;
// 	effective_phase_blip_time = phase_blip_dur - PVM_RiseTime;
// 	phase_blip_grad = 100.*(1./(phase_FOV*effective_phase_blip_time*0.001))/PVM_GradCalConst;
// 	effective_phase_gradon_time = effective_phase_blip_time * double(phase_mat_size);  //Sums up total phase gradient on time from all blips

	//Calculate phase prep gradient strength
	//double phasePrepInteg = readDephInteg;
	//double phaseRampInteg = readRampInteg;
// 	double phasePrepArea = 0.;
// 	phasePrepArea = effective_phase_gradon_time*phase_blip_grad; //units %*ms
// 	phase_prep_dur = PVM_ReadDephaseTime; //ms
// 	PhasePrepGradRatio = MRT_ReadGradRatio( effective_phase_gradon_time,
// 					  50,  //Echo Position
// 					  0.,	//PVM_AcqStartWaitTime
// 					  phasePrepInteg,
// 					  phaseRampInteg );
// 	phase_prep_grad = 0.5*phasePrepArea/((phase_prep_dur - PVM_RiseTime));

	////THIS section is for calculating shapes of gaussian blips
// 	double gauss_blip_area = 0.;
// 	gauss_blip_area = 1./phase_FOV;

	

	/*calculate frequency encoding gradient areas and amplitude*/
// 	double grad_spoil_area_phase_only = 0.;
// 	double grad_spoil_area_read_only = 0.;

	freq_enc_grad_Hz_mm = PVM_SpecSWH[0]/read_FOV;
	//the 16 microsecond delay are for the extra delays associated with turning on and off the acq window
	freq_enc_grad_Hz = freq_enc_grad_Hz_mm * (PVM_SpecAcquisitionTime + PVM_RiseTime + 0.5*65e-3)/1000.; //this should be called xx_per_mm rather than xx_Hz
	freq_enc_grad_percent = 100. * freq_enc_grad_Hz_mm / PVM_GradCalConst;

	if (digfiltcompOnOff == Off) freq_enc_dephase_area = freq_enc_rephase_area = freq_enc_grad_Hz * 0.5;
	else
	{ 
		freq_enc_dephase_area = freq_enc_grad_Hz * (0.5 * (1. - PVM_DigGroupDel/PVM_SpecAcquisitionTime));
		freq_enc_rephase_area = freq_enc_grad_Hz * (0.5 * (1. + PVM_DigGroupDel/PVM_SpecAcquisitionTime));
	}
	freq_enc_rephase_area = freq_enc_rephase_area*(1.+read_rephase_adjust/100.); //fixes linear phase ramp on even echoes
	
	//if the dephase is included in the spoiler gradients:
	phase_encode_increment_area = 1./phase_FOV;  //units are cycles/mm
	phase_enc_dephase_area = phase_encode_increment_area * phase_mat_size / 2.;
	grad_spoil_percent = 100.*k_spoil/(pow(3.,0.5) * PVM_GradCalConst * (grad_spoil_dur - PVM_RiseTime)/1000.);
	grad_spoil_mod_phase_percent = 100.*(k_spoil/pow(3.,0.5) - phase_enc_dephase_area)/(PVM_GradCalConst * (grad_spoil_dur - PVM_RiseTime)/1000.);  //dephase for phase encoding
	grad_spoil_mod_read_percent = 100.*(k_spoil/pow(3.,0.5) - freq_enc_dephase_area)/(PVM_GradCalConst * (grad_spoil_dur - PVM_RiseTime)/1000.);  //dephase for read encoding

	//if the dephase is included in its own gradient
	freq_enc_dephase_percent = 100. * (freq_enc_dephase_area/(dephase_grad_dur/1000. - PVM_RiseTime/1000.))/PVM_GradCalConst;
	freq_enc_rephase_percent = 100. * (freq_enc_rephase_area/(dephase_grad_dur/1000. - PVM_RiseTime/1000.))/PVM_GradCalConst;
	phase_enc_max_percent = 100. * (phase_enc_dephase_area/(dephase_grad_dur/1000. - PVM_RiseTime/1000.))/ PVM_GradCalConst;

	

 
}

// void EPItimingRels(void)
// {
// 	tot_EPI_time = phase_mat_size*(PVM_RiseTime + 6e-3 + PVM_SpecAcquisitionTime + 10e-3 + phase_blip_dur + 10e-3);	
// }

void NSegmentsRels(void)
{
  NSegmentsRange();
  backbone();
}

void NSegmentsRange(void)
{
  if(!ParxRelsParHasValue("NSegments"))
    NSegments = 1;
  else
    NSegments = MAX_OF(1,NSegments);
}

void expTypeRels(void)
{
	if (Exp_type == HOT_2D_SLI || Exp_type == SE_SLI || Exp_type == HOT_2D_SLI_ZQSQ || Exp_type == HOT_2D_RARE_ZQSQ  || Exp_type == HOT_2D_RARE_ZQSQ3 || Exp_type == HOT_2D_RARE_ZQSQ2)
		{ 
		PVM_SpecSWH[0] = imaging_bandwidth;
		PVM_SpecMatrix[0] = read_mat_size;
		}
	else PVM_SpecSWH[0] = spectral_bandwidth_f2;

	ParxRelsShowInFile("phase_enc_vector");
	ParxRelsShowInFile("phase_enc_vector2");
	ParxRelsHideInEditor("read_mat_size");
	ParxRelsHideInEditor("phase_mat_size");
	ParxRelsHideInEditor("read_FOV");
	ParxRelsHideInEditor("phase_FOV");
	ParxRelsHideInEditor("mock_spat_enc_onoff");
	ParxRelsHideInEditor("dur_mock_real");
	ParxRelsHideInEditor("CoherenceOrder");
	ParxRelsHideInEditor("mm");
	ParxRelsHideInEditor("nn");
	ParxRelsMakeNonEditable("nn");
	ParxRelsHideInEditor("TE_ms");
	ParxRelsHideInEditor("t1");
	ParxRelsHideInEditor("tau");
	ParxRelsHideInEditor("tau_min");
	ParxRelsHideInEditor("tau_max");
	ParxRelsHideInEditor("tau_inc");
	ParxRelsHideInEditor("t2");
	ParxRelsHideInEditor("spectral_bandwidth_f2");
	ParxRelsHideInEditor("dephase_grad_dur");
	ParxRelsHideInEditor("num_echoes");
	ParxRelsHideInEditor("time_bw_rfc_pulses");
	ParxRelsHideInEditor("min_time_bw_rfc_pulses");
	switch(Exp_type)
		{
		case CRAZED_2D:
			ParxRelsHideInEditor("t1");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsHideInEditor("mm");
			ParxRelsHideInEditor("nn");
			ParxRelsHideInEditor("TE_ms");
			ParxRelsHideInEditor("tau");
			ParxRelsHideInEditor("PhaseCycleOnOff");
			ParxRelsHideInEditor("read_mat_size");
			ParxRelsHideInEditor("phase_mat_size");
			ParxRelsHideInEditor("read_FOV");
			ParxRelsHideInEditor("phase_FOV");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("dephase_grad_dur");
			PVM_NRepetitions = tau_inc;
		break;
		case CRAZED:

			ParxRelsShowInEditor("t1");
			ParxRelsHideInEditor("tau_min");
			ParxRelsHideInEditor("tau_max");
			ParxRelsHideInEditor("tau_inc");
			ParxRelsHideInEditor("read_mat_size");
			ParxRelsHideInEditor("phase_mat_size");
			ParxRelsHideInEditor("read_FOV");
			ParxRelsHideInEditor("phase_FOV");
			ParxRelsHideInEditor("mm");
			ParxRelsHideInEditor("nn");
			ParxRelsHideInEditor("TE_ms");
			ParxRelsHideInEditor("tau");
			ParxRelsHideInEditor("PhaseCycleOnOff");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("dephase_grad_dur");
			PVM_NRepetitions = 1;
		break;
		case HOT:	
	// 		PVM_NRepetitions = 1;
			ParxRelsShowInEditor("t1");
			ParxRelsShowInEditor("tau");
			ParxRelsHideInEditor("tau_min");
			ParxRelsHideInEditor("tau_max");
			ParxRelsHideInEditor("tau_inc");
			ParxRelsHideInEditor("t2");
			ParxRelsHideInEditor("CoherenceOrder");
			ParxRelsHideInEditor("read_mat_size");
			ParxRelsHideInEditor("phase_mat_size");
			ParxRelsHideInEditor("read_FOV");
			ParxRelsHideInEditor("phase_FOV");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsMakeNonEditable("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("PhaseCycleOnOff");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("dephase_grad_dur");
		break;
		case HOT_2D:
			PVM_NRepetitions = tau_inc*exp_reps;
			ParxRelsShowInEditor("t1");
			ParxRelsHideInEditor("tau");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsHideInEditor("t2");
			ParxRelsHideInEditor("CoherenceOrder");
			ParxRelsHideInEditor("read_mat_size");
			ParxRelsHideInEditor("phase_mat_size");
			ParxRelsHideInEditor("read_FOV");
			ParxRelsHideInEditor("phase_FOV");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsMakeNonEditable("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("PhaseCycleOnOff");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("dephase_grad_dur");
		break;
		case HOT_2D_1win:
			PVM_NRepetitions = tau_inc*exp_reps;
			ParxRelsShowInEditor("t1");
			ParxRelsHideInEditor("tau");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsHideInEditor("t2");
			ParxRelsHideInEditor("CoherenceOrder");
			ParxRelsHideInEditor("read_mat_size");
			ParxRelsHideInEditor("phase_mat_size");
			ParxRelsHideInEditor("read_FOV");
			ParxRelsHideInEditor("phase_FOV");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsMakeNonEditable("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("PhaseCycleOnOff");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("dephase_grad_dur");
			phase_mat_size = 1;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;
		break;
		case HOT_2D_SLI:
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsHideInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("CoherenceOrder");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsMakeNonEditable("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsHideInEditor("tau");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsHideInEditor("t2");
			ParxRelsHideInEditor("spectral_bandwidth_f2");
			ParxRelsShowInEditor("dephase_grad_dur");
			PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc;
			DB_MSG(("PVM_NRepetitions %f",(double)PVM_NRepetitions));
		break;
		case HOT_2D_SLI_ZQSQ:
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsShowInEditor("mock_spat_enc_onoff");
			ParxRelsHideInEditor("dur_mock_real");
			ParxRelsHideInEditor("CoherenceOrder");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsMakeNonEditable("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsHideInEditor("tau");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsHideInEditor("t2");
			ParxRelsHideInEditor("spectral_bandwidth_f2");
			ParxRelsShowInEditor("dephase_grad_dur");
			PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;
			DB_MSG(("PVM_NRepetitions %f",(double)PVM_NRepetitions));
		break;
		case SE_SLI:
			PVM_NRepetitions = exp_reps * phase_mat_size;
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsShowInEditor("mock_spat_enc_onoff");
			ParxRelsShowInEditor("dur_mock_real");
			ParxRelsShowInEditor("dephase_grad_dur");
		break;
		case HOT_2D_RARE_ZQSQ:
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsShowInEditor("mock_spat_enc_onoff");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsShowInEditor("dephase_grad_dur");
			ParxRelsShowInEditor("num_echoes");
			ParxRelsShowInEditor("num_echoes_SQ");
			ParxRelsShowInEditor("time_bw_rfc_pulses");
			ParxRelsShowInEditor("min_time_bw_rfc_pulses");
			if (RARE_mode == one_image) PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc / num_echoes;
			else PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;
		case HOT_2D_RARE_ZQSQ3:
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsShowInEditor("mock_spat_enc_onoff");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsShowInEditor("dephase_grad_dur");
			ParxRelsShowInEditor("num_echoes");
			ParxRelsShowInEditor("num_echoes_SQ");
			ParxRelsShowInEditor("time_bw_rfc_pulses");
			ParxRelsShowInEditor("min_time_bw_rfc_pulses");
			if (RARE_mode == one_image) PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc / num_echoes;
			else PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;
			num_echoes_SQ=1;
		break;
		case HOT_2D_RARE_ZQSQ2:
			ParxRelsShowInEditor("read_mat_size");
			ParxRelsShowInEditor("phase_mat_size");
			ParxRelsShowInEditor("read_FOV");
			ParxRelsShowInEditor("phase_FOV");
			ParxRelsShowInEditor("mock_spat_enc_onoff");
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsShowInEditor("dephase_grad_dur");
			ParxRelsShowInEditor("num_echoes");
			ParxRelsHideInEditor("num_echoes_SQ");
			ParxRelsShowInEditor("time_bw_rfc_pulses");
			ParxRelsShowInEditor("min_time_bw_rfc_pulses");
			if (RARE_mode == one_image) PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc / num_echoes;
			else PVM_NRepetitions = exp_reps * phase_mat_size *  tau_inc;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;

		break;
		case HOT_2D_1win_PRESS:
			ParxRelsShowInEditor("mm");
			ParxRelsShowInEditor("nn");
			ParxRelsShowInEditor("TE_ms");
			ParxRelsShowInEditor("t1");
			ParxRelsShowInEditor("tau_min");
			ParxRelsShowInEditor("tau_max");
			ParxRelsShowInEditor("tau_inc");
			ParxRelsShowInEditor("dephase_grad_dur");
			PVM_NRepetitions = exp_reps * tau_inc;
			if (meas_rec_baseline_OnOff == On) PVM_NRepetitions++;
		default:	break;
		}
	if (tau_inc <= 4) ParxRelsShowInEditor("ACQ_vd_list");
	else ParxRelsHideInEditor("ACQ_vd_list");
		
}

// void phaseVectRels(void)
// {
// 	double phase_enc_increment = 0.;
// 	PARX_change_dims("phase_enc_vector",phase_mat_size);
// 	phase_enc_increment = 2.*phase_enc_max_percent/double(phase_mat_size - 1);
// 	if (phase_mat_size > 1)
// 	{
// 		for (int i = 0;i < phase_mat_size;i = i+1)
// 		{
// 			phase_enc_vector[i] = (-phase_enc_max_percent + (double)i*phase_enc_increment)/100.;
// 		}
// 	}
// 	else phase_enc_vector[0] = 0;
// 	backbone;
// }

void phaseVectRelsNB(void)
{
	int num_exitations_per_image = phase_mat_size/num_echoes;
	int first_echo_index_min,first_echo_index_max,ii;
	double phase_enc_increment = 0.;

	if (cal_scan_onoff == On) phase_mat_size = num_echoes;
	PARX_change_dims("phase_enc_vector",phase_mat_size);
	PARX_change_dims("phase_enc_vector2",phase_mat_size);
	PARX_change_dims("phase_enc_vector_index",phase_mat_size);
	phase_enc_increment = 2.*phase_enc_max_percent/double(phase_mat_size - 1);

	//DBG_MSG(("1) phase_mat_loop_size is %d",phase_mat_loop_size));
	if (cal_scan_onoff == On){
		phase_mat_loop_size = 1; 
		for (int i = 0;i < phase_mat_size;i++) phase_enc_vector[i] = 0.;
		for (int i = 0;i < phase_mat_size;i++) phase_enc_vector2[i] = 0.;
		}
	else{

		if ((phase_mat_size > 1) & ((RARE_mode == none) || (RARE_mode == N_images)))
		{
			//DBG_MSG(("2) phase_mat_loop_size is %d",phase_mat_loop_size));
			phase_mat_loop_size = phase_mat_size;
			for (int i = 0;i < phase_mat_size;i = i+1)
			{
				phase_enc_vector[i] = phase_enc_vector2[i] = (-phase_enc_max_percent + (double)i*phase_enc_increment)/100.;
			}
		}
		else if ((phase_mat_size > 1) & (RARE_mode == one_image))
		{	
			phase_mat_loop_size = phase_mat_size/num_echoes;
			switch (RARE_encoding_scheme)
			{
				//This k-space trajectory starts in the center of ky and progresses outward with successive echoes
				case center_to_periphery:
					first_echo_index_min = (phase_mat_size - phase_mat_size/num_echoes)/2;
					first_echo_index_max = (phase_mat_size - phase_mat_size/num_echoes)/2 + num_exitations_per_image;
					ii = 0;
					for (int first_echo_index = first_echo_index_min; first_echo_index < first_echo_index_max;  first_echo_index++)
						{
						phase_enc_vector_index[ii] = first_echo_index;
						ii++;
						for (int echo_num = 1;echo_num<num_echoes;echo_num++)
							{
							phase_enc_vector_index[ii] = (phase_enc_vector_index[ii-1]  +num_exitations_per_image*echo_num*(int)pow((double)-1,(double)(echo_num+1)))%phase_mat_size;
							ii++;
							}
						}
					for (int pe_num = 0;pe_num < phase_mat_size; pe_num++)
						{
						phase_enc_vector[pe_num] = phase_enc_vector2[pe_num] = (-phase_enc_max_percent + (double)phase_enc_vector_index[pe_num]*phase_enc_increment)/100.;
						}
					break;
				//standard k-space trajectory: from one edge to the other, one step at a time
				case standard:
					for (int i = 0;i < phase_mat_size;i = i+1)
					{
						phase_enc_vector[i] = phase_enc_vector2[i] = (-phase_enc_max_percent + (double)i*phase_enc_increment)/100.;
					}
					break;
				//typical RARE encoding: from one edge to the other, but increment by "num_echoes" k-space steps
				case interleaved:
					ii = 0;
					for (int ex_num = 0;ex_num<phase_mat_size/num_echoes;ex_num++)
					{
						for (int rare_echo_num = 0;rare_echo_num<num_echoes;rare_echo_num++)
						{
							phase_enc_vector_index[ii] = ex_num + rare_echo_num * phase_mat_size / num_echoes;
							ii++;
						}	
					}
					for (int pe_num = 0;pe_num < phase_mat_size; pe_num++)
						{
						phase_enc_vector[pe_num] = phase_enc_vector2[pe_num] = (-phase_enc_max_percent + (double)phase_enc_vector_index[pe_num]*phase_enc_increment)/100.;
						}
					break;
				default: break;
			}
		}
		else{
			phase_enc_vector[0] = phase_enc_vector2[0] = 0;
			phase_mat_loop_size = phase_mat_size;
		}
	}
}

void tau_incRels(void)
{
	if ((tau_inc%2 == 1) && (tau_inc > 4)) tau_inc++;
	backbone();
}

void subrRelations(void)
{
  //compensate for the shift of the acquisition window 
	double dig_filt_comp_delay;

	if (digfiltcompOnOff == On) dig_filt_comp_delay = PVM_DigGroupDel; else dig_filt_comp_delay = 0.; 

	spat_encode_subr_len_ms = dephase_grad_dur + PVM_RiseTime + 32.5e-3 + (PVM_SpecAcquisitionTime) + 32.5e-3 + PVM_RiseTime + dephase_grad_dur;

	spat_encode_subr_acq_center_ms = dephase_grad_dur + PVM_RiseTime + 32.5e-3 + (PVM_SpecAcquisitionTime)/2. - dig_filt_comp_delay/2.;
	//spat_encode_subr_acq_center_ms = PVM_DigGroupDel/2. + dephase_grad_dur + PVM_RiseTime + 6e-3 + PVM_SpecAcquisitionTime/2.;

	ref_subr_len_ms = grad_spoil_dur + RMD_grad_stabilization_time_ms + BIRPulse.Length + (RMD_grad_stabilization_time_ms-slice_sel_grad_adjust*1e-3) + grad_spoil_dur;

	spat_encode_zqsq_len_ms = spat_encode_subr_len_ms + t1+tau_min;
}

void rareRelations(void)
{
	double dig_filt_comp_delay;

	if (!(Exp_type == HOT_2D_RARE_ZQSQ || Exp_type == HOT_2D_RARE_ZQSQ2 || Exp_type == HOT_2D_RARE_ZQSQ3))
		{
		RARE_mode = none;
		num_echoes = 1;
		}

	if (digfiltcompOnOff == On) dig_filt_comp_delay = PVM_DigGroupDel; else dig_filt_comp_delay = 0.; 

	if ((RARE_mode == N_images)&&(Exp_type==HOT_2D_RARE_ZQSQ2)){
		min_time_bw_rfc_pulses = spat_encode_zqsq_len_ms+ ref_subr_len_ms + 0.01; //0.01ms is for incPEifOneImg subroutine
	}
	else if ((RARE_mode == N_images)&&((Exp_type==HOT_2D_RARE_ZQSQ)||(Exp_type==HOT_2D_RARE_ZQSQ3))){
		min_time_bw_rfc_pulses = spat_encode_subr_len_ms + ref_subr_len_ms + MAX_OF(0.5*PVM_DigGroupDel,1e-3);
	}
	else min_time_bw_rfc_pulses = spat_encode_zqsq_len_ms+ ref_subr_len_ms + 0.01;
	//else{

	//}
	//Make sure npe is not smaller than number of echoes, and that they are devisible

	
// 	if (RARE_mode == one_image)
// 	{
// 		phase_mat_size = MAX_OF(phase_mat_size,num_echoes);
// 		phase_mat_size = phase_mat_size - phase_mat_size%num_echoes;
// 	}

	if (time_bw_rfc_pulses < min_time_bw_rfc_pulses) time_bw_rfc_pulses = min_time_bw_rfc_pulses;
	if (RARE_mode==one_image)
	{
		num_echoes = num_echoes + num_echoes%2;
	}
	num_echoes_minus_1 = num_echoes - 1;
	half_num_echoes = num_echoes/2;

	if (Exp_type == HOT_2D_RARE_ZQSQ2) num_echoes_SQ=num_echoes;


}

void pressRelations(void)
{
	if (Exp_type == HOT_2D_1win_PRESS){
		slice_offset_mm = hf_offset_mm;
		hf_offset_hz = slice_offset_mm*ExcPulse.Bandwidth/SliceThickness;

	}
}
/****************************************************************/
/*		E N D   O F   F I L E				*/
/****************************************************************/
