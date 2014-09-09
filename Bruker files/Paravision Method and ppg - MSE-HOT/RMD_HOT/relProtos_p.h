/*
 *******************************************************************
 *
 * $Source: /bscl/CvsTree/bscl/gen/config/proto.head,v $
 *
 * Copyright (c) 1995
 * BRUKER ANALYTISCHE MESSTECHNIK GMBH
 * D-76287 Rheinstetten, Germany
 *
 * All Rights Reserved
 *
 *
 * $State: Exp $
 *
 *******************************************************************
 */

#ifndef _P_
#	if defined(HAS_PROTO) || defined(__STDC__) || defined(__cplusplus)
#		define _P_(s) s
#	else
#		define _P_(s) ()
#	endif
#endif

/* /opt/PV5.1/prog/parx/pub/RMD_iMQC/RMD_HOT/initMeth.c */
void initMeth _P_((void));
/* /opt/PV5.1/prog/parx/pub/RMD_iMQC/RMD_HOT/loadMeth.c */
void loadMeth _P_((const char *));
/* /opt/PV5.1/prog/parx/pub/RMD_iMQC/RMD_HOT/parsRelations.c */
void backbone _P_((void));
void crazedParametersRelations _P_((void));
void DeadTimeRels _P_((void));
void DeadTimeRange _P_((void));
void updateDeadTime _P_((void));
void ExcPulseAngleRelation _P_((void));
void ExcPulseEnumRelation _P_((void));
void ExcPulseSelEnumRelation _P_((void));
void RefPulseEnumRelation _P_((void));
void BIRPulseEnumRelation _P_((void));
void RefPulseSelEnumRelation _P_((void));
void InvPulseSelEnumRelation _P_((void));
void ExcPulseRelation _P_((void));
void ExcPulseSelRelation _P_((void));
void InvPulseSelRelation _P_((void));
void RefPulseRelation _P_((void));
void RefPulseSelRelation _P_((void));
void BIRPulseRelation _P_((void));
void ExcPulseRange _P_((void));
void ExcPulseSelRange _P_((void));
void InvPulseSelRange _P_((void));
void RefPulseRange _P_((void));
void RefPulseSelRange _P_((void));
void BIRPulseRange _P_((void));
void repetitionTimeRels _P_((void));
void Local_NAveragesRange _P_((void));
void Local_NAveragesHandler _P_((void));
void NrepRange _P_((void));
void NrepRel _P_((void));
void SpecHandler _P_((void));
void SetGSparameters _P_((void));
void GeoModeRange _P_((void));
void NdummyRange _P_((void));
void NdummyRel _P_((void));
void MyRgInitRel _P_((void));
void spatialEncodingGradientRelations _P_((void));
void NSegmentsRels _P_((void));
void NSegmentsRange _P_((void));
void expTypeRels _P_((void));
void phaseVectRelsNB _P_((void));
void tau_incRels _P_((void));
void subrRelations _P_((void));
void rareRelations _P_((void));
void pressRelations _P_((void));
/* /opt/PV5.1/prog/parx/pub/RMD_iMQC/RMD_HOT/BaseLevelRelations.c */
void SetBaseLevelParam _P_((void));
void SetBasicParameters _P_((void));
void SetFrequencyParameters _P_((void));
void SetGradientParameters _P_((void));
void SetInfoParameters _P_((void));
void SetMachineParameters _P_((void));
void SetPpgParameters _P_((void));
/* /opt/PV5.1/prog/parx/pub/RMD_iMQC/RMD_HOT/RecoRelations.c */
void SetRecoParam _P_((void));
