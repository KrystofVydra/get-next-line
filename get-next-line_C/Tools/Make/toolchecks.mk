# SVN-Id: $Id: toolchecks.mk 60051 2017-07-06 08:28:06Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/toolchecks.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# Check if the tools needed for executing the make process are
# available.
######################################################################


######################################################################
# Definition of tool lists to be used with checktools_XXX target
# below.
######################################################################

# Basic Tools - tools that are required everywhere in the make process
FINDBIN = "${MSYS}/find.exe"
SEDBIN  = "${MSYS}/sed.exe"
COMMBIN = "${MSYS}/comm.exe"
SORTBIN = "${MSYS}/sort.exe"
UNIQBIN = "${MSYS}/uniq.exe"
CATBIN  = "${MSYS}/cat.exe"
RMBIN   = "${MSYS}/rm.exe"
MKDIRBIN= "${MSYS}/mkdir.exe"
GCCBIN  = "${MINGW}/gcc.exe"

TOOLLIST_BASIC = $(FINDBIN) $(SEDBIN) $(COMMBIN) $(SORTBIN) \
	$(UNIQBIN) $(CATBIN) $(RMBIN) $(MKDIRBIN) $(GCCBIN)


# QAC Tools - tools needed for QA-C / MISRA checking
QACEXE    = "${QAC_PATH}/bin/qac.exe"
QACDSPEXE = "${QAC_PATH}/bin/errdsp.exe"
CMEXE     = "${QAC_PATH}/M2CM/bin/qacsa_m2cm.exe"
QACPALEXE = "${QAC_PATH}/bin/pal.exe"

TOOLLIST_QAC = $(QACEXE) $(QACDSPEXE) $(CMEXE) $(QACPALEXE)


# Compiler tools
TOOLLIST_COMPILER = ${CC} ${ASM} ${LD}


# Tessy Tools
TESSY_BIN = "$(TESSY_PATH)/bin/tessycmd.exe"
TESSYD_BIN = "$(TESSY_PATH)/bin/tessyd.exe"
SVN_BIN = "${SVN_PATH}/bin/svn.exe"

TOOLLIST_TESSY = ${TESSY_BIN} ${TESSYD_BIN} ${SVN_BIN}


# Svnversion
SVNVERSION_BIN = "$(SVN_PATH)/bin/svnversion.exe"

TOOLLIST_SVNVERSION = ${SVNVERSION_BIN}


######################################################################
# Check if all tools in a tool list do exist.
#
# This rule matches all checktools_XXX targets and then accesses the
# TOOLLIST_XXX variable to check the listed tools.
######################################################################
.PHONY: checktools_%
checktools_%: TOOLLIST_NAME=TOOLLIST_$*
checktools_%:
	@echo "Checking tool list '$*'.";
	$(foreach TOOL,$($(TOOLLIST_NAME)), \
	    if [ ! -x $(TOOL) ]; then \
	        echo "ERROR: Cannot find or execute '$(TOOL)'."; \
	        exit 1; \
		fi; \
	)
	@echo "Tool list '$*' checked. Everything's fine."
