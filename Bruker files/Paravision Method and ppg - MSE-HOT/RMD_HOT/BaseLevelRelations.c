/****************************************************************
 *
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/BaseLevelRelations.c,v $
 *
 *
 * Copyright (c) 2001 - 2009
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 * $Id: BaseLevelRelations.c,v 1.22.2.2 2009/09/09 09:25:16 mawi Exp $
 *
 ****************************************************************/
static const char resid[] = "$Id: BaseLevelRelations.c,v 1.22.2.2 2009/09/09 09:25:16 mawi Exp $ (C) 2002 - 2009 Bruker BioSpin MRI GmbH";

#define DEBUG		1
#define DB_MODULE	1
#define DB_LINE_NR	0


/****************************************************************/
/****************************************************************/
/*		I N T E R F A C E   S E C T I O N		*/
/****************************************************************/


/****************************************************************/

/****************************************************************/
/*		I N C L U D E   F I L E S			*/
/****************************************************************/

#include "method.h"



void SetBaseLevelParam( void )
{

  DB_MSG(("Entering SetBaseLevelParam()"));

  SetBasicParameters();

  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: Error in function call!");
    return;
  }
  
  SetMachineParameters();
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: In function call!");
    return;
  }
  
  
  SetFrequencyParameters();
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: In function call!");
    return;
  }
  
  SetPpgParameters();
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: In function call!");
    return;
  }
  
  SetGradientParameters();
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: In function call!");
    return;
  }
  
  SetInfoParameters();
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBaseLevelParam: In function call!");
    return;
  }


  /* 
   *  settings for multi channel acquisition 
   */

  if(Yes==ATB_SetMultiRec())
  {
    ATB_SetPulprog("RMD_HOT.4ch");
  }

  if(PVM_EncUseMultiRec==Yes)
  {
    int nrec,i;
    nrec = (int)PARX_get_dim("ACQ_ReceiverSelect",1);

    ACQ_ReceiverSelect[0] = Yes;
    for(i=1;i<nrec;i++)
      ACQ_ReceiverSelect[i]=No; 

    /* Pipeline filter for data combination */
    ACQ_user_filter = Yes;
    ParxRelsParRelations("ACQ_user_filter",Yes);
    strcpy( ACQ_user_filter_name, "Combine_Spec");
    ParxRelsParRelations("ACQ_user_filter_name",Yes);
    ACQ_user_filter_memory = For_one_PE_step;
    ParxRelsParRelations("ACQ_user_filter_memory",Yes);
    ACQ_user_filter_mode = Special;
    ParxRelsParRelations("ACQ_user_filter_mode",Yes);
    ACQ_user_filter_size[0] = ACQ_user_filter_size[1] = 0;
    ACQ_user_filter_size[2] = PVM_EncAvailReceivers;
    ParxRelsParRelations("ACQ_user_filter_size",Yes);
  }
  else
  {
    ACQ_user_filter = No;
    ParxRelsParRelations("ACQ_user_filter",Yes);
  }
//   if (Exp_type == SE_EPI) ATB_EpiSetBaseLevel();
  
  DB_MSG(("Exiting SetBaseLevelParam"));
  
}





void SetBasicParameters( void )
{
  int specDim;
  int dim;
  
  DB_MSG(("Entering SetBasicParameters()"));
  
  /* ACQ_dim */
  
  specDim = PTB_GetSpecDim();
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  ACQ_dim = specDim;
  ParxRelsParRelations("ACQ_dim",Yes);
  
  /* ACQ_dim_desc */
  
  /*ATB_SetAcqDimDesc( specDim, spatDim, NULL );  */
  for(dim=0; dim<ACQ_dim; dim++)
    ACQ_dim_desc[dim] = Spectroscopic;
  ParxRelsParRelations("ACQ_dim_desc", Yes);
  
  /* ACQ_size */
  
  
  ACQ_size[0] =  2*PVM_SpecMatrix[0];
  
  for(dim=1; dim<ACQ_dim; dim++)
    ACQ_size[dim] = PVM_SpecMatrix[dim];
  
  ParxRelsParRelations("ACQ_size", Yes);
  
  /* NSLICES */
  
  ATB_SetNSlices( 1 );
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  /* NR */
  if (Exp_type == CRAZED_2D) ATB_SetNR( tau_inc);
  else ATB_SetNR(MAX_OF(1,PVM_NRepetitions));

  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  /* NI */
  if ((Exp_type == HOT) || (Exp_type == HOT_2D) || (Exp_type == HOT_2D_SLI) || (Exp_type == HOT_2D_SLI_ZQSQ)) ATB_SetNI(2);
  else if (Exp_type == HOT_2D_RARE_ZQSQ || Exp_type == HOT_2D_RARE_ZQSQ3) ATB_SetNI(num_echoes+num_echoes_SQ);
  else if (Exp_type == HOT_2D_RARE_ZQSQ2) ATB_SetNI(2*num_echoes);
  else ATB_SetNI(1);
//   else if (Exp_type == SE_EPI) 
// 	{
// 		int nSlices;
// 		nSlices = GTB_NumberOfSlices( PVM_NSPacks, PVM_SPackArrNSlices );
// 		if( PVM_ErrorDetected == Yes )
// 		{
// 		UT_ReportError("SetBasicParameters: In function call!");
// 		return;
// 		}
// 		
// 		ATB_SetNSlices( nSlices );
// 		if( PVM_ErrorDetected == Yes )
// 		{
// 		UT_ReportError("SetBasicParameters: In function call!");
// 		return;
// 		}
// /*		ATB_SetNI( nSlices * PVM_NEchoImages );*/
// 		ATB_SetNI( phase_mat_size );
// 
// 		if( PVM_ErrorDetected == Yes )
// 		{
// 		UT_ReportError("SetBasicParameters: In function call!");
// 		return;
// 		}

  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  
  /* NA */

  ATB_SetNA( PVM_NAverages );
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  
  /* NAE */
  
  ATB_SetNAE( 1 );
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  
  
  
  /* ACQ_ns */
  
  ACQ_ns_list_size = 1;
  
  dim = PARX_get_dim("ACQ_ns_list",1);
  if( dim != 1 )
  {
    PARX_change_dims( "ACQ_ns_list",1 );
  }
  
  NS = 1;
  ACQ_ns = NS;
  ACQ_ns_list[0] = ACQ_ns;
  
  ParxRelsParRelations("ACQ_ns",Yes);
  
  
  /* NECHOES */
  
  NECHOES = 1;
  
  
  
  /* ACQ_obj_order */
  
  PARX_change_dims("ACQ_obj_order",NI);
  ACQ_obj_order[0] = 0;
  
  
  /* DS */
  
  DS =Ndummy ;
  ACQ_DS_enabled = Yes;
  
  
  ATB_DisableAcqUserFilter();
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  ATB_SetAcqScanSize( One_scan );
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetBasicParameters: In function call!");
    return;
  }
  
  
  DB_MSG(("Exiting SetBasicParameters()"));
}

void SetFrequencyParameters( void )
{
  
  DB_MSG(("Entering SetFrequencyParameters()"));
  
  ATB_SetNuc1(PVM_Nucleus1);
  
  sprintf(NUC2,"off");
  sprintf(NUC3,"off");
  sprintf(NUC4,"off");
  sprintf(NUC5,"off");
  sprintf(NUC6,"off");
  sprintf(NUC7,"off");
  sprintf(NUC8,"off");
  
  ATB_SetNucleus(PVM_Nucleus1);
  
  
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetFrequencyParameters: In function call!");
    return;
  }
  
  ATB_SetRouting();
  
  /* setting of SW_h, DIGMOD, DSPFIRM and AQ_mod */
  ATB_SetDigPars();
  
  ACQ_O1_mode = BF_plus_Offset;
  ParxRelsParRelations("ACQ_O1_mode",Yes);
  
  ACQ_O2_mode = BF_plus_Offset_list;
  ParxRelsParRelations("ACQ_O2_mode",Yes);
  
  ACQ_O3_mode = BF_plus_Offset_list;
  ParxRelsParRelations("ACQ_O3_mode",Yes);

  O1 = 0.0; 
  O2 = 0.0;
  O3 = 0.0;
  O4 = 0.0;
  O5 = 0.0;
  O6 = 0.0;
  O7 = 0.0;
  O8 = 0.0;

  {

//    int OrderList[5] = {0,1,2,3,4};
//    double slice_pulse_offset = 0.;
//   slice_pulse_offset = slice_offset_mm*(RefPulse.Bandwidth/SliceThickness)+I_freq;
//    double OffsetHz[6] = {S_freq,0.0,I_freq,S_freq,slice_pulse_offset,0.0};
//	double OffsetHzZeros[5] = {0.0,0.0,0.0,0.0,0.0};
//	double OffsetHz[5] = {0.,rl_offset_hz,0.,ap_offset_hz,0.};
     double OffsetHz[1] = {0.0};
	int OrderList[1] = {0};

// 	int OrderList2[1] = {0};
// 	double OffsetHz2[1] = {0.};
// 	OffsetHz2[0] = I_freq;
// 	double OffsetHz3[1] = {0.};
// 	OffsetHz3[0] = S_freq;
//     OffsetHz3[0] = slice_offset_mm*(RefPulse.Bandwidth/SliceThickness);
//	if (Exp_type == HOT_2D_1win_PRESS)
	ATB_SetAcqO1List(1,
		      OrderList,
		      OffsetHz);
//	else ATB_SetAcqO1List(5,
//		      OrderList,
//		      OffsetHzZeros );
//     ATB_SetAcqO1List(1,
// 		      OrderList2,
// 		      OffsetHz );
//     ATB_SetAcqO2List(1,
// 			OrderList2,
// 			OffsetHz2);
//     ATB_SetAcqO3List(1,
// 			OrderList2,
// 			OffsetHz3);

//     ATB_SetAcqO1BList( 1,
// 		       OrderList2,
// 		       OffsetHz);
    
    if( PVM_ErrorDetected == Yes )
    {
      UT_ReportError("SetFrequencyParameters: In function call!");
      return;
    }
    
  }
  
  DB_MSG(("Exiting SetFrequencyParameters()"));
}

void SetGradientParameters( void )
{
 
  DB_MSG(("Entering SetGradientParameters()"));
  
      double rfc_slice_trim = 0.;
    double spat_enc;
  ATB_SetAcqPhaseFactor( 1 );
  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetGradientParameters: In function call!");
    return;
  }
  
  { 
    double GradOrient[3][3] = {{1.0, 0.0, 0.0}, 
                               {0.0, 1.0, 0.0},
                               {0.0, 0.0, 1.0}};
    int ObjOrderList[1] = {0},
      npack = 1,
        nslperpack[1] = {1};



      
      ATB_SetAcqGradMatrix( npack, nslperpack,
			    &GradOrient,
			    ObjOrderList );

  }

  rfc_slice_trim = 100.*(RefPulse.Bandwidth/SliceThickness)/PVM_GradCalConst;


  if(Exp_type == CRAZED || Exp_type == CRAZED_2D)
  ATB_SetAcqTrims( 3,
		   FirstMQFilterGradientTrim,	//t0
		   -1.*SecondMQFilterGradientTrim,//t1
			rfc_slice_trim); //t2
  else if (Exp_type == HOT || Exp_type == HOT_2D)
	ATB_SetAcqTrims(5,
			FirstMQFilterGradientTrim,	//t0
			MQFilterGradientTrim_n,//t1
			MQFilterGradientTrim2m,//t2
			2.*MQFilterGradientTrim_mpn,//t3
			rfc_slice_trim				//t4
			);
else if (Exp_type == HOT_2D_1win)
		ATB_SetAcqTrims(4,
			FirstMQFilterGradientTrim,		//t0
			MQFilterGradientTrim_n,			//t1
			MQFilterGradientTrim2m,			//t2
			rfc_slice_trim				//t3
			);
else if (Exp_type == HOT_2D_SLI || Exp_type == SE_SLI)
		ATB_SetAcqTrims(11,
			FirstMQFilterGradientTrim,		//t0
			MQFilterGradientTrim_n,			//t1
			MQFilterGradientTrim2m,			//t2
			2.*MQFilterGradientTrim_mpn,		//t3
			rfc_slice_trim,				//t4
			grad_spoil_percent,			//t5
			grad_spoil_mod_read_percent,		//t6
			-freq_enc_dephase_percent,		//t7
			freq_enc_grad_percent,			//t8
			-freq_enc_rephase_percent,		//t9
			0.					//t10
			);
else if ((Exp_type == HOT_2D_SLI_ZQSQ) || (Exp_type == HOT_2D_RARE_ZQSQ) || (Exp_type == HOT_2D_RARE_ZQSQ2)) {
		if ((mock_spat_enc_onoff == Off)||(cal_scan_onoff == On)) spat_enc = 0.;
		else spat_enc = 1.;
		ATB_SetAcqTrims(14,
			FirstMQFilterGradientTrim,		//t0
			MQFilterGradientTrim_n,			//t1
			MQFilterGradientTrim2m,			//t2
			MQFilterGradientTrim_mpn,		//t3 - selects I+ and I- coherences
			rfc_slice_trim,				//t4
			grad_spoil_percent,			//t5
			grad_spoil_mod_read_percent,		//t6
			-spat_enc*freq_enc_dephase_percent,	//t7
			spat_enc*freq_enc_grad_percent,		//t8
			-spat_enc*freq_enc_rephase_percent,	//t9
			-freq_enc_dephase_percent,		//t10
			freq_enc_grad_percent,			//t11
			-freq_enc_rephase_percent,		//t12
			-grad_spoil_percent			//t13
			);
	}

else if (Exp_type == HOT_2D_RARE_ZQSQ3) {
		if ((mock_spat_enc_onoff == Off)||(cal_scan_onoff == On)) spat_enc = 0.;
		else spat_enc = 1.;
		ATB_SetAcqTrims(14,
			FirstMQFilterGradientTrim,		//t0
			MQFilterGradientTrim_n,			//t1
			MQFilterGradientTrim_mln,			//t2
			MQFilterGradientTrim_mpn,		//t3 - selects I+ and I- coherences
			rfc_slice_trim,				//t4
			grad_spoil_percent,			//t5
			grad_spoil_mod_read_percent,		//t6
			-spat_enc*freq_enc_dephase_percent,	//t7
			spat_enc*freq_enc_grad_percent,		//t8
			-spat_enc*freq_enc_rephase_percent,	//t9
			-freq_enc_dephase_percent,		//t10
			freq_enc_grad_percent,			//t11
			-freq_enc_rephase_percent,		//t12
			-grad_spoil_percent			//t13
			);
	}
else if (Exp_type == HOT_2D_1win_PRESS)
		ATB_SetAcqTrims(7,
			FirstMQFilterGradientTrim,		//t0
			MQFilterGradientTrim_n,			//t1
			MQFilterGradientTrim2m,			//t2
			MQFilterGradientTrim_mpn,		//t3 - selects I+ and I- coherences
			rfc_slice_trim,				//t4
			grad_spoil_percent,			//t5
			0.			//t6
			);

  if( PVM_ErrorDetected == Yes )
  {
    UT_ReportError("SetGradientParameters: In function call!");
    return;
  }
  
  
  ACQ_scaling_read  = 1.0;
  ACQ_scaling_phase = 1.0;
  ACQ_scaling_slice = 1.0;
  
  ACQ_rare_factor = 1;
  
  ACQ_grad_str_X = 0.0;
  ACQ_grad_str_Y = 0.0;
  ACQ_grad_str_Z = 0.0;
  
  
  strcpy(GRDPROG, "");
  
  
    if( PVM_ErrorDetected == Yes )
    {
      UT_ReportError("SetGradientParameters: In function call!");
      return;
    }



  DB_MSG(("Exiting SetGradientParameters()"));
}

void SetInfoParameters( void )
{
  
  DB_MSG(("Entering SetInfoParameters()"));
  
  // initialize ACQ_n_echo_images ACQ_echo_descr
  //            ACQ_n_movie_frames ACQ_movie_descr
  ATB_ResetEchoDescr();
  ATB_ResetMovieDescr();
  
  ACQ_flip_angle = PVM_ExcPulseAngle;
  
  PARX_change_dims("ACQ_echo_time",1);
  ACQ_echo_time[0] = PVM_EchoTime;
  
  PARX_change_dims("ACQ_inter_echo_time",1);
  ACQ_inter_echo_time[0] = PVM_EchoTime;
  
  PARX_change_dims("ACQ_repetition_time",1);
  ACQ_repetition_time[0] = PVM_RepetitionTime;
  
  PARX_change_dims("ACQ_recov_time",1);
  ACQ_recov_time[0] =  PVM_RepetitionTime - ExcPulse.Length;
  
  PARX_change_dims("ACQ_inversion_time",1);
  ACQ_inversion_time[0] = PVM_InversionTime;
  
  ATB_SetAcqPatientPosition();
  
  ATB_SetAcqMethod();
  
  DB_MSG(("Exiting SetInfoParameters()"));
  
}

void SetMachineParameters( void )
{
  DB_MSG(("Entering SetMachineParameters()"));
  
  
  if( ParxRelsParHasValue("ACQ_word_size") == No )
  {
    ACQ_word_size = _32_BIT;
  }
  
  DE = (DE < 6.0) ? 6.0:DE;
  
  DEOSC = (PVM_SpecAcquisitionTime + 
	   PVM_RepetitionTime      - 
	   PVM_MinRepetitionTime   + 1.0   )*1000.0;
  ACQ_scan_shift = 0;
  ParxRelsParRelations("ACQ_scan_shift",Yes);
  
  PAPS = QP;
  
  ACQ_BF_enable = Yes;
  
  DB_MSG(("Exiting SetMachineParameters"));
}

void SetPpgParameters( void )
{
  DB_MSG(("Entering SetPpgParameters()"));

  
  
  if( ParxRelsParHasValue("ACQ_trigger_enable") == No )
  {
    ACQ_trigger_enable = No;
  }
  
  if( ParxRelsParHasValue("ACQ_trigger_reference") == No )
  {
    ACQ_trigger_reference[0] = '\0';
  }
  
  if( ParxRelsParHasValue("ACQ_trigger_delay") == No )
  {
    ACQ_trigger_delay = 0;
  }
  
  ParxRelsParRelations("ACQ_trigger_reference",Yes);
  
  //commented out by RMD
//   ACQ_vd_list_size=1;
//   PARX_change_dims("ACQ_vd_list",1);
//   ACQ_vd_list[0] = 1e-6;
//   ParxRelsParRelations("ACQ_vd_list",Yes);
  
  ACQ_vp_list_size=1;
  PARX_change_dims("ACQ_vp_list",1);
  ACQ_vp_list[0] = 1e-6;
  ParxRelsParRelations("ACQ_vp_list",Yes);


  if (Exp_type == CRAZED)  ATB_SetPulprog("RMD_HOT_CRAZED.ppg");
  else if (Exp_type == CRAZED_2D) ATB_SetPulprog("RMD_HOT_CRAZED_2D.ppg");
  else if (Exp_type == HOT_2D) ATB_SetPulprog("RMD_HOT_2D.ppg");
  else if (Exp_type == HOT) ATB_SetPulprog("RMD_HOT.ppg");
  else if (Exp_type == HOT_2D_1win) ATB_SetPulprog("RMD_HOT_2D_1win.ppg");
  else if (Exp_type == HOT_2D_SLI) ATB_SetPulprog("RMD_HOT_2D_SLI.ppg");
  else if (Exp_type == HOT_2D_SLI_ZQSQ) ATB_SetPulprog("RMD_HOT_2D_SLI_ZQSQ.ppg");
  else if (Exp_type == SE_SLI) ATB_SetPulprog("RMD_SE_SLI.ppg");
  else if (Exp_type == HOT_2D_RARE_ZQSQ) ATB_SetPulprog("RMD_HOT_2D_RARE_ZQSQ.ppg");
  else if (Exp_type == HOT_2D_RARE_ZQSQ2) ATB_SetPulprog("RMD_HOT_2D_RARE_ZQSQ2.ppg");
  else if (Exp_type == HOT_2D_RARE_ZQSQ3) ATB_SetPulprog("RMD_HOT_2D_RARE_ZQSQ3.ppg");
  else if (Exp_type == HOT_2D_1win_PRESS) ATB_SetPulprog("RMD_HOT_2D_1win_PRESS.ppg");



  D[0] = PVM_RepetitionTime/1000. - (2.*tau_min + TE_ms)/1000.; //t1 + tau_min + TE_ms + tau_min - t1
  //D[1]  = ((PVM_EchoTime - minTE1)/2.0 + PVM_InterGradientWaitTime) / 1000.0;
  /* 0.04 is duration of ADC_END_4ch */
  //D[2]  = ((PVM_EchoTime - minTE2)/2.0 + 0.04) / 1000.0; 
  D[2] = MAX_OF(0.5*PVM_DigGroupDel/1000.,1e-6);
  D[3]  = RMD_grad_stabilization_time_ms / 1000.0;
  D[3]  = MAX_OF(D[3], 0.0);  
  D[4]  = (PVM_RiseTime+RMD_ramp_time_adjust) / 1000.0;
  D[5]  = (grad_spoil_dur - 2.0*PVM_RiseTime)/1000.;
  D[6]  = (PVM_2dPhaseGradientTime - 2.0*PVM_RiseTime)/1000.0;
  D[7]  = (phase_blip_dur - 2.0*PVM_RiseTime)/1000.0;
  D[11] = (PVM_ReadDephaseTime - 2.0*PVM_RiseTime) / 1000.0;
  D[8] = CFG_AmplifierEnable()/1000.0; 
  //D[9] = (RepetitionSpoilerDuration - 2*PVM_RiseTime)/1000.0;
  D[12] = (MQFilterGradientDuration-2.*PVM_RiseTime)/1000.0; //Duration of MQ Filter gradient pulses
  D[13] = t1/1000.0 - (0.5*ExcPulse.Length/1000.0 + D[4] + D[12] + D[4] + D[4] + -0.5*MixPulse.Length/1000.0); //residual t1 delay
  D[14] = t2/1000.0 - (0.5*MixPulse.Length/1000.0 + D[4] + D[12] + D[4] + D[4] + -0.5*RefPulse.Length/1000.0);  //residual t2 delay
  D[15] = t2/1000.0; //delay until acquisition

//////////////////Deays for HOT
  D[20] = t1/1000. - (0.5*ExcPulse.Length/1000. + D[8] + D[4] + D[12] + D[4] + 10e-6 + D[8] + 0.5*RefPulseSel.Length/1000.);
//DB_MSG(("D[20]: %f t1/1000.: %f 0.5*ExcPulse.Length/1000.: %f D[4]: %f  D[12]: %f  0.5*RefPulseSel.Length/1000.: %f",D[20],t1/1000.,0.5*ExcPulse.Length/1000.,D[4],D[12],0.5*RefPulseSel.Length/1000.));
  D[21] = tau/1000. - (0.5*RefPulseSel.Length/1000. + D[4] + D[12] + D[4] + D[4] + 0.5*ExcPulseSel.Length/1000.);
  D[22] = 0.5 * TE_ms/1000. - (0.5*ExcPulseSel.Length/1000. + D[4] + D[4] + D[12] + D[4] + D[4] + D[5] + D[4] + D[4] + 0.5*RefPulse.Length/1000.);
  D[23] = (0.5 * TE_ms/1000. - 2.*t1/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + 6e-6 + 0.5 * PVM_SpecAcquisitionTime/1000.);
//   D[24] = 2.*t1/1000. - (0.5 * PVM_SpecAcquisitionTime/1000. + 5./1000. + 10.e-6 + D[4] + 0.5*D[12]);
  D[24] = (0.5 * TE_ms/1000. + 2.*tau_min/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + D[23] + 6.e-6 + PVM_SpecAcquisitionTime/1000. + 0.01/1000. + D[4] + D[12] + D[4] + 6.e-6 + 0.5 * PVM_SpecAcquisitionTime/1000.);
  D[25] = 2.*tau/1000.- (0.5*D[12] +D[4] + 1./1000.+ 6.e-6 + (0.5 -double(PVM_DigShift)/double(PVM_SpecMatrix[0])) * PVM_SpecAcquisitionTime/1000.);
  D[26] = tau_min/1000. - (0.5*RefPulseSel.Length/1000. + D[8] + D[4] + D[12] + D[4] + D[8] + 0.5*ExcPulseSel.Length/1000.);
//   D[27] = (0.5 * TE_ms/1000. + 2.*tau_min/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + D[23] + /*6.e-6*/ 
// 	+ PVM_SpecAcquisitionTime/1000. + 5./1000. + .01 + D[4] + D[12] + D[4] + /*6.e-6*/ + 0.5 * PVM_SpecAcquisitionTime/1000.);

/////////////////Delay for HOT 1 window : increment tau and read coherence that was zero quantum during tau
//   D[28] = (0.5 * TE_ms/1000. + 2.*tau_min/1000.) - (0.5*RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + 1e-3 + 6e-6 + 0.5 * PVM_SpecAcquisitionTime/1000.);
  //Acquisition starts IN MIDDLE OF ECHO!!!! for this experiment.  This is to make an apples to apples comparission of iZQC to SQC linewidth
  D[28] = (0.5 * TE_ms/1000. - 2.*t1/1000.) - (0.5*RefPulse.Length/1000. + D[4] + D[4] + D[4] + D[5] + D[4]);
  //D[29] = (PVM_ReadDephaseTime - 2.0*PVM_RiseTime) / 1000.0; //Duration of read dephase grad for EPI
  D[29] = (MQFilterGradientDuration2m-2.*PVM_RiseTime)/1000.0; //Duration of MQ Filter gradient pulses
  D[30] = 0.5*TE_ms/1000. - (0.5*ExcPulseSel.Length/1000. + D[8]+ D[4] + D[29] + D[4] + D[4] + D[5] + D[4] + 10e-6 + D[4] + D[4] + 0.5*RefPulse.Length/1000.);
  D[31] = 0;

/////////////Delays for MSE single line imaging (SLI)

  D[32] = (0.5 * TE_ms/1000.) - (0.5*ExcPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + D[4] + 0.5*RefPulse.Length/1000.);
  D[34] = (dephase_grad_dur - 2.*PVM_RiseTime)/1000.;
  D[35] = PVM_SpecAcquisitionTime/1000.;
  //D[36] = dur_mock_real/1000. - (0.5*PVM_SpecAcquisitionTime/1000. + D[4] + D[4] + D[34] + D[4] + D[4] + D[34] + D[4] + D[4] + 0.5*PVM_SpecAcquisitionTime/1000.);  //duration between mock spatial encode and real spatial encode
  D[33] = (0.5 * TE_ms/1000.) - (0.5*RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + D[4] + D[34] + D[4] + D[4] + PVM_SpecAcquisitionTime/1000. + D[4] + D[4] + D[34] + D[4] + D[36] + D[4] + D[34] + D[4] + D[4] + 0.5*PVM_SpecAcquisitionTime/1000.);

///////////Delays for HOT SLI
  //D[37] = (0.5 * TE_ms/1000. - 2.*t1/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[4] + D[5] + D[4]  + D[4] + D[34] + D[4] + D[4] + 16e-6 + 0.5 * PVM_SpecAcquisitionTime/1000. - dig_filt_comp_delay); //replace d23
D[37] = (0.5 * TE_ms/1000. - 2.*t1/1000.) - (0.5 * RefPulse.Length/1000. + (D[3]-slice_sel_grad_adjust*1e-6) + D[4] + D[5] + D[4] + 5E-6 + spat_encode_subr_acq_center_ms/1000.); //replace d23
  D[37]+=te_rfc_adjust_ms/1000.;
  D[38] = (0.5 * TE_ms/1000. + 2.*tau_min/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[5] + D[4] + D[37] + D[4] + D[34] + D[4] + D[4] + 6.e-6 + PVM_SpecAcquisitionTime/1000. + 0.01/1000. + D[4] + D[4] + D[34] + D[4] + D[4] + D[12] + D[4] + D[4] + D[34] + D[4] + D[4] + 6.e-6 + 0.5 * PVM_SpecAcquisitionTime/1000.); //replace d24
  D[43] =  0.5 * TE_ms/1000. - (0.5*ExcPulseSel.Length/1000. + D[4] + D[4] + D[29] + D[4] + D[4] + D[5] + D[4] + D[3] + 0.5*RefPulse.Length/1000.);
//   D[24] = 2.*t1/1000. - (0.5 * PVM_SpecAcquisitionTime/1000. + 5./1000. + 10.e-6 + D[4] + 0.5*D[12]);

///////////////Delays for 2D CRAZED
//t1 delay
D[39] = tau_min/1000. - (0.5*ExcPulse.Length/1000. + D[4] + D[12] + D[4] + D[4]  + 0.5*ExcPulseSel.Length/1000.);
//delay between second and third pulses
D[40] = TE_ms/(2.*1000.) - (0.5*ExcPulseSel.Length/1000. + D[4] + D[5] + D[4] + D[4] + D[4] + 0.5*RefPulse.Length/1000.);
//delay between third pulse and acq
D[41] = TE_ms/(2.*1000.) - (0.5*RefPulse.Length/1000. + D[4] + D[4] + D[4] + D[5] + D[4] + 1e-3 /*+ PVM_DigGroupDel/1000.*/);

/////////////////Delays for HOT_2D_SLI_ZQSQ
//D[42] = (TE_ms/2. + tau_min - t1)/1000. - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[4] + D[5] + D[4] + D[37] + D[4] + D[34] + D[4] + D[4] + 6.e-6 + PVM_SpecAcquisitionTime/1000. + 0.01/1000. + D[4] + D[4] + D[34] + D[4] + D[4] + D[12] + D[4] + D[4] + D[34] + D[4] + D[4] + 6.e-6 + 0.5 * PVM_SpecAcquisitionTime/1000. - dig_filt_comp_delay);
//delay between ZQ and SQ echoes for SLI,RARE,RARE2
D[42] = ((tau_min + t1) - (spat_encode_subr_len_ms + MQFilterGradientDuration))/1000.;

/////////////////Delays for RARE ZQSQ1 accelleration
D[44] = 0.5*(time_bw_rfc_pulses - ref_subr_len_ms - spat_encode_subr_len_ms)/1000.;
D[45] = (0.5*time_bw_rfc_pulses + t1 + tau_min)/1000. - (0.5*ref_subr_len_ms/1000.+D[4]+D[12]+D[4]+spat_encode_subr_acq_center_ms/1000. + D[44]) - 0.5*PVM_DigGroupDel/1000.;

//////////////Delays for PRESS acquisition
D[46] = (0.5 * TE_ms/1000. - 2.*t1/1000.) - (0.5 * RefPulse.Length/1000. + D[4] + D[4] + D[4] + D[5] + D[4]);
D[47] = 0.;
D[48] = 0.;

/////////////////Delays for RARE_ZQSQ2
D[50] = 0.5*(time_bw_rfc_pulses - spat_encode_zqsq_len_ms - ref_subr_len_ms)/1000.;
D[51] = te_adjust_ms/1000.;
D[52] = te_rfc_adjust_ms/1000.;

//gradient adjustment
D[53] = slice_sel_grad_adjust*1e-6;

//ZQSQ3 delays
  D[54] = (0.5 * TE_ms-t1+tau_min)/1000. - (0.5 * RefPulse.Length/1000. + (D[3]-slice_sel_grad_adjust*1e-6) + D[4] + D[5] + D[4] + 5E-6 + spat_encode_subr_acq_center_ms/1000.); //replace d23
  D[54]+=te_rfc_adjust_ms/1000.;
  D[55] = (0.5*TE_ms/1000.+2.*tau_min/1000.) - (0.5*RefPulse.Length/1000.+(RMD_grad_stabilization_time_ms-slice_sel_grad_adjust/1000.)/1000.+D[4]+D[5]+D[4]+D[54]+D[4]+D[34]+D[4]+D[4]+32.5e-6+PVM_SpecAcquisitionTime/1000.+D[4]+D[4]+D[34]+D[4]+D[4]+D[12]+D[4]/*+D[55]*/+D[4]+D[34]+D[4]+D[4]+32.5e-6+0.5*PVM_SpecAcquisitionTime/1000.);
///////////////////////Variable Delay list for a 2D CRAZED sequence
  int count = 0;
  double tau_inc_time = 0.;

  tau_inc_time = (tau_max - tau_min)/double(tau_inc - 1);
  
//   if (Exp_type == CRAZED_2D) for (count = 0; count < ACQ_vd_list_size; count++) ACQ_vd_list[count] = (tau_min/1000. + double(count) * tau_inc_time/1000. - ExcPulse.Length/1000. - 3.*D[4] - D[12]);
//   else for (count = 0; count < ACQ_vd_list_size; count++) ACQ_vd_list[count] = ((tau_max - tau_min)/1000.)/(double(ACQ_vd_list_size) - 1)*count;

  if ((Exp_type == CRAZED_2D) & (tau_inc > 4)) 
	for (count = 0; count < tau_inc; count++) 
	{
	ACQ_vd_list_size = tau_inc;
	PARX_change_dims("ACQ_vd_list",MAX_OF(ACQ_vd_list_size,1));
	ACQ_vd_list[count] = (tau_min/1000. + double(count) * tau_inc_time/1000. - ExcPulse.Length/1000. - 3.*D[4] - D[12]);
	}
  else if (((Exp_type == HOT_2D_SLI_ZQSQ) | (Exp_type == HOT_2D_1win) | (Exp_type == HOT_2D_RARE_ZQSQ) | (Exp_type == HOT_2D_RARE_ZQSQ2) | (Exp_type == HOT_2D_RARE_ZQSQ3) | (Exp_type == HOT_2D_1win_PRESS)) & (tau_inc > 4)) {
  	ACQ_vd_list_size = tau_inc;
  	PARX_change_dims("ACQ_vd_list",MAX_OF(ACQ_vd_list_size,1));
	for (count = 0; count < tau_inc; count=count+1)
	{ 
	ACQ_vd_list[count] = MAX_OF(((tau_max - tau_min)/1000.)/(double(tau_inc) - 1.)*count,1e-6);
	}
	}
  else if (tau_inc > 4)
	for (count = 0; count < tau_inc*2; count=count+2)
	{ 
  	ACQ_vd_list_size = tau_inc*2;
  	PARX_change_dims("ACQ_vd_list",MAX_OF(ACQ_vd_list_size,1));
	ACQ_vd_list[count] = MAX_OF(((tau_max - tau_min)/1000.)/(double(tau_inc) - 1.)*count/2.,1e-6);
	ACQ_vd_list[count+1] = MAX_OF(((tau_max - tau_min)/1000.)/(double(tau_inc) - 1.)*count,2e-6);
	}
  else {
	ACQ_vd_list_size = tau_inc;
  	PARX_change_dims("ACQ_vd_list",MAX_OF(ACQ_vd_list_size,1));
	}

 
//   NR = t1_inc;

  /* set shaped pulses     */
  sprintf(TPQQ[0].name,ExcPulse.Filename);
  sprintf(TPQQ[1].name,RefPulseSel.Filename);
  sprintf(TPQQ[2].name,ExcPulseSel.Filename);
  sprintf(TPQQ[3].name,RefPulse.Filename);
  sprintf(TPQQ[4].name,BIRPulse.Filename);
  if(PVM_DeriveGains == Yes)  {
    TPQQ[0].power = ExcPulse.Attenuation;
    TPQQ[1].power = RefPulseSel.Attenuation;
    TPQQ[2].power = ExcPulseSel.Attenuation;
    TPQQ[3].power = RefPulse.Attenuation;
    TPQQ[4].power = BIRPulse.Attenuation;
  }
  double slice_pulse_offset;
  slice_pulse_offset = slice_offset_mm*(RefPulse.Bandwidth/SliceThickness)+I_freq;

  TPQQ[1].offset = I_freq;
  TPQQ[2].offset = S_freq;
  TPQQ[4].offset = (I_freq+S_freq)/2.;
  if (Exp_type == HOT_2D_1win_PRESS){ 
	TPQQ[3].offset = 0.; 
	TPQQ[0].offset = hf_offset_hz; 
	}
  else{ 
	TPQQ[3].offset = slice_pulse_offset;
  	TPQQ[0].offset = 0.0;
	}
  
  ParxRelsParRelations("TPQQ",Yes);
  
  /* set duration of pulse, in this method P[0] is used          */
  P[0] = ExcPulse.Length * 1000;
  P[1] = RefPulseSel.Length * 1000;
  P[2] = ExcPulseSel.Length * 1000;
  P[3] = RefPulse.Length * 1000;
  P[4] = BIRPulse.Length * 1000;
  ParxRelsParRelations("P",Yes);
  
  L[0] = phase_mat_size;
  
  DB_MSG(("Exiting SetPpgParameters"));
}


