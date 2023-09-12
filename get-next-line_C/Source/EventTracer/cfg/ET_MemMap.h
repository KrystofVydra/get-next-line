/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   ET_MemMap.h
 * @date   27.10.2015
 * @author kraehe02
 * 
 * Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */


#ifdef ET_START_SEC_DATA
    #undef ET_START_SEC_DATA
    #undef MEMMAP_ERROR
	/* Add project specific RAM section */
    #pragma ghs section bss=".ram_sec_rtm"
#endif

#ifdef ET_STOP_SEC_DATA
    #undef ET_STOP_SEC_DATA
    #undef MEMMAP_ERROR
	/* Add project specific RAM section */
    #pragma ghs section
#endif
