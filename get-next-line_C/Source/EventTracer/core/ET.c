/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET.c
 * @date   24.09.2015
 * @author litau001
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */

/* VERSION INFO*/
/* ET_SW_CORE_VERSION 0110 */

#ifdef EVENT_TRACER


#include "ET.h"

#ifdef EVENT_TRACER_ENABLE_ETHIF
#include "Dbg_EthIf.h"
#endif

#if ( ET_SourceVersion != ET_SetupToolVersion )
#warning "Event Tracer - SetupTool & Source haben ungleiche Versionen."
#endif

/* Memory Mapping START */
#define ET_START_SEC_DATA
#include "ET_MemMap.h"

volatile ET_TraceData_type ET_TraceData[ET_EVENT_CT_MAX];

static ET_uint16	u16_eventtracer_write_index = 0;
static ET_uint8		ET_Trigger = 0;
static ET_uint8		ET_TraceBufferStatus = ET_FALSE;

#ifdef EVENT_TRACER_ENABLE_ETHIF
static ET_uint16 u16_eventtracer_read_index = 0;		/* position of data in ET_TraceData buffer to be transmitted next */
static ET_uint8 u8EventTracerBufferWrapAround = 0;		/* flag to remember a wrap around in ET_TraceData buffer. Write pointer is already wrapped around, read pointer not */
static ET_uint16 u16EventTracerBufferFillLevel = 0;		/* ET_TraceData buffer fill level (number of used elements) */
#endif

static ET_uint8 u8EventTracerFirstCall		= ET_FALSE;
static ET_uint8 u8EventTracerStatus			= ET_DEACTIVATE;

#define ET_STOP_SEC_DATA
#include "ET_MemMap.h"

/* Memory Mapping STOP */

void ET_Core0_Init(void)
{

	ET_SemaphoresInit();
	ET_TimerInit();

	if (u8EventTracerStatus != ET_RUN)
	{
		u8EventTracerFirstCall	= ET_TRUE;
		u8EventTracerStatus		= ET_DEACTIVATE;
	}
}

void ET_Core1_Init(void)
{

	if ( u8EventTracerStatus != ET_RUN )
	{
		u8EventTracerFirstCall	= ET_TRUE;
		u8EventTracerStatus		= ET_DEACTIVATE;
	}
}

void EnterTimeStamp(ET_uint16 u16TargetID, ET_uint16 u16EventID)
{

	if (ET_Trigger == 0xAA){
		ET_Core0_Init();
		ET_Activate();
	}

	if (ET_Trigger == 0x55){
		ET_Deactivate();
	}

#ifdef ET_ETH_TESTMODE
	static ET_uint16 u16TestCount = 0x00;
#endif

	 if (u8EventTracerStatus == ET_RUN)
	 {
		/* Lock Interrupts */
		ET_SuspendAllInterrupts();

		/* If Ethernet-IF is activated, set trace ID */
#ifdef EVENT_TRACER_ENABLE_ETHIF
		ET_TraceData[u16_eventtracer_write_index].id = (uint8)ET_ETH_ID_EVENTTRACE;
#endif

		/* Store Event Timestamp, max. 16383 u16TargetIDs */
		/* <timestamp> , <event/target> , <target> */
		/* <xxxx xxxx , xxxx xxxx> , <xx / xx xxxx> , <xxxx xxxx> */
		/* Byte 1-2 */

		ET_TraceData[u16_eventtracer_write_index].timestamp = u16TimerValue; /* Timer Value Register */

#ifndef ET_ETH_TESTMODE
		/* Byte 3-4 */
		ET_TraceData[u16_eventtracer_write_index].Event_Target = (u16EventID | u16TargetID);
#else
		/* Byte 3-4 */
		ET_TraceData[u16_eventtracer_write_index].Event_Target = (u16TestCount++);
#endif

		/* count for next Timestamp*/
		u16_eventtracer_write_index += 1;
		/* store max ET_EVENT_CT_MAX events */
		if (u16_eventtracer_write_index >= ET_EVENT_CT_MAX)
		{
			u16_eventtracer_write_index = 0;
#ifndef EVENT_TRACER_ENABLE_ETHIF
			/* deactivate Event Tracer if buffer is full and ethernet-IF is not activated */
			u8EventTracerStatus = ET_DEACTIVATE;
			/* set TraceBuffer Status to full */
			ET_TraceBufferStatus = ET_FALSE;
#else
			/* remember the wrapping. */
			u8EventTracerBufferWrapAround = 1;
#endif
		}

		/* Resume Interrupts */
		ET_ResumeAllInterrupts();
	 }
}


void ET_Activate(void)
{
	if (u8EventTracerFirstCall == ET_TRUE)
	{
		u8EventTracerStatus = ET_RUN;
		u8EventTracerFirstCall = ET_FALSE;
		ET_Trigger = ET_FALSE;
		ET_TraceBufferStatus = ET_TRUE;
	}
}

void ET_Deactivate(void)
{
	if (u8EventTracerStatus == ET_RUN)
	{
		u8EventTracerStatus = ET_DEACTIVATE;
		u8EventTracerFirstCall = ET_TRUE;
		ET_Trigger = ET_FALSE;
		/* set TraceBuffer Status to full */
		ET_TraceBufferStatus = ET_FALSE;
	}
}

#ifdef EVENT_TRACER_ENABLE_ETHIF

/* Additional functionallity used for ethernet IF support */

void ET_Main_5ms(void)
{
	Std_ReturnType bRet = TRUE;
	uint8 u08OverflowActive = 0;
	ET_TraceData_type OverflowMessage;

	/* locals */
	ET_uint16 u16NbOfEntriesToBeSent = 0;	/* elements which are ready to be sent */

	/* Overflow detection */
	if ((u16_eventtracer_write_index > u16_eventtracer_read_index) && (u8EventTracerBufferWrapAround == 1))
	{
		u08OverflowActive = 1;
	}

	if (u08OverflowActive == 0)
	{
		/*Calculate the number of array elements to be sent */
		u16NbOfEntriesToBeSent = ET_Calculate_NbOfSentBytes(u16_eventtracer_read_index,u16_eventtracer_write_index,u8EventTracerBufferWrapAround);

		/* If there are elemets to be sent, trigger the sending of the data */
		if (u16NbOfEntriesToBeSent != 0)
		{
			/* trigger ethernet sending */
			bRet = Dbg_EthIf_UserTrace_Send((uint8*)&ET_TraceData[u16_eventtracer_read_index],(ET_unit32)(u16NbOfEntriesToBeSent * sizeof(ET_TraceData_type)));

			/* if send request was accepted, increase the read index by the sent items */
			if (bRet == E_OK)
			{
				u16_eventtracer_read_index = u16_eventtracer_read_index + u16NbOfEntriesToBeSent;
			}
			else
			{
				/* Nothing to do. Try to sent data again in next cycle*/
			}

			/* if the read index points to the end, reset it to the beginning and clear WrapAround flag */
			if (u16_eventtracer_read_index >= (ET_uint16)ET_EVENT_CT_MAX)
			{
				u16_eventtracer_read_index = 0;
				u8EventTracerBufferWrapAround = 0;
			}
		}
		else
		{
			/* No data to be sent */
		}

		/* calculate the fill buffer load */
		if (u8EventTracerBufferWrapAround)
		{
			u16EventTracerBufferFillLevel = (ET_uint16)ET_EVENT_CT_MAX - u16_eventtracer_read_index + u16_eventtracer_write_index;
		}
		else
		{
			u16EventTracerBufferFillLevel = u16_eventtracer_write_index - u16_eventtracer_read_index;
		}
	}
	else	/* Overflow was detected. Send overflow indication and reset all buffer */
	{
		/* Define overflow message*/
		OverflowMessage.timestamp = 0x00;
		OverflowMessage.id = ET_ETH_ID_EVENTTRACE_OVERFLOW;
		OverflowMessage.Event_Target = 0x00;

		/* Send overflow message */
		bRet = Dbg_EthIf_UserTrace_Send((uint8*)&OverflowMessage,(ET_unit32)(sizeof(ET_TraceData_type)));

		/* if send request was accepted, reset all values if overflow message was sent correctly */
		if (bRet == E_OK)
		{
			/* Reset buffer values*/
			u16_eventtracer_read_index = 0;
			u16_eventtracer_write_index = 0;
			u8EventTracerBufferWrapAround = 0;

			/* Stop tracing */
			ET_Deactivate();
		}
	}
}

ET_uint16 ET_Calculate_NbOfSentBytes(ET_uint16 u16Readindex, ET_uint16 u16Writeindex, uint8 u8WrapAround)
{
	/* locals */
	ET_uint16 u16NbOfEntriesToBeSent = 0;	/* elements which are ready to be sent */

	/* Check if there is data which needs to be sent. */
	/* In case of write_index pointer is larger than read_index pointer data mus be sent */
	if (u16Writeindex > u16Readindex)
	{
		/* calculate the number of buffer elements which are ready to sent */
		u16NbOfEntriesToBeSent = u16Writeindex - u16Readindex;
	}
	/* In case of Wrap around occured, all remaining data in the buffer needs to be sent */
	else if (u8WrapAround == 1)
	{
		/* calculate the number of buffer elements which are ready to sent */
		u16NbOfEntriesToBeSent = (ET_uint16)ET_EVENT_CT_MAX - u16Readindex;
	}
	/* Otherwise no data must be sent */
	else
	{
		/* Nothing to do here */
	}

	/* Check if number exceeds maximum ethernet frame size */
	if (sizeof(ET_TraceData_type) > 0)
	{
		if (u16NbOfEntriesToBeSent > (ET_uint16)(ET_UDPFRAMESIZE_MAX/sizeof(ET_TraceData_type)))
		{
			/* resize the number of elements to be sent */
			u16NbOfEntriesToBeSent = (ET_uint16)(ET_UDPFRAMESIZE_MAX/sizeof(ET_TraceData_type));
		}
		else
		{
			/* Nothing to be done. All elements to be sent can be sent in one frame */
		}
	}

	return u16NbOfEntriesToBeSent;
}

#endif /* EVENT_TRACER_ENABLE_ETHIF */

#endif /* EVENT_TRACER */

