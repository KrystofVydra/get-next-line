# SVN-Id: $Id: compile_opt.mk 71369 2018-02-12 08:14:48Z kraehe02 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/config/compile_opt.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# Compiler related options. This is a user configuration file and
# intended to be modified.
#
######################################################################

# Compiler executable
CC = $(COMPILER_PATH)/gcc.exe

# Compiler options common to all build modes.
CFLAGS_COMMON = -c -Wall -pedantic

# Compiler options specific to 'debug' build mode.
CFLAGS_DEBUG  = ${CFLAGS_COMMON} -g -DLK_DEBUG

# Compiler options specific to 'integration' build mode.
CFLAGS_INTEGRATION  = ${CFLAGS_COMMON} -g -DLK_INTEGRATION

#Compiler options specific to 'release' build mode.
CFLAGS_RELEASE = ${CFLAGS_COMMON}

######################################################################
# Compiler defines
######################################################################

# List of defines
#
# The -D option has to be omitted here since it is programmatically
# added to each string afterwards
CC_DEFLIST = SVNVERSION="${SVN_WC_REV}" ANYDEF1=5 ANYDEF2=17


######################################################################
# Dependency Check
######################################################################

ifneq (${DEP_CHECK_GNU}, ON)
# GNU Dependency check is disabled.
#
# If capable, target compiler may carry out this task on 
# single source compile.
# Example: IAR compiler:
#   CC_DEP_CHECK = "--dependencies=m ${DepFilePattern}"
# Example: GNU compiler:
#   CC_DEP_CHECK = "-MM -E -MT ${DepFilePattern} -MF ${DepFilePattern}"  
CC_DEP_CHECK = 
else
# GNU Dependency check is enabled and executed automatically with the
# correct options.
endif


######################################################################
# G N U   D E F I N E S
#
# CC_DEFINES_GNU is passed to GNU compiler call for dependency
# retrieval. You may add here definitions specific to your target
# compiler, like __CTC__ for Tasking compiler. As default, the common
# CC_DEFINES are assigned here.
#
# Example:
#   CC_DEFINES_GNU = ${CC_DEFINES} -D__CTC__
######################################################################
CC_DEFLIST_GNU = ${CC_DEFLIST}
