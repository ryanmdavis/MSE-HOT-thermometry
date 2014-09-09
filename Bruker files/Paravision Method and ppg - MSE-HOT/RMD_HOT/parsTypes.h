/****************************************************************
 * RMD_HOT - programmed by Ryan M Davis in the Warren lab at Duke.  Created from Bruker SINGLEPULSE method. rmd12@duke.edu
 *
 * $Source: /pv/CvsTree/pv/gen/src/prg/methods/SINGLEPULSE/parsTypes.h,v $
 *
 * Copyright (c) 1999
 * BRUKER MEDICAL GMBH
 * D-76275 Ettlingen, Germany
 *
 * All Rights Reserved
 *
 *
 * $Locker:  $
 * $State: Exp $
 * $Revision: 1.1 $
 *
 *
 ****************************************************************/

/****************************************************************/
/*	TYPEDEF's						*/
/****************************************************************/

typedef enum
{
	CRAZED,
	CRAZED_2D,
	HOT,
	HOT_2D,
	HOT_2D_1win,
	HOT_2D_SLI,
	SE_SLI,
	HOT_2D_SLI_ZQSQ,
	HOT_2D_RARE_ZQSQ, //acquire all ZQC and then acquire all SQC - one refocus for each echo
	HOT_2D_RARE_ZQSQ2, //acquire alternating ZQ and SQ echoes - one refocus gets one ZQ and one SQ echo
	HOT_2D_RARE_ZQSQ3, //acquire all SQC and then acquire all ZQC - one refocus for each echo
	HOT_2D_1win_PRESS
} Exp_type_enum;

typedef enum
{
	one_image,
	N_images,
	none
} RARE_mode_enum;

typedef enum
{
	standard,
	center_to_periphery,
	interleaved
} RARE_encoding_scheme_enum;
/****************************************************************/
/*	E N D   O F   F I L E					*/
/****************************************************************/
