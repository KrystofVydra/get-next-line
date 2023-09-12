# Makefile for QAC 9 analysis

# Configuration settings

QAC9_FMT = "%?u==0%(%F:%l: %?g<9%(%?g<1%(info%:warning%)%:error%): %N g%G %v %t%)"

#QAC9_FMT = "%F:%l: %N g%g %t - %v"
#QAC9_FMT = "%F(%l,%c): %?u==0%(%?h%(Err%:Msg%)%:-->%)(%G:%N) %R(%u, )%t%?v%(\n%v%)"

# Local project path to store QAC configuration files
QAC9_PRJPATH=../prqaconfig
QAC9_PRJPATH_SINGLE=../prqaconfig_single

recentcheck=
-include ${QAC9_PRJPATH_SINGLE}/recentsinglefilecheck.mk

# Compiler configuration. As default use the generic C setup.
#QAC9_COMPILER_CFG=${QAC9_PATH}/config/cct/PRQA_Generic_C.cct
QAC9_COMPILER_CFG=${QAC9_PATH}/config/cct/GHS_gcc_2013.5_x86_RH850_C.cct

# Rule configuration file
QAC9_RULE_CFG=${QacPrj}/config/LK_m3cm-2_1_0-en_US.rcf
#QAC9_RULE_CFG=${QacPrj}/config/m3cm_With_CERT.rcf

# Component selection file
# Info: m2cm license is not available
QAC9_ACF_CFG=${QacPrj}/config/m3cm.acf

# Debug level for internal qacli.exe log files. One of NONE, ERROR, INFO, 
# DEBUG or TRACE.
QAC9_DEBUG_LEVEL=INFO

# QAC_REPORT_2012_SUPPORT: controls, if the TAB QAC_Result in
# the old Excel MISRA_Report.xls should still be supported
QAC_REPORT_2012_SUPPORT = OFF

# TBD: include path stdlib
QAC9_STDLIB_HEADERS = ${QAC9_PATH}/config/cct/DATA/PRQA_Generic_C/Stub/include/iso_c

# Blacklist QAC is included in Makefile, it is included in MK_CONFIG_FILES
#include ${QacPrj}/blacklist_qac.mk

#
# Internal variables, do not modify.
#


# List of all C files. Files from qac_blacklist filtered out.
QAC9_SRC_LIST = $(filter-out ${blacklist_source_qac},${source})
#QAC9_SRC_LIST = ${source}
SrcList_Qac = $(notdir ${QAC9_SRC_LIST})

# Include search path. We prepend the internal QAC standard ISO C header files, 
# so they are found before the embedded compiler headers. 
QAC9_IPATH = -I$(shell cygpath -ma ../prqaconfig/prqa/config/DATA/PRQA_Generic_C/Stub/include/iso_c) \
	$(addprefix -I,$(foreach path,$(strip $(IncludePaths)),$(shell cygpath -ma ${path})))
	
QAC9_DEFINES = $(addprefix -D, ${CC_DEFLIST_QAC})

# List of files to add to PRQA project
QAC9_SOURCELIST = lists/qac_filedef.txt

# Target extension for single file misra check
QACERR_EXT              = .c.err

# Completely rebuild configuration, add files, then analyze and show results.
.PHONY: qac_all_rebuild
qac_all_rebuild:
	$(MAKE) ${MAKE_SILENT} -r preparelists
	$(MAKE) qac_gen_project
	-$(MAKE) qac_analyze
	$(MAKE) qac_view


# Re-add files to the project (perhaps there are new ones), run the analysis 
# (qac keeps track of changed files) and show the results.
.PHONY: qac_all
qac_all:
	-$(MAKE) qac_analyze
	$(MAKE) qac_view


#
# Purges the whole PRQA project configuration. 
#
# After you run this, you need to re-generate the configuration with the 
# qac_gen_project target.
#
qac_distclean:
	@echo "Full cleanup of PRQA project configuration."
	$(MUTE)if [ -d ${QAC9_PRJPATH} ]; \
	then \
		rm -rf ${QAC9_PRJPATH}; \
	fi;
	$(MUTE)mkdir -p ${QAC9_PRJPATH}


#
# Generate a fresh PRQA project configuration.
# 
.PHONY: qac_gen_project qac_add_files qac_analyze
qac_gen_project: qac_distclean
	@echo "Ensure PRQA project directory exists."
	$(MUTE)mkdir -p ${QAC9_PRJPATH};

# Set debug level for qacli.exe logging
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--debug-level ${QAC9_DEBUG_LEVEL};
		
	@echo "Generating basic PRQA project configuration."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH} \
		--qaf-project-config \
		--cct ${QAC9_COMPILER_CFG} \
		--rcf ${QAC9_RULE_CFG} \
		--acf ${QAC9_ACF_CFG}
		
# Set source root directory, so relative paths work.
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH} \
		--set-source-code-root $$(cygpath -ma ../../)
	
	$(MUTE)$(MAKE) qac_add_files


#
# Add all source files to the project for analysis.
#
# This adds all files, which are in the compiler source list and not matching a
# blacklist entry from the QAC blacklist. 
#
.PHONY: qac_add_files
qac_add_files:
	@echo "Generating source list for QA-C."
	$(MUTE)for file in ${QAC9_SRC_LIST}; \
	do \
		echo ${QAC9_IPATH} ${QAC9_DEFINES} $$(cygpath -ma $$file); \
	done > ${QAC9_SOURCELIST}
	
	@echo "Adding source files to PRQA project."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH} \
		--add-files ${QAC9_SOURCELIST}

# Add blacklist items. Takes a long time :-(
	@echo Setting QAC header blacklist.
	$(MUTE)for item in ${blacklist_header_qac}; \
	do \
		${QAC9_PATH}/common/bin/qacli.exe \
			pprops \
			--qaf-project ${QAC9_PRJPATH} \
			-c qac-9.1.0 \
			-o -quiet \
			--set $$(cygpath -ma $${item}); \
	done
	
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		pprops --qaf-project ${QAC9_PRJPATH} -c qac-9.1.0 \
		-o -i --set ${QAC9_STDLIB_HEADERS}
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		pprops --qaf-project ${QAC9_PRJPATH} -c qac-9.1.0 \
		-o -q --set ${QAC9_STDLIB_HEADERS}
	

#
# Run the QAC analysis
#
.PHONY: qac_analyze
qac_analyze:
	@echo "Setting up QAC for parallel analysis with ${NUMBER_OF_PROCESSORS} cpus."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH} \
		--set-cpus ${NUMBER_OF_PROCESSORS};
		
	@echo "Analyzing full project ..."
	-$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		analyze \
		--qaf-project ${QAC9_PRJPATH} \
		--generate-preprocessed-source \
		--file-based-analysis \
		--repeat 2

#
# Show all analysis results.
#
qac_view:
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		view \
		--qaf-project ${QAC9_PRJPATH} \
		--medium STDOUT \
		--format ${QAC9_FMT} \
		--rules \
		| tee ${QAC9_PRJPATH}/prqa/output/qac_cli_output.qar


#
# Generate all available QA-C reports from the stored analysis data.
#
# CRR = Code Review Report
# SUR = Suppression Report
# RCR = Rule Compliance Report
#
#
.PHONY: qac_report
qac_report:
	$(MUTE)for rt in RCR MDR SUR CRR; \
	do \
		echo "Generating QA-C report type '$${rt}'."; \
		${QAC9_PATH}/common/bin/qacli.exe \
			report \
			--qaf-project ${QAC9_PRJPATH} \
			--type $${rt}; \
	done
	
#   BEGIN schoe001 
ifeq ($(QAC_REPORT_2012_SUPPORT), ON)
#   Dispatching all results (QAC, MISRA, LKCM) to file for report post-processing (all messages are stored)
#   Supoort of MISRA 2012 for old MISRA-Report.xls
	-@rm -f ${QacPrj}/report/QACResult.*
	@echo -e "Dateiname\\tZeile\\tSpalte\\tLevel\\tCode\\tMeldung\\tMISRA-Regel\\tReference" > ${QacPrj}/report/QACResult.qar
	# sed -e '/^$$/d' filters out empty lines
	cat ${QAC9_PRJPATH}/prqa/output/qac_cli_output.qar | $(SEDBIN) -e '/^$$/d' >> ${QacPrj}/report/QACResult.qar
	
	$(FINDBIN) ${QacPrj}/report -wholename "*.qar" -execdir $(SORTBIN) {} -o '{}s'  \; 
	@cd ${QacPrj}/report;fl=*.c.qars; cat $$fl | $(SEDBIN) -e '/^$$/d' |$(SORTBIN) > QACResult.tmp
	@$(SORTBIN) ${QacPrj}/report/QACResultSup.tmp |$(UNIQBIN) > ${QacPrj}/report/QACResultSup.sot
	@$(SORTBIN) ${QacPrj}/report/QACResult.tmp |$(UNIQBIN) > ${QacPrj}/report/QACResult.sot
endif		
#   END schoe001 


#
# Clean up the result data in the PRQA config directory
#
# This does not change the project configuration, but discards all stored 
# analysis results.
#
.PHONY: qac_clean
qac_clean:
	@echo "Cleaning result data from PRQA project."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		analyze \
		--qaf-project ${QAC9_PRJPATH} \
		--clean
		
.PHONY: qac_report_all_rebuild
qac_report_all_rebuild:
	${MUTE}$(MAKE) ${MAKE_SILENT} -k -r QAC_SILENT=ON qac_all_rebuild 
	${MUTE}$(MAKE) ${MAKE_SILENT} -r qac_report_all

	
.PHONY: qac_report_all
qac_report_all: 
	${MUTE}$(MAKE) ${MAKE_SILENT} -r qac_report 

%${QACERR_EXT}: %.c  
	@echo "----------"
	@echo "Last check:    ${recentcheck}"
	@echo "Current check: $<"
	@echo "----------"
	$(MUTE)if test "${recentcheck}" == "$<"; \
	then \
		echo repeating check for $(recentcheck) ; \
		$(MAKE) -r qac_single_file_repeat ; \
	else \
		echo "Create new PRQA project configuration for file $<." ; \
		rm -rf ${QAC9_PRJPATH_SINGLE}; \
		mkdir -p ${QAC9_PRJPATH_SINGLE}; \
		echo "recentcheck=$<" > ${QAC9_PRJPATH_SINGLE}/recentsinglefilecheck.mk ; \
		recentcheck=$< ;\
		$(MAKE) -r qac_single_file_initial ; \
	fi;
	
.PHONY: qac_single_file_initial
qac_single_file_initial:
# Set debug level for qacli.exe logging
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--debug-level ${QAC9_DEBUG_LEVEL};
		
	@echo "Generating basic PRQA project configuration."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--qaf-project-config \
		--cct ${QAC9_COMPILER_CFG} \
		--rcf ${QAC9_RULE_CFG} \
		--acf ${QAC9_ACF_CFG}
		
# Set source root directory, so relative paths work.
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--set-source-code-root $$(cygpath -ma ../../)
		
	@echo "Cleaning result data from PRQA project."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		analyze \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--clean
	
	@echo "Adding source file ${recentcheck} to PRQA project."
	$(MUTE)echo ${QAC9_IPATH} ${QAC9_DEFINES} $$(cygpath -ma ${recentcheck}) > ${QAC9_SOURCELIST}
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--add-files ${QAC9_SOURCELIST}
		
	@echo Setting QAC header blacklist.
	$(MUTE)for item in ${blacklist_header_qac}; \
	do \
		${QAC9_PATH}/common/bin/qacli.exe \
			pprops \
			--qaf-project ${QAC9_PRJPATH_SINGLE} \
			-c qac-9.1.0 \
			-o -quiet \
			--set $$(cygpath -ma $${item}); \
	done
	
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		pprops --qaf-project ${QAC9_PRJPATH_SINGLE} -c qac-9.1.0 \
		-o -i --set ${QAC9_STDLIB_HEADERS}
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		pprops --qaf-project ${QAC9_PRJPATH_SINGLE} -c qac-9.1.0 \
		-o -q --set ${QAC9_STDLIB_HEADERS}
	
	@echo "Setting up QAC for parallel analysis with ${NUMBER_OF_PROCESSORS} cpus."
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		admin \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--set-cpus ${NUMBER_OF_PROCESSORS};
		
	@echo "Analyzing single project ..."
	-$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		analyze \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--generate-preprocessed-source \
		--file-based-analysis \
		--repeat 2
		
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		view \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--medium STDOUT \
		--format ${QAC9_FMT} \
		--rules \
		--no-header-messages \
		| sort -t : -k 3 -g \
		| tee ${QAC9_PRJPATH_SINGLE}/prqa/output/qac_cli_output.qar

.PHONY: qac_single_file_repeat
qac_single_file_repeat:
	@echo "Repeat analysis of recent single project ..."
	-$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		analyze \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--generate-preprocessed-source \
		--file-based-analysis \
		--repeat 2
		
	$(MUTE)${QAC9_PATH}/common/bin/qacli.exe \
		view \
		--qaf-project ${QAC9_PRJPATH_SINGLE} \
		--medium STDOUT \
		--format ${QAC9_FMT} \
		--rules \
		--no-header-messages \
		| sort -t : -k 3 -g \
		| tee ${QAC9_PRJPATH_SINGLE}/prqa/output/qac_cli_output.qar
		
.PHONY: qac_supression_list_gen
qac_supression_list_gen:
	@echo "Generating List of all suppressions including justification"
	${QacPrj}/QACSupressionListGen/QacSuppressionListGen.exe ../../Source ${QacPrj}/QACSupressionListGen/Suppressions.csv ./suppressions_junit_testreport.xml ../../Tools/Make/lists/qac_header_list_with_path.txt ../../Tools/Make/lists/qac_blacklist_header.txt ../../Tools/Make/lists/qac_source_list.txt
