/****************************************************************
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/RecoRelations.c,v $
 *
 * Copyright (c) 2001 - 2003
 * Bruker BioSpin MRI GmbH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 *
 * $Id: RecoRelations.c,v 1.6.4.1 2010/03/29 14:26:52 dgem Exp $
 *
 ****************************************************************/

static const char resid[] = "$Id: RecoRelations.c,v 1.1.2.2 2001/01/11 MAWI ";

#define DEBUG           0
#define DB_MODULE       1
#define DB_LINE_NR      1



#include "method.h"

void SetRecoParam( void )
{


  DB_MSG(("-->SetRecoParam\n"));

  /* set baselevel reconstruction parameter */
  /* default initialization of reco based on acqp pars allready set */
  
  ATB_InitDefaultReco();

  /* configure information available during setup mode */

  GS_info_dig_filling     = Yes;
  ParxRelsParRelations("GS_info_dig_filling",Yes); 
  GS_info_normalized_area = Of_raw_data;
  ParxRelsParRelations("GS_info_normalized_area",Yes); 

    

 DB_MSG(("<--SetRecoParam\n"));
}

