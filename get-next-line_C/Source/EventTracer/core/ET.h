/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET.h
 * @date   27.10.2015
 * @author kraehe02
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */
#ifndef SOURCE_BSW_CDD_EVENTTRACER_CORE_ET_H_
#define SOURCE_BSW_CDD_EVENTTRACER_CORE_ET_H_


#define VECTOR_REGDEF_INCLUDED
#include "MPC5748G_2112.h"
#include "ET_gen.h"

#ifdef EVENT_TRACER

#include "ET_cfg.h"

#define ET_SourceVersion 300 //3.0.0

/*** ET-SingleShot state ****/
#define ET_DEACTIVATE			0x00
#define ET_RUN					0x01

/* ET Event Typ Definition */
#define ET_EVT_START			0x8000		/* 1000 0000 0000 0000 */
#define ET_EVT_TERMINATE		0x0000		/* 0000 0000 0000 0000 */
#define ET_EVT_READ				0x4000		/* 0100 0000 0000 0000 */
#define ET_EVT_WRITE			0xC000		/* 1100 0000 0000 0000 */

/* ET Ethernet Interface Trace-ID */
#define ET_ETH_ID_INIT					0x00
#define ET_ETH_ID_EVENTTRACE			0x01
#define ET_ETH_ID_EVENTTRACE_OVERFLOW	0x02
#define ET_ETH_ID_DEVELOPMENTTRACE		0x03
#define ET_ETH_ID_STATUS				0x04

/* Typdefinition ET_Tracedata_type */
#ifdef EVENT_TRACER_ENABLE_ETHIF
#pragma pack(1)
typedef struct{
	ET_uint8 id 			:8;
	ET_uint16 timestamp		:16;
	ET_uint16 Event_Target	:16;
}ET_TraceData_type;
#pragma pack()
#else
typedef struct{
	ET_uint16 timestamp		:16;
	ET_uint16 Event_Target	:16;
}ET_TraceData_type;
#endif	/* EVENT_TRACER_ENABLE_ETHIF */

void ET_Core0_Init(void);
void ET_Core1_Init(void);

void EnterTimeStamp(ET_uint16 u16TargetID, ET_uint16 u16EventID);

void ET_Activate(void);
void ET_Deactivate(void);

#ifdef EVENT_TRACER_ENABLE_ETHIF
void ET_Main_5ms(void);
ET_uint16 ET_Calculate_NbOfSentBytes(ET_uint16 u16Readindex, ET_uint16 u16Writeindex, uint8 u8WrapAround);
#endif

#endif
#endif /* SOURCE_BSW_CDD_EVENTTRACER_CORE_ET_H_ */
