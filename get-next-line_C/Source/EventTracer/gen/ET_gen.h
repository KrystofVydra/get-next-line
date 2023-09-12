/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET.h
 * @date   16.09.2015
 * @author kraehe02
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */
#ifndef SOURCE_BSW_CDD_EVENTTRACER_ET_GEN_H_
#define SOURCE_BSW_CDD_EVENTTRACER_ET_GEN_H_


#ifdef EVENT_TRACER

	#define ET_SetupToolVersion 300 //3.0.0

/* Do not change or remove this comment ! generated task indexes */
    #define C0_TASK_MIN 0
    #define ET_EVT_InitBswTask_ID 0
    #define ET_EVT_IdleTask_ID 1
    #define ET_EVT_Appl_1ms_NON_ID 2
    #define ET_EVT_Appl_Cyclic_Task_EEM_FULL_ID 3
    #define ET_EVT_Appl_Cyclic_Task_FULL_ID 4
    #define ET_EVT_Appl_nonCyclic_Task_NON_ID 5
    #define ET_EVT_SchM_AsyncTask_1_ID 6
    #define ET_EVT_SchM_AsyncTask_2_ID 7
    #define ET_EVT_SchM_AsyncTask_3_ID 8
    #define ET_EVT_SchM_SyncTask_1_ID 9
    #define ET_EVT_SchM_SyncTask_2_ID 10
    #define ET_EVT_UgwTask_ID 11
    #define C0_TASK_MAX 11

/* Do not change or remove this comment ! generated isr indexes */
    #define C0_ISR_MIN 12
    #define ET_EVT_Fr_IrqProtocol_ID 12
    #define ET_EVT_osTimerInterrupt_ID 13
    #define C0_ISR_MAX 13

/* Do not change or remove this comment ! generated fct indexes */
    #define C0_FCT_MIN 14
    #define ET_EVT_CT_APP_NfRwb_ID 14
    #define C0_FCT_MAX 14

/* Do not change or remove this comment ! generated sig indexes */
    #define C0_SIG_MIN 14
    #define C0_SIG_MAX 14

/* Do not change or remove this comment ! generated duration indexes */
    #define C0_DUR_MIN 15
    #define ET_EVT_SuspendAllInterrupts_ID 15
    #define ET_EVT_DisableAllInterrupts_ID 16
    #define ET_EVT_SuspendOSInterrupts_ID 17
    #define C0_DUR_MAX 17

/* Do not change or remove this comment ! generated evt indexes */
    #define C0_EVT_MIN 17
    #define C0_EVT_MAX 17

/* Do not change or remove this comment ! the end of generated first core indexes */


/* Do not change or remove this comment ! generated task indexes of second core */
    #define C1_TASK_MIN 17
    #define C1_TASK_MAX 17

/* Do not change or remove this comment ! generated isr indexes of second core */
    #define C1_ISR_MIN 17
    #define C1_ISR_MAX 17

/* Do not change or remove this comment ! generated fct indexes of second core */
    #define C1_FCT_MIN 17
    #define C1_FCT_MAX 17

/* Do not change or remove this comment ! generated sig indexes of second core */
    #define C1_SIG_MIN 17
    #define C1_SIG_MAX 17

/* Do not change or remove this comment ! generated duration indexes of second core */
    #define C1_DUR_MIN 17
    #define C1_DUR_MAX 17

/* Do not change or remove this comment ! generated evt indexes of second core */
    #define C1_EVT_MIN 17
    #define C1_EVT_MAX 17

/* Do not change or remove this comment ! the end of generated second core indexes */



#ifndef QAC_CHECK
#pragma pack(1)
#endif

#ifndef QAC_CHECK
#pragma pack()
#endif


/* Do not change or remove this comment ! generated timestamp functions */
    #define ET_EVT_InitBswTask_start	EnterTimeStamp(ET_EVT_InitBswTask_ID, ET_EVT_START);
    #define ET_EVT_InitBswTask_terminate	EnterTimeStamp(ET_EVT_InitBswTask_ID, ET_EVT_TERMINATE);
    #define ET_EVT_IdleTask_start	EnterTimeStamp(ET_EVT_IdleTask_ID, ET_EVT_START);
    #define ET_EVT_IdleTask_terminate	EnterTimeStamp(ET_EVT_IdleTask_ID, ET_EVT_TERMINATE);
    #define ET_EVT_CanBusOffIsr_0_start
    #define ET_EVT_CanBusOffIsr_0_terminate
    #define ET_EVT_CanBusOffIsr_1_start
    #define ET_EVT_CanBusOffIsr_1_terminate
    #define ET_EVT_CanBusOffIsr_2_start
    #define ET_EVT_CanBusOffIsr_2_terminate
    #define ET_EVT_CanBusOffIsr_3_start
    #define ET_EVT_CanBusOffIsr_3_terminate
    #define ET_EVT_CanBusOffIsr_4_start
    #define ET_EVT_CanBusOffIsr_4_terminate
    #define ET_EVT_CanBusOffIsr_5_start
    #define ET_EVT_CanBusOffIsr_5_terminate
    #define ET_EVT_CanBusOffIsr_7_start
    #define ET_EVT_CanBusOffIsr_7_terminate
    #define ET_EVT_CanMB8To63Isr_0_start
    #define ET_EVT_CanMB8To63Isr_0_terminate
    #define ET_EVT_CanMB8To63Isr_1_start
    #define ET_EVT_CanMB8To63Isr_1_terminate
    #define ET_EVT_CanMB8To63Isr_2_start
    #define ET_EVT_CanMB8To63Isr_2_terminate
    #define ET_EVT_CanMB8To63Isr_3_start
    #define ET_EVT_CanMB8To63Isr_3_terminate
    #define ET_EVT_CanMB8To63Isr_4_start
    #define ET_EVT_CanMB8To63Isr_4_terminate
    #define ET_EVT_CanMB8To63Isr_5_start
    #define ET_EVT_CanMB8To63Isr_5_terminate
    #define ET_EVT_CanMB8To63Isr_7_start
    #define ET_EVT_CanMB8To63Isr_7_terminate
    #define ET_EVT_CanRxFifoIsr_0_start
    #define ET_EVT_CanRxFifoIsr_0_terminate
    #define ET_EVT_CanRxFifoIsr_1_start
    #define ET_EVT_CanRxFifoIsr_1_terminate
    #define ET_EVT_CanRxFifoIsr_2_start
    #define ET_EVT_CanRxFifoIsr_2_terminate
    #define ET_EVT_CanRxFifoIsr_3_start
    #define ET_EVT_CanRxFifoIsr_3_terminate
    #define ET_EVT_CanRxFifoIsr_4_start
    #define ET_EVT_CanRxFifoIsr_4_terminate
    #define ET_EVT_CanRxFifoIsr_5_start
    #define ET_EVT_CanRxFifoIsr_5_terminate
    #define ET_EVT_CanRxFifoIsr_7_start
    #define ET_EVT_CanRxFifoIsr_7_terminate
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup1_start
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup1_terminate
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup2_start
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup2_terminate
    #define ET_EVT_LinIsr_ERR_0_start
    #define ET_EVT_LinIsr_ERR_0_terminate
    #define ET_EVT_LinIsr_ERR_3_start
    #define ET_EVT_LinIsr_ERR_3_terminate
    #define ET_EVT_LinIsr_RXI_0_start
    #define ET_EVT_LinIsr_RXI_0_terminate
    #define ET_EVT_LinIsr_RXI_3_start
    #define ET_EVT_LinIsr_RXI_3_terminate
    #define ET_EVT_LinIsr_TXI_0_start
    #define ET_EVT_LinIsr_TXI_0_terminate
    #define ET_EVT_LinIsr_TXI_3_start
    #define ET_EVT_LinIsr_TXI_3_terminate
    #define ET_EVT_Spi_Dspi_IsrTCF_DSPI_6_start
    #define ET_EVT_Spi_Dspi_IsrTCF_DSPI_6_terminate
    #define ET_EVT_VOs_Isr_Pit0Ch0_start
    #define ET_EVT_VOs_Isr_Pit0Ch0_terminate
    #define ET_EVT_VOs_Isr_Pit0Ch2_start
    #define ET_EVT_VOs_Isr_Pit0Ch2_terminate
    #define ET_EVT_VOs_Isr_McMeIsSafe_start
    #define ET_EVT_VOs_Isr_McMeIsSafe_terminate
    #define ET_EVT_VOs_Isr_McMeIsMtc_start
    #define ET_EVT_VOs_Isr_McMeIsMtc_terminate
    #define ET_EVT_VOs_Isr_McMeIsMode_start
    #define ET_EVT_VOs_Isr_McMeIsMode_terminate
    #define ET_EVT_VOs_Isr_McMeIsConf_start
    #define ET_EVT_VOs_Isr_McMeIsConf_terminate
    #define ET_EVT_Appl_1ms_NON_start	EnterTimeStamp(ET_EVT_Appl_1ms_NON_ID, ET_EVT_START);
    #define ET_EVT_Appl_1ms_NON_terminate	EnterTimeStamp(ET_EVT_Appl_1ms_NON_ID, ET_EVT_TERMINATE);
    #define ET_EVT_Appl_Cyclic_Task_EEM_FULL_start	EnterTimeStamp(ET_EVT_Appl_Cyclic_Task_EEM_FULL_ID, ET_EVT_START);
    #define ET_EVT_Appl_Cyclic_Task_EEM_FULL_terminate	EnterTimeStamp(ET_EVT_Appl_Cyclic_Task_EEM_FULL_ID, ET_EVT_TERMINATE);
    #define ET_EVT_Appl_Cyclic_Task_FULL_start	EnterTimeStamp(ET_EVT_Appl_Cyclic_Task_FULL_ID, ET_EVT_START);
    #define ET_EVT_Appl_Cyclic_Task_FULL_terminate	EnterTimeStamp(ET_EVT_Appl_Cyclic_Task_FULL_ID, ET_EVT_TERMINATE);
    #define ET_EVT_Appl_nonCyclic_Task_NON_start	EnterTimeStamp(ET_EVT_Appl_nonCyclic_Task_NON_ID, ET_EVT_START);
    #define ET_EVT_Appl_nonCyclic_Task_NON_terminate	EnterTimeStamp(ET_EVT_Appl_nonCyclic_Task_NON_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SchM_AsyncTask_1_start	EnterTimeStamp(ET_EVT_SchM_AsyncTask_1_ID, ET_EVT_START);
    #define ET_EVT_SchM_AsyncTask_1_terminate	EnterTimeStamp(ET_EVT_SchM_AsyncTask_1_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SchM_AsyncTask_2_start	EnterTimeStamp(ET_EVT_SchM_AsyncTask_2_ID, ET_EVT_START);
    #define ET_EVT_SchM_AsyncTask_2_terminate	EnterTimeStamp(ET_EVT_SchM_AsyncTask_2_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SchM_AsyncTask_3_start	EnterTimeStamp(ET_EVT_SchM_AsyncTask_3_ID, ET_EVT_START);
    #define ET_EVT_SchM_AsyncTask_3_terminate	EnterTimeStamp(ET_EVT_SchM_AsyncTask_3_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SchM_SyncTask_1_start	EnterTimeStamp(ET_EVT_SchM_SyncTask_1_ID, ET_EVT_START);
    #define ET_EVT_SchM_SyncTask_1_terminate	EnterTimeStamp(ET_EVT_SchM_SyncTask_1_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SchM_SyncTask_2_start	EnterTimeStamp(ET_EVT_SchM_SyncTask_2_ID, ET_EVT_START);
    #define ET_EVT_SchM_SyncTask_2_terminate	EnterTimeStamp(ET_EVT_SchM_SyncTask_2_ID, ET_EVT_TERMINATE);
    #define ET_EVT_UgwTask_start	EnterTimeStamp(ET_EVT_UgwTask_ID, ET_EVT_START);
    #define ET_EVT_UgwTask_terminate	EnterTimeStamp(ET_EVT_UgwTask_ID, ET_EVT_TERMINATE);
    #define ET_EVT_Fr_IrqProtocol_start	EnterTimeStamp(ET_EVT_Fr_IrqProtocol_ID, ET_EVT_START);
    #define ET_EVT_Fr_IrqProtocol_terminate	EnterTimeStamp(ET_EVT_Fr_IrqProtocol_ID, ET_EVT_TERMINATE);
    #define ET_EVT_osTimerInterrupt_start	EnterTimeStamp(ET_EVT_osTimerInterrupt_ID, ET_EVT_START);
    #define ET_EVT_osTimerInterrupt_terminate	EnterTimeStamp(ET_EVT_osTimerInterrupt_ID, ET_EVT_TERMINATE);
    #define ET_EVT_CT_APP_NfRwb_start	EnterTimeStamp(ET_EVT_CT_APP_NfRwb_ID, ET_EVT_START);
    #define ET_EVT_CT_APP_NfRwb_terminate	EnterTimeStamp(ET_EVT_CT_APP_NfRwb_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SuspendAllInterrupts_terminate	EnterTimeStamp(ET_EVT_SuspendAllInterrupts_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SuspendAllInterrupts_start	EnterTimeStamp(ET_EVT_SuspendAllInterrupts_ID, ET_EVT_START);
    #define ET_EVT_DisableAllInterrupts_terminate	EnterTimeStamp(ET_EVT_DisableAllInterrupts_ID, ET_EVT_TERMINATE);
    #define ET_EVT_DisableAllInterrupts_start	EnterTimeStamp(ET_EVT_DisableAllInterrupts_ID, ET_EVT_START);
    #define ET_EVT_SuspendOSInterrupts_terminate	EnterTimeStamp(ET_EVT_SuspendOSInterrupts_ID, ET_EVT_TERMINATE);
    #define ET_EVT_SuspendOSInterrupts_start	EnterTimeStamp(ET_EVT_SuspendOSInterrupts_ID, ET_EVT_START);
/* Do not change or remove this comment ! the end of generated timestamp functions */

#else	/* EVENT_TRACER */

/* Do not change or remove this comment ! Generated empty timestamp functions */
    #define ET_EVT_InitBswTask_start
    #define ET_EVT_InitBswTask_terminate
    #define ET_EVT_IdleTask_start
    #define ET_EVT_IdleTask_terminate
    #define ET_EVT_CanBusOffIsr_0_start
    #define ET_EVT_CanBusOffIsr_0_terminate
    #define ET_EVT_CanBusOffIsr_1_start
    #define ET_EVT_CanBusOffIsr_1_terminate
    #define ET_EVT_CanBusOffIsr_2_start
    #define ET_EVT_CanBusOffIsr_2_terminate
    #define ET_EVT_CanBusOffIsr_3_start
    #define ET_EVT_CanBusOffIsr_3_terminate
    #define ET_EVT_CanBusOffIsr_4_start
    #define ET_EVT_CanBusOffIsr_4_terminate
    #define ET_EVT_CanBusOffIsr_5_start
    #define ET_EVT_CanBusOffIsr_5_terminate
    #define ET_EVT_CanBusOffIsr_7_start
    #define ET_EVT_CanBusOffIsr_7_terminate
    #define ET_EVT_CanMB8To63Isr_0_start
    #define ET_EVT_CanMB8To63Isr_0_terminate
    #define ET_EVT_CanMB8To63Isr_1_start
    #define ET_EVT_CanMB8To63Isr_1_terminate
    #define ET_EVT_CanMB8To63Isr_2_start
    #define ET_EVT_CanMB8To63Isr_2_terminate
    #define ET_EVT_CanMB8To63Isr_3_start
    #define ET_EVT_CanMB8To63Isr_3_terminate
    #define ET_EVT_CanMB8To63Isr_4_start
    #define ET_EVT_CanMB8To63Isr_4_terminate
    #define ET_EVT_CanMB8To63Isr_5_start
    #define ET_EVT_CanMB8To63Isr_5_terminate
    #define ET_EVT_CanMB8To63Isr_7_start
    #define ET_EVT_CanMB8To63Isr_7_terminate
    #define ET_EVT_CanRxFifoIsr_0_start
    #define ET_EVT_CanRxFifoIsr_0_terminate
    #define ET_EVT_CanRxFifoIsr_1_start
    #define ET_EVT_CanRxFifoIsr_1_terminate
    #define ET_EVT_CanRxFifoIsr_2_start
    #define ET_EVT_CanRxFifoIsr_2_terminate
    #define ET_EVT_CanRxFifoIsr_3_start
    #define ET_EVT_CanRxFifoIsr_3_terminate
    #define ET_EVT_CanRxFifoIsr_4_start
    #define ET_EVT_CanRxFifoIsr_4_terminate
    #define ET_EVT_CanRxFifoIsr_5_start
    #define ET_EVT_CanRxFifoIsr_5_terminate
    #define ET_EVT_CanRxFifoIsr_7_start
    #define ET_EVT_CanRxFifoIsr_7_terminate
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup1_start
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup1_terminate
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup2_start
    #define ET_EVT_EthIsr_EthCtrlConfig_Eth0_IntGroup2_terminate
    #define ET_EVT_LinIsr_ERR_0_start
    #define ET_EVT_LinIsr_ERR_0_terminate
    #define ET_EVT_LinIsr_ERR_3_start
    #define ET_EVT_LinIsr_ERR_3_terminate
    #define ET_EVT_LinIsr_RXI_0_start
    #define ET_EVT_LinIsr_RXI_0_terminate
    #define ET_EVT_LinIsr_RXI_3_start
    #define ET_EVT_LinIsr_RXI_3_terminate
    #define ET_EVT_LinIsr_TXI_0_start
    #define ET_EVT_LinIsr_TXI_0_terminate
    #define ET_EVT_LinIsr_TXI_3_start
    #define ET_EVT_LinIsr_TXI_3_terminate
    #define ET_EVT_Spi_Dspi_IsrTCF_DSPI_6_start
    #define ET_EVT_Spi_Dspi_IsrTCF_DSPI_6_terminate
    #define ET_EVT_VOs_Isr_Pit0Ch0_start
    #define ET_EVT_VOs_Isr_Pit0Ch0_terminate
    #define ET_EVT_VOs_Isr_Pit0Ch2_start
    #define ET_EVT_VOs_Isr_Pit0Ch2_terminate
    #define ET_EVT_VOs_Isr_McMeIsSafe_start
    #define ET_EVT_VOs_Isr_McMeIsSafe_terminate
    #define ET_EVT_VOs_Isr_McMeIsMtc_start
    #define ET_EVT_VOs_Isr_McMeIsMtc_terminate
    #define ET_EVT_VOs_Isr_McMeIsMode_start
    #define ET_EVT_VOs_Isr_McMeIsMode_terminate
    #define ET_EVT_VOs_Isr_McMeIsConf_start
    #define ET_EVT_VOs_Isr_McMeIsConf_terminate
    #define ET_EVT_Appl_1ms_NON_start
    #define ET_EVT_Appl_1ms_NON_terminate
    #define ET_EVT_Appl_Cyclic_Task_EEM_FULL_start
    #define ET_EVT_Appl_Cyclic_Task_EEM_FULL_terminate
    #define ET_EVT_Appl_Cyclic_Task_FULL_start
    #define ET_EVT_Appl_Cyclic_Task_FULL_terminate
    #define ET_EVT_Appl_nonCyclic_Task_NON_start
    #define ET_EVT_Appl_nonCyclic_Task_NON_terminate
    #define ET_EVT_SchM_AsyncTask_1_start
    #define ET_EVT_SchM_AsyncTask_1_terminate
    #define ET_EVT_SchM_AsyncTask_2_start
    #define ET_EVT_SchM_AsyncTask_2_terminate
    #define ET_EVT_SchM_AsyncTask_3_start
    #define ET_EVT_SchM_AsyncTask_3_terminate
    #define ET_EVT_SchM_SyncTask_1_start
    #define ET_EVT_SchM_SyncTask_1_terminate
    #define ET_EVT_SchM_SyncTask_2_start
    #define ET_EVT_SchM_SyncTask_2_terminate
    #define ET_EVT_UgwTask_start
    #define ET_EVT_UgwTask_terminate
    #define ET_EVT_Fr_IrqProtocol_start
    #define ET_EVT_Fr_IrqProtocol_terminate
    #define ET_EVT_osTimerInterrupt_start
    #define ET_EVT_osTimerInterrupt_terminate
    #define ET_EVT_CT_APP_NfRwb_start
    #define ET_EVT_CT_APP_NfRwb_terminate
    #define ET_EVT_SuspendAllInterrupts_terminate
    #define ET_EVT_SuspendAllInterrupts_start
    #define ET_EVT_DisableAllInterrupts_terminate
    #define ET_EVT_DisableAllInterrupts_start
    #define ET_EVT_SuspendOSInterrupts_terminate
    #define ET_EVT_SuspendOSInterrupts_start
/* Do not change or remove this comment ! Here is the end of generated empty timestamp functions */

#endif /* EVENT_TRACER */

#endif /* SOURCE_BSW_CDD_EVENTTRACER_ET_GEN_H_ */
