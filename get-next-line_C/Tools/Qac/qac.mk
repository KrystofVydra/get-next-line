# SVN-Id: $Id: makefile 51595 2017-01-09 01:28:29Z schroe03 $
# SVN-Url: $HeadURL: http://debesvn001.de.kostal.int/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/branches/KOCHI_Improvements/Tools/Make/makefile $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# This file is part of the core make process files and should not be
# modified by users. Please see the files in ./config directory for
# all configuration options.
#
# Make module to define the targets and processing related to QA-C
# checking (whole project and single source files).
#
######################################################################

# Export the QACBIN variable, because its value (as an environment
# variable) is used inside the QA-C configuration files and also
# needed by qac.exe.
export QACBIN=$(shell cygpath -w ${QAC_PATH}\\bin)

ifeq ($(suffix $(MAKECMDGOALS)),.err)
# vpath gets extended by excluded sources in project, enabling single
# file check of sources being excluded from build
include ${SrcListDir}/make-vpath-excluded.mk2
endif


######################################################################
# Optional feature configuration macros
######################################################################

# QAC_CALC_SUP: controls, if suppressed messages shall be retrieved
# for reporting
QAC_CALC_SUP = ON

######################################################################
# Macro definitions for path and file list handling
######################################################################

QACERR_EXT              = .c.err

SrcList_Qac_Dir         = $(filter-out ${blacklist_source_qac},${source})
SrcList_Qac             = $(notdir ${SrcList_Qac_Dir})
ObjList_Qac             = $(notdir $(addsuffix ${QACERR_EXT}, $(basename ${SrcList_Qac})))
ModuleList_Qac          = $(notdir $(basename ${SrcList_Qac}))
ModuleListSize_Qac      = $(words ${ModuleList_Qac})
IPath_Qac               = ${IPath}
QPath_Qac               = $(addprefix -q, $(sort ${blacklist_header_qac}))
SrcListDir_Qac          = ${QacPrj}/lists
StubsDir_Qac            = ${QacPrj}/stubs
DepFilePattern_Qac      = ${SrcListDir_Qac}/$.*${DEP_EXT}
DepTargetPattern_Qac    = $*${QACERR_EXT}

CC_DEFINES_QAC          = $(addprefix -D, ${CC_DEFLIST_QAC})

ProjectConfig           = ${CC_DEFINES_QAC} \
                          -via ${QacPrj}/project.p_a \
                          -via ${QacPrj}/project.p_c \
                          -via ${QacPrj}/project.p_s

vpath  % ${QacPrj}/output
vpath  % ${QacPrj}/lists

# include existing qac dependency rule files for incremental build
include $(wildcard ${SrcListDir_Qac}/*.${DEP_EXT})

QAC_CSV_HEADER="Dateiname\\tZeile\\tSpalte\\tLevel\\tCode\\tMeldung\\tMISRA-Regel\\tReference"

######################################################################
#  Analysis result output format for each message
#
#  The output dispatcher offers the ability to format these messages
#  based on conditions.
#
#  Options:
#  f : filename
#  l : line
#  c : column
#  g : gravity level
#  N : message number
#  v : verbose/reference text
#  t : message text
######################################################################

QacOutputFormatFile = "%f %l %c %g %N %t %v"

######################################################################
#  Full output format: Formatting by QAC gravity level:   
#  g=9 : error                                            
#  g<4 : info                                             
#  g4-8: warning                                          
######################################################################

QacOutputFormatConsoleFull = "%f:%l: %?g<9%(%?g<4%(info%:warning%)%:error%): %N g%g %v %t"

######################################################################
#  MISRA output format:                                   
#  Here we choose the option to just display QAC gravity  
#  level 4 messages, which correspond to MISRA messages   
#  (see QAC documentation)                                
#  Format condition ?g==4 means all messages of gravity   
#  level 4 are handled. In all other cases, QAC generates 
#  an empty line.                                         
#  Empty lines are deleted afterwards by grep filtering   
######################################################################
QacOutputFormatConsoleMISRA  = "%?g==4%(%f:%l: error: %N %v %t%)"
QacOutputFormatConsoleLevel9 = "%?g>=9%(%f:%l: error: %N %v %t%)"
QacOutputFormatAnnotate      = "%N %v %t"
QacOutputFormatQAR           = "%f\t%l\t%c\t%g\t%N\t%t\t%v"
QacOutputFormatQAR_MISRA     = "%?g==4%(%f\t%l\t%c\t%g\t%N\t%t\t%v%)"


######################################################################
#  Additional macros and canned sequences covering QAC Actions and
#  error evaluation
######################################################################

# Dispatching of QA-C result to console as parameter $(1) the format
# string is passed
define QacDispatchToConsole
	${QACDSPEXE} QAC \
	    ${ProjectConfig} \
	    -hw- \
	    ${QPath_Qac} \
	    -op ${QacPrj}/output \
	    -format $(1) $<; \
	ERRDSP_RET=$$?; \
	if [ $$ERRDSP_RET -eq "11" ]; \
	then \
	    echo "errdsp.exe failed to acquire license."; \
	    exit $$ERRDSP_RET; \
	fi
endef

# Dispatching of QA-C result to file
# parameter $(1) takes format string
# parameter $(2) takes the target file
define QacDispatchToFile
	${QACDSPEXE} QAC \
	    ${ProjectConfig} \
	    $(3) \
	    ${QPath_Qac} \
	    -op ${QacPrj}/output \
	    -format $(1) $< \
	| sed -e '/^$$/d' >> $(2); \
	ERRDSP_RET=$$?; \
	if [ $$ERRDSP_RET -eq "11" ]; \
	then \
	    echo "errdsp.exe failed to acquire license."; \
	    exit $$ERRDSP_RET;\
	fi
endef


# Dispatching of QA-C result to file and evaluate metrics
# parameter $(1) takes format string
# parameter $(2) takes the basename of the target files
define QacDispatchMetrics
	echo QAR=${QacPrj}/output/$(strip $(2)).qar

# FIXME: Here is a bug! ERRDSP_RET is by default set to the exit code
# of sed, not errdsp.exe. This is default behavior for unix shells.
	${QACDSPEXE} QAC \
	    ${ProjectConfig} \
	    -op ${QacPrj}/output \
	    -format $(1) $(strip $(2)) \
	| sed -e '/^$$/d' >> ${QacPrj}/output/$(strip $(2)).qar; \
	ERRDSP_RET=$$?;\
	mv \
		${QacPrj}/output/$(strip $(2)).met \
		${QacPrj}/output/$(strip $(2)).2met; \
	mv \
		${QacPrj}/output/$(strip $(2)).err \
		${QacPrj}/output/$(strip $(2)).2err; \
	if [ $$ERRDSP_RET -eq "11" ]; \
	then \
	    echo "errdsp.exe failed to acquire license."; \
	    exit $$ERRDSP_RET;\
	fi
endef

######################################################################
# Major rules to perform project-wide QAC processing of all sources
# listed by sourcelist_qac.mk.
######################################################################
.PHONY: qac_all_rebuild
qac_all_rebuild: checktools_BASIC checktools_QAC
	$(MAKE) qac_clean
	$(MAKE) qac_all


.PHONY: qac_all
qac_all: checktools_BASIC checktools_QAC ${ObjList_Qac}
ifeq (${ObjList_Qac},)
	@echo "QA-C source list empty, nothing to process. Please " \
		"check source list."
else
	$(MAKE) qac_cma
	@echo "QA-C check completed."
endif


######################################################################
# Rule performing QAC-analysis of single object (.c file) including
# MISRA post-processing
######################################################################
%${QACERR_EXT}: %.c
# QAC base analysis
	@echo "Analyzing '$(notdir $<)': QA-C"
	${QACEXE} \
	    -I${StubsDir_Qac} ${IPath_Qac} \
	    ${QPath_Qac} \
	    ${ProjectConfig} \
	    -op ${QacPrj}/output $<

# Misra 2004 afterburner
	@echo "Analyzing '$(notdir $<)': MISRA"
	${CMEXE} QAC \
	    ${QPath_Qac} \
	    -op ${QacPrj}/output $<

ifneq (${QAC_SILENT}, ON)
# Dispatching all results (QAC, MISRA) to console (all messages are
# passed through)
	$(call QacDispatchToConsole, ${QacOutputFormatConsoleFull})
endif

# Dispatching all results (QAC, MISRA) to file for report
# post-processing (all messages are stored)
	$(call QacDispatchToFile, \
		${QacOutputFormatQAR}, \
		${QacPrj}/output/$(notdir $<).qar, -hw-)

# Optional full message dispatching including suppressed messages on
# code level
ifeq ($(QAC_CALC_SUP), ON)
	$(call QacDispatchToFile, \
		${QacOutputFormatQAR}, \
		${QacPrj}/output/$(notdir $<)_full.qar, -hw+)
endif

# Dependency retrieval (for incremental builds next time of the
# current target)
	@echo "Retrieving dependencies of '$(notdir $<)'."
	${GCCBIN} \
		${IPath} \
		${CC_DEFINES_GNU} \
		-MM -E -MT ${DepTargetPattern_Qac} \
		-MF ${DepFilePattern_Qac} $<

# Filter relative path expressions within instructions like #include
# "..\file_on_parentlevel.h"
# E.g. parent_folder/child_folder/../file_on_parentlevel.h to
# parent_folder/file_on_parentlevel.h otherwise dependency-rules lead
# to "no rule to make target" error breaking the build
# Filtering takes place in two steps:
# a) convert backslash into slash (execept those at end of line)
	$(SEDBIN) \
		-e's/\\/\//g' -e 's/ \// \\/g' \
		${DepFilePattern_Qac} \
	> ${DepFilePattern_Qac}.tmp
# b) convert parent/..\subfolder/file.h to parent/file.h
	$(SEDBIN) \
		-e's/\/[a-zA-Z0-9_-]*\/\.\.\//\//g' \
		${DepFilePattern_Qac}.tmp \
	> ${DepFilePattern_Qac}
	rm -f ${DepFilePattern_Qac}.tmp


######################################################################
#  Clean analysis output directory                        
######################################################################
.PHONY: qac_clean
qac_clean:
	@echo "Cleaning QAC output."
	rm -f ${QacPrj}/output/*.*

	@echo "Cleaning QAC lists."
	rm -f ${SrcListDir_Qac}/*.*


######################################################################
#  Generate CMA - Cross module analysis                   
######################################################################
.PHONY: qac_cma
qac_cma:
	@echo "Generating input list of all $(words ${SrcList_Qac})" \
		"analyzed files for cross-module analysis (CMA)."
	echo   > ${QacPrj}/output/qac_filelist.txt
	for i in ${SrcList_Qac_Dir}; \
	do \
		echo $$i >> ${QacPrj}/output/qac_filelist.txt; \
	done

	@echo "Processing cross-module analysis (CMA)."
	rm -f ${QacPrj}/output/project_metrics.2met
	rm -f ${QacPrj}/output/project_metrics.2err

	${QACPALEXE} QAC \
	    ${ProjectConfig} \
	    -cmaf ${QacPrj}/output/project_metrics \
	    -op ${QacPrj}/output \
	    -list ${QacPrj}/output/qac_filelist.txt

	@echo "Calling canned sequence dispatching at project metrics."
	$(call QacDispatchMetrics, \
		${QacOutputFormatQAR}, \
		project_metrics)


######################################################################
# Target for report post processing (Excel).
######################################################################
.PHONY: qac_report
qac_report:
	rm -f ${QacPrj}/report/*.qar
	rm -f ${QacPrj}/report/*.qars
	rm -f ${QacPrj}/report/QACResult.*
	cp ${QacPrj}/output/*.qar ${QacPrj}/report

# Each qar-file gets sorted and results are copied to *.qars file

	$(FINDBIN) \
		${QacPrj}/report \
		-wholename "*.c.qar" \
		-execdir $(SORTBIN) {} -o '{}s' \;
# Messages of all *.qars files are collected in single file:
# QACResult.qar Redundant lines and empty line ares filtered out. This
# file is afterwards ready for import into Excel for detailed post
# processing.

	echo -e ${QAC_CSV_HEADER} \
	> ${QacPrj}/report/QACResult.tmp

# Explanations regarding the following line: fl=*.qars stores a list
# of qars files in variable fl.  cat $fl streams the contents of
# *.qars files to stdout (the '$$' is required due to make behaviour)
# sed -e '/^$$/d' filters out empty lines. uniq filters out redundant
# lines before streaming whole stuff to final file.

	cd ${QacPrj}/report;fl=*.c.qars; \
	cat $$fl | $(SEDBIN) -e '/^$$/d' \
	| $(SORTBIN) \
	> QACResult.tmp

# additional/optional summary of code level suppressed messages
ifeq ($(QAC_CALC_SUP), ON)
	cp ${QacPrj}/output/*.c_full.qar ${QacPrj}/report
	$(FINDBIN) \
		${QacPrj}/report \
		-wholename "*.c_full.qar" \
		-execdir $(SORTBIN) {} -o {}s  \;

	cd ${QacPrj}/report;fl=*.c_full.qars; \
	cat $$fl \
	| $(SEDBIN) -e '/^$$/d' \
	> QACResultSup.tmp

# Sort messsage files before extracting of suppressed messages
	$(SORTBIN) ${QacPrj}/report/QACResultSup.tmp \
	| $(UNIQBIN) \
	> ${QacPrj}/report/QACResultSup.sot

	$(SORTBIN) ${QacPrj}/report/QACResult.tmp \
	| $(UNIQBIN) \
	> ${QacPrj}/report/QACResult.sot
# Comparison using comm.exe. Comm Option -3 reduces the comparison
# output of file1 & file2 to those vpath entries being unique to
# FilePathFull. Note: option -3 works pretty if QACResult.sot is subset
# of QACResultSup.
	$(COMMBIN) -3 \
		${QacPrj}/report/QACResultSup.sot \
		${QacPrj}/report/QACResult.sot \
	> ${QacPrj}/report/QACResultSup.tmp

# Finalize both result-files by adding title row as header
	@echo "Creating summarised QAC error file : QACResult.qar"
	echo -e ${QAC_CSV_HEADER} \
	> ${QacPrj}/report/QACResult.qar

	cat ${QacPrj}/report/QACResult.tmp \
	| $(UNIQBIN) \
	>> ${QacPrj}/report/QACResult.qar

	@echo "Creating summarised QAC error file : QACResultSup.qar"
	echo -e ${QAC_CSV_HEADER} \
	> ${QacPrj}/report/QACResultSup.qar

	cat ${QacPrj}/report/QACResultSup.tmp \
	| $(UNIQBIN) \
	>> ${QacPrj}/report/QACResultSup.qar

	rm -f ${QacPrj}/report/*.tmp
	rm -f ${QacPrj}/report/*.sot
	rm -f ${QacPrj}/report/*.c_full.qar
endif

	rm ${QacPrj}/report/*.qars
	rm ${QacPrj}/report/*.c.qar

######################################################################
# Target for build QA-C analysis for changed source files and report
# post processing (excel)
######################################################################
.PHONY: qac_report_all
qac_report_all:
	$(MAKE) QAC_SILENT=ON qac_all
	$(MAKE) qac_report
	$(MAKE) QAC_SILENT=ON qac_modulelist


######################################################################
# Target for rebuild QA-C analysis and report post processing (excel)
######################################################################
.PHONY: qac_report_all_rebuild
qac_report_all_rebuild:
	$(MAKE) QAC_SILENT=ON qac_all_rebuild
	$(MAKE) qac_report
	$(MAKE) QAC_SILENT=ON qac_modulelist


######################################################################
# Post-processing of accumulated message suppressions.
######################################################################
.PHONY: qac_read_messages
qac_read_messages:
	@echo "Message suppression filtering not possible at the moment."


######################################################################
# Create list of all analyzed source files.
######################################################################
.PHONY: qac_modulelist
qac_modulelist: checktools
	@echo "Generating list of all ${ModuleListSize_Qac} modules " \
		"checked by QAC."
	echo > ${QacPrj}/report/qac_modulelist.txt
	for i in ${ModuleList_Qac}; \
	do \
		echo $$i >> ${QacPrj}/report/qac_modulelist.txt; \
	done

ifneq (${QAC_SILENT}, ON)
	cat ${QacPrj}/report/qac_modulelist.txt
endif
