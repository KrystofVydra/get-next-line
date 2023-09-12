/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET_cfg.h
 * @date   05.10.2015
 * @author litau001
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */
#ifndef BSW_CDD_EVENTTRACER_CFG_ET_CFG_H_
#define BSW_CDD_EVENTTRACER_CFG_ET_CFG_H_

#ifdef EVENT_TRACER

/* TODO include all required header files (e.g. #include "Std_Types.h") */


/* TODO set Typdefinition: default is uint8,uint16 */
/* Typdefinition */
typedef uint8 ET_uint8;
typedef uint16 ET_uint16;
typedef uint32 ET_unit32;

/* The macro writes the current running task id and a 16 bit counter value into */
/* the event tracer array. The index is increased by 4. If the index */
/* overflows it, it will be reset to 0. The timer value is got for  */
/* performance reasons directly by using fixed pointers from the timer	*/
/* register of the capture and compare timer. The event tracer 	*/
/* array size is should be dividable by 4 (for example 65536 byte). */

/* TODO set timer register to read the actual value of the timer (e.g. PIT.TIMER[0].CVAL.R ) */
#define u16TimerValue	

#ifndef EVENT_TRACER_ENABLE_ETHIF
/* TODO define the no logged events in case ETH interface is not used (e.g. 16384 * 4Byte) */
#define ET_EVENT_CT_MAX	16384
#else
/* TODO define the no logged events in case ETH interface is used (e.g. 13078 * 5Byte) */
#define ET_EVENT_CT_MAX	13078
#endif

/* define the maximum UDP frame size in bytes in case of Ethernet IF Tracesupport is enabled */
#define ET_UDPFRAMESIZE_MAX	1030


/* TODO *** TRUE,FALSE *** */
#define ET_TRUE		TRUE
#define ET_FALSE	FALSE

/* TODO Set Semaphore Register */
#define SPI_RESOURCE 		
#define RAM_RESOURCE 		
#define RTM_RESOURCE 		

void ET_SemaphoresInit(void);
void ET_TimerInit(void);
void ET_SuspendAllInterrupts(void);
void ET_ResumeAllInterrupts(void);
ET_uint8 ET_GetInterruptStatus(void);

#ifdef EVENT_TRACER_ENABLE_ETHIF
//#define ET_ETH_TESTMODE				/* by defining the testmode, there will be inserted an u16counter for each trace entry to check if traceload is to high for ETH datarate */
#endif

#endif
#endif /* BSW_CDD_EVENTTRACER_CFG_ET_CFG_H_ */
