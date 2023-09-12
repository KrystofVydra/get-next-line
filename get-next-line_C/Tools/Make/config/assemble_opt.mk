# SVN-Id: $Id: assemble_opt.mk 71369 2018-02-12 08:14:48Z kraehe02 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/config/assemble_opt.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# Assembler related options. This is a user configuration file and
# intended to be modified.
#
######################################################################


# Assembler executable
# Example:
#   ASM = $(COMPILER_PATH)/bin/Am16c.exe
ASM =

# Assembler options common for all build modes
AFLAGS_COMMON = -r -l ${ListDir}/$(basename $@).lst

# Assembler options specific to build mode 'release'.
AFLAGS_RELEASE = ${AFLAGS_COMMON}

# Assembler options specific to build mode 'debug'.
AFLAGS_DEBUG = ${AFLAGS_COMMON}

# Assembler options specific to build mode 'integration'.
AFLAGS_INTEGRATION = ${AFLAGS_COMMON}

