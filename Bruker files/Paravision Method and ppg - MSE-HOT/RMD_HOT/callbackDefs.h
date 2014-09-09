/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/callbackDefs.h,v $
 *
 * Copyright (c) 1999-2001
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 *
 * $Id: callbackDefs.h,v 1.9.2.2 2007/07/26 19:27:14 mawi Exp $
 *
 ****************************************************************/

/* init of auto RG */
relations PVM_AutoRgInitHandler MyRgInitRel;

/* digitizer group */
relations PVM_DigHandler        backbone;

/* spectroscopy group */
relations PVM_SpecHandler       backbone;


/* other parameters */
relations PVM_NucleiHandler     backbone;
relations PVM_DeriveGains       backbone;
relations PVM_RepetitionTime    backbone;
relations PVM_EchoTime          backbone;
relations PVM_EpiHandler        backbone; //RMD
relations PVM_NAverages         Local_NAveragesHandler;
relations PVM_NRepetitions      NrepRel;    
relations PVM_ExcPulseAngle     ExcPulseAngleRelation;
relations PVM_GeoMode           backbone;
relations PVM_EncodingHandler   backbone;
/* react on parameter adjustments */
relations PVM_AdjResultHandler backbone;
/****************************************************************/
/*	E N D   O F   F I L E					*/
/****************************************************************/







