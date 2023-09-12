# SVN-Id: $Id: link_opt.mk 71369 2018-02-12 08:14:48Z kraehe02 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/config/link_opt.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# Linker related options. This is a user configuration file and
# intended to be modified.
#
######################################################################

# Linker executable
# Example:
#   LD = $(COMPILER_PATH)/bin/xlink.exe
LD = ${COMPILER_PATH}/gcc.exe

# Linker options common for all build modes.
LDFLAGS_COMMON = ${SPACE}

# Linker options specific to 'release' build mode.
LDFLAGS_RELEASE = ${LDFLAGS_COMMON}

# Linker options specific to 'debug' build mode.
LDFLAGS_DEBUG   = ${LDFLAGS_COMMON} -g

# Linker options specific to 'integration' build mode.
LDFLAGS_INTEGRATION   = ${LDFLAGS_COMMON} -g
