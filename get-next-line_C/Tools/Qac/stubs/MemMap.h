/* README: Such an empty MemMap.h file might be helpful when checking KOSTAL sources being integrated
 * with AUTOSAR sources including MemMap.h massively. Furthermore, MemMap.h used to be quite large.
 * Hence, replacing the real MemMap.h by a stub/empty one will release QAC from the task to parse all that
 * stuff - finally speeding up the check process.
 * Therefor, a stubs folder has been added to QAC tools section. This folder is passed as first include
 * search path to qac.exe. Thus, stub-header files are included instead of the corresponding real one
 * ==> !!! JUST FOR QA-C CHeck !!!
 */
