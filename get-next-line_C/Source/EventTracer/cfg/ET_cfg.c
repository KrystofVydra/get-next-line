/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET_cfg.c
 * @date   05.10.2015
 * @author litau001
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */

#ifdef EVENT_TRACER

#include "ET.h"

void ET_SemaphoresInit() {
	/* TODO Initialize the semaphore module if required*/
}

void ET_TimerInit() {
	/* TODO Please initialize one timer module for EventTracer */
}

void ET_SuspendAllInterrupts(void)
{
	if (ET_GetInterruptStatus() == ET_TRUE) {
		u8_ET_ExtIntEnabled_Temp = ET_TRUE;
		/* TODO implement Suspend of interrupts */
	} else {
		u8_ET_ExtIntEnabled_Temp = ET_FALSE;
	}
}

void ET_ResumeAllInterrupts(void)
{
	if (ET_TRUE == u8_ET_ExtIntEnabled_Temp) {
	/* TODO implement Resume of interrupts */
	}
}

ET_uint8 ET_GetInterruptStatus(void)
{
	ET_uint8 ET_IntStatus = ET_FALSE;

	if(/* TODO implement Interrupt status return */ ET_FALSE ) {
		ET_IntStatus = ET_TRUE;
	} else {
		ET_IntStatus = ET_FALSE;
	}
	return ET_IntStatus;
}

#endif
