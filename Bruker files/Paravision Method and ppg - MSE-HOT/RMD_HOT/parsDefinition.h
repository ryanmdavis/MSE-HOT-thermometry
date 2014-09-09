/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/parsDefinition.h,v $
 *
 * Copyright (c) 1999-2003
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 * $Id: parsDefinition.h,v 1.5 2006/11/07 13:09:01 sako Exp $
 *
 ****************************************************************/



/****************************************************************/
/* INCLUDE FILES						*/
/****************************************************************/


PV_PULSE_LIST parameter
{
  display_name "Excitation Pulse Shape";
  relations    ExcPulseEnumRelation;
}ExcPulseEnum;




PVM_RF_PULSE_TYPE parameter
{
  display_name "Excitation Pulse";
  relations    ExcPulseRelation;
}ExcPulse;

PV_PULSE_LIST parameter
{
  display_name "Selective Excitation Pulse Shape";
  relations    ExcPulseSelEnumRelation;
}ExcPulseSelEnum;

PVM_RF_PULSE_TYPE parameter
{
  display_name "Selective Excitation Pulse";
  relations    ExcPulseSelRelation;
}ExcPulseSel;

PV_PULSE_LIST parameter
{
  display_name "Selective Inversion Pulse Shape";
  relations    InvPulseSelEnumRelation;
}InvPulseSelEnum;

PVM_RF_PULSE_TYPE parameter
{
  display_name "Selective Inversion Pulse";
  relations    InvPulseSelRelation;
}InvPulseSel;

double parameter
{
  display_name "Acquisition Delay";
  relations DeadTimeRels;
  format "%.3f";
  units "ms";
} DeadTime;

int parameter
{
  display_name "Number of Dummy Scans";
  relations NdummyRel;
}Ndummy;

PVM_RF_PULSE_TYPE parameter
{
  display_name "Mixing Pulse";
  relations backbone;
}MixPulse; //RMD

PV_PULSE_LIST parameter
{
  display_name "Mixing Pulse Shape";
  relations backbone;
}MixPulseEnum; //RMD

PVM_RF_PULSE_TYPE parameter
{
  display_name "MSE Refocusing Pulses";
  relations BIRPulseRelation;
}BIRPulse; //RMD

PV_PULSE_LIST parameter
{
  display_name "MSE Refocusing Pulse Shape";
  relations BIRPulseEnumRelation;
}BIRPulseEnum; //RMD

PV_PULSE_LIST parameter
{
  display_name "Refocusing Pulse Shape";
  relations    RefPulseEnumRelation;
}RefPulseEnum; //RMD

PV_PULSE_LIST parameter
{
  display_name "Selective Refocusing Pulse Shape";
  relations    RefPulseSelEnumRelation;
}RefPulseSelEnum; //RMD

PVM_RF_PULSE_TYPE parameter
{
  display_name "Refocusing Pulse";
  relations    RefPulseRelation;
}RefPulse; //RMD

PVM_RF_PULSE_TYPE parameter
{
  display_name "Selective Refocusing Pulse";
  relations    RefPulseSelRelation;
}RefPulseSel; //RMD

double parameter 
{
display_name "Correlation Distance";
units "um";
format "%.0f";
relations backbone;
}CorrelationDistance; //RMD

double parameter 
{
 display_name "MQ Filter (mGT,nGT) Grad Duration";
 units "ms";
 format "%.2f";
 relations backbone;
}MQFilterGradientDuration; //RMD

double parameter 
{
 display_name "MQ Filter (2mGT) Grad Duration";
 units "ms";
 format "%.2f";
 relations backbone;
}MQFilterGradientDuration2m; //RMD

double parameter MQFilterGradientTrim2m; //RMD
double parameter MQFilterGradientTrim_n;
double parameter MQFilterGradientTrim_mpn;  //m plus n
double parameter MQFilterGradientTrim_mlsr;  //m minus (less) sr (slice rephase)
double parameter MQFilterGradientTrim_mln;  //m minus n

int parameter 
{
display_name "Coherence Order";
relations backbone;
}CoherenceOrder; //RMD

double parameter
{
display_name "t1";
relations backbone;
units "ms";
format "%.2f";
}t1;  //RMD

double parameter
{
display_name "t2";
relations backbone;
units "ms";
format "%.1f";
}t2; //RMD

double parameter
{
display_name "slice thickness";
relations backbone;
units "mm";
format "%.1f";
}SliceThickness; //RMD

Exp_type_enum parameter
{
display_name "Experiment Type";
relations backbone;
} Exp_type;

double parameter
{
display_name "tau min";
units "ms";
format "%.2f";
relations backbone;
} tau_min;

double parameter
{
display_name "tau max";
units "ms";
format "%.2f";
relations backbone;
} tau_max;

int parameter
{
display_name "number of tau increments";
relations tau_incRels;
} tau_inc;

double parameter
{
display_name "n (gradient multiplier)";
relations backbone;
format "%.2f";
} nn; 

double parameter
{
display_name "m (gradient multiplier)";
relations backbone;
format "%.2f";
} mm;

double parameter
{
display_name "tau";
units "ms";
relations backbone;
format "%.2f";
} tau;

double parameter
{
display_name "Echo Time (TE)";
units "ms";
relations backbone;
format "%.2f";
} TE_ms;

double parameter
{
display_name "Spin I frequency";
units "Hz";
relations backbone;
format "%.0f";
} I_freq;

double parameter
{
display_name "Spin S frequency";
units "Hz";
relations backbone;
format "%.0f";
}S_freq;

OnOff parameter
{
display_name "Phase Cycling?";
relations backbone;
}PhaseCycleOnOff;

OnOff parameter
{
display_name "Pulse Cycling?";
relations backbone;
}PulseCycleOnOff;

int parameter
{
display_name "Experiment Repetitions";
relations backbone;
}exp_reps;

double parameter
{
display_name "Slice Offset";
units "mm";
relations backbone;
}slice_offset_mm;

int parameter
{
display_name "Number of readout samples";
units "samples";
relations expTypeRels;
}read_mat_size;

int parameter
{
display_name "Number of phase encode steps";
units "samples";
relations backbone;
}phase_mat_size;

double parameter
{
display_name "FOV in read direction";
units "mm";	
relations backbone;
}read_FOV;

double parameter
{
display_name "FOV in phase direction";
units "mm";
relations backbone;
}phase_FOV;

double parameter
{
display_name "phase blip duration";
units "ms";
relations backbone;
}phase_blip_dur;

double parameter
{
display_name "Totalsu time of EPI readout";
units "ms";
relations backbone;
}tot_EPI_time;

int parameter 
{
  display_name "Number of Segments";
  relations NSegmentsRels;
} NSegments;

double parameter
{
  display_name "wavenumber of spoiler";
  units "cycles/mm";
  relations backbone;
} k_spoil;

double parameter
{
  display_name "imaging bandwidth";
  units "Hz";
  relations expTypeRels;
} imaging_bandwidth;

double parameter
{
  display_name "spectral bandwidth";
  units "Hz";
  relations expTypeRels;
} spectral_bandwidth_f2;

double parameter
{
  display_name "num points F2 - spectroscopy";
  relations expTypeRels;
} num_points_f2;

double parameter 
{
	display_name "duration of dephase gradient";
	units "ms";
	relations backbone;
	format "%.2f";
} dephase_grad_dur;		//RMD

OnOff parameter
{
	display_name "1st window spatial encoding";
	relations backbone;
} mock_spat_enc_onoff;

double parameter
{
	display_name "dur b/w mock and real encode";
	relations backbone;
	units "ms";
} dur_mock_real;

double parameter 
{
	relations backbone;
} phase_enc_vector[];

double parameter 
{
	relations backbone;
} phase_enc_vector2[];

OnOff parameter
{
	display_name "comp for dig filt group delay?";
	relations backbone;
} digfiltcompOnOff;

double parameter
{
	display_name "Add this to ramp time";
	relations backbone;
	units "ms";
	format "%.3f";
} RMD_ramp_time_adjust;

int parameter
{
	display_name "number of ZQ echoes";
	relations backbone;
} num_echoes;

int parameter
{
	display_name "number of SQ echoes";
	relations backbone;
} num_echoes_SQ;

double parameter
{
	display_name "time between rfc pulses";
	relations backbone;
	units "ms";
} time_bw_rfc_pulses;

double parameter
{
	display_name "min time between rfc pulses";
	relations backbone;
	units "ms";
} min_time_bw_rfc_pulses;

RARE_mode_enum parameter
{
	display_name "RARE mode: # of images";
	relations backbone;
}RARE_mode;

OnOff parameter
{
	display_name "measure receiver baseline";
	relations backbone;
}meas_rec_baseline_OnOff;

/***************************************************************
	* PRESS refocusing pars
	************************************/
double parameter
{
	display_name "HF offset";
	units "mm";
	format "%.2f";
	relations pressRelations;
}hf_offset_mm;

double parameter
{
	display_name "AP offset";
	units "mm";
	format "%.2f";
	relations pressRelations;
}ap_offset_mm;

double parameter
{
	display_name "RL offset";
	units "mm";
	format "%.2f";
	relations pressRelations;
}rl_offset_mm;

double parameter
{
	display_name "HF thickness";
	units "ms";
	format "%.2f";
	relations pressRelations;
}hf_thickness;

double parameter
{
	display_name "AP thickness";
	units "ms";
	format "%.2f";
	relations pressRelations;
}ap_thickness;

double parameter
{
	display_name "RL thickness";
	units "ms";
	format "%.2f";
	relations pressRelations;
}rl_thickness;

double parameter
{
	display_name "excitation slice selection gradient";
	units "%";
	format "%.2f";
	relations pressRelations;
}exc_slc_sel_grad_percent;

RARE_encoding_scheme_enum parameter
{
	display_name "RARE encoding scheme";
	relations backbone;
}RARE_encoding_scheme;

double parameter
{
	display_name "gradient stabilization time (ms)";
	units "ms";
	format "%.3f";
	relations backbone;
}RMD_grad_stabilization_time_ms;

double parameter 
{
	relations backbone;
}
grad_spoil_dur; //ms		//RMD

OnOff parameter
{
	display_name "calibration scan";
	relations backbone;
}cal_scan_onoff;

double parameter //shameless kludging
{
	display_name "adjust te delay";
	format "%.2f";
	units "ms";
	relations backbone;
}te_adjust_ms;	//This is an unfortunate necessity to make sure the echoes form in the center of the windows

double parameter //shameless kludging
{
	display_name "adjust sqzq window delay (kludge)";
	format "%.2f";
	units "ms";
	relations backbone;
}te_rfc_adjust_ms;	//This is an unfortunate necessity to make sure the echoes form in the center of the windows

double parameter
{
	display_name "slice selection gradient truncate";
	format "%3f";
	units "us";
	relations backbone;
} slice_sel_grad_adjust;

YesNo parameter
{
	display_name "use slice selection for MSE refocusing?";
	relations backbone;
}MSE_slice_sel_mode;

double parameter
{
	display_name "read rephase adjust (kludge)";
	units "%";
	format "%.2f";
	relations backbone;
}read_rephase_adjust;

double parameter hf_offset_hz;
double parameter rl_offset_hz;
double parameter ap_offset_hz;

double parameter FirstMQFilterGradientTrim;	//RMD
double parameter SecondMQFilterGradientTrim;	//RMD
double parameter ReadGradRatio; 		//RMD
double parameter phase_prep_grad; 		//RMD
double parameter readDephInteg;			//RMD
double parameter readRampInteg;			//RMD
double parameter effective_phase_blip_time;	//RMD
double parameter phase_blip_grad;		//RMD
double parameter phase_prep_dur;		//RMD
double parameter PhasePrepGradRatio;		//RMD
double parameter effective_phase_gradon_time;	//RMD
double parameter phase_encode_increment_area;	//RMD
double parameter grad_spoil_percent;		//RMD
double parameter grad_spoil_mod_phase_percent;	//RMD
double parameter grad_spoil_mod_read_percent;	//RMD
double parameter phase_enc_dephase_area;	//RMD
double parameter freq_enc_dephase_area;		//RMD
double parameter freq_enc_grad_Hz;		//RMD  //gradient area
double parameter freq_enc_grad_Hz_mm;		//RMD
double parameter freq_enc_grad_percent;		//RMD
double parameter freq_enc_dephase_percent;	//RMD
double parameter freq_enc_rephase_area;		//RMD
double parameter freq_enc_rephase_percent;	//RMD	
double parameter phase_enc_dephase_percent;	//RMD
double parameter phase_enc_max_percent;		//RMD
double parameter spat_encode_subr_len_ms;	//RMD
double parameter spat_encode_subr_acq_center_ms;//RMD
double parameter ref_subr_len_ms;		//RMD
double parameter spat_encode_zqsq_len_ms;	//RMD
double parameter num_echoes_minus_1;		//RMD
double parameter half_num_echoes;		//RMD
int parameter phase_enc_vector_index[];		//RMD
int parameter exp_reps_encoding;		//RMD - this is one less than NR if we measure baseline of receiver
int parameter phase_mat_loop_size;		//RMD


//parameters for adding slice selection to first pulse
double parameter exc_slice_percent;
double parameter slice_rephase_area;
double parameter m_plus_slice_area;
double parameter m_plus_slice_percent;
double parameter RMD_NA;

	
/****************************************************************/
/*	E N D   O F   F I L E					*/
/****************************************************************/

