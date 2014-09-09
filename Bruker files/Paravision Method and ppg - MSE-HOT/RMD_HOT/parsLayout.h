/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/parsLayout.h,v $
 *
 * Copyright (c) 1999-2003
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 * $Id: parsLayout.h,v 1.14.2.1 2007/03/16 15:01:28 sako Exp $
 *
 ****************************************************************/

/****************************************************************/
/*	PARAMETER CLASSES				       	*/
/****************************************************************/


/*--------------------------------------------------------------*
 * Definition of the PV class...
 *--------------------------------------------------------------*/
parclass
{
  Ndummy;
} Preparation;

parclass
{
  DeadTime;
}
attributes
{
  display_name "Sequence Details";
} Sequence_Details;

parclass
{
  PVM_SliceBandWidthScale;
  ExcPulseEnum;
  ExcPulse;
  ExcPulseSelEnum;
  ExcPulseSel;
//   MixPulseEnum;
//   MixPulse;
  RefPulseEnum;
  RefPulse;
  RefPulseSelEnum;
  RefPulseSel;
  BIRPulseEnum;
  BIRPulse;
  InvPulseSelEnum;
  InvPulseSel;
} 
attributes
{
  display_name "RF Pulses";
} RF_Pulses;

parclass
{
	read_mat_size;
	phase_mat_size;
	read_FOV;
	phase_FOV;
	imaging_bandwidth;
	k_spoil;
	dephase_grad_dur;
	mock_spat_enc_onoff;
	dur_mock_real;
	digfiltcompOnOff;
	meas_rec_baseline_OnOff;
	RMD_ramp_time_adjust;
	RMD_grad_stabilization_time_ms;
	te_rfc_adjust_ms;
	read_rephase_adjust;
}

attributes
{
  display_name "spatial encoding";
}SpatEnc;

parclass
{
	ap_offset_mm;
	rl_offset_mm;
	hf_offset_mm;
	ap_thickness;
	rl_thickness;
	hf_thickness;
}

attributes
{
  	display_name "PRESS parameters";
}PRESS;

parclass
{
	time_bw_rfc_pulses;
	min_time_bw_rfc_pulses;
	num_echoes;
	num_echoes_SQ;
	RARE_mode;
	RARE_encoding_scheme;
	cal_scan_onoff;
	MSE_slice_sel_mode;
}

attributes
{
  display_name "RARE parameters";
}RARE;

parclass
{
  CorrelationDistance;
  CoherenceOrder;
  PhaseCycleOnOff;
  PulseCycleOnOff;
  MQFilterGradientDuration;
  MQFilterGradientDuration2m;
  t1;
  tau;
  tau_min;
  tau_max;
  tau_inc;
  ACQ_vd_list;
  spectral_bandwidth_f2;
  t2;
  mm;
  nn;
  I_freq;
  S_freq;
} iMQC_Parameters;

parclass
{
  Method;
  Exp_type;
  //EPI;
  SpatEnc;
  RARE;
  PRESS;
  iMQC_Parameters;
  exp_reps;
  TE_ms;
  Spectroscopy;
  SliceThickness;
  slice_offset_mm;
  PVM_GeoMode;
  PVM_RepetitionTime;
  PVM_NAverages;
  //PVM_NRepetitions;
  PVM_ScanTimeStr;
  PVM_DeriveGains;
  RF_Pulses;
  Nuclei;
  Preparation;
  Encoding;
  Sequence_Details;
} MethodClass;


/****************************************************************/
/*	E N D   O F   F I L E					*/
/****************************************************************/



