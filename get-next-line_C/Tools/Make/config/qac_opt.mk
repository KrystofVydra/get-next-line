# SVN-Id: $Id: qac_opt.mk 69803 2018-01-11 07:12:38Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/config/qac_opt.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# QA-C analysis options. This is a user configuration file and
# intended to be modified.
#
######################################################################


#=======================================================================================
# QA-C  D E F I N E S
#
# CC_DEFINES_QAC may define constants for QA-C
# analysis execution. You may add here 
# definitions controlling features impacting the
# analysis execution. You may specify here
# target compiler intrinsic definitions to let QA-C
# properly parse the sources
#
# Note: CC_DEFINES_QAC is necessary for QAC analysis call, thus it must not be deleted!
# 
#=======================================================================================

CC_DEFLIST_QAC = $(CC_DEFLIST)

# Example: Tasking Compiler intrinsics and project specific ones  
#CC_DEFLIST_QAC += __CTC__
#CC_DEFLIST_QAC += GCC
#CC_DEFLIST_QAC += QAC
#CC_DEFLIST_QAC += PRQA_PTRDIFF_T

# Example: Publishing IAR compiler intrinsic definitions
#
#CC_DEFINES_IAR = -D__IAR_SYSTEMS_ICC__=7 \
#                 -D__FLOAT_SIZE__=4 \
#                 -D__DOUBLE_SIZE__=4 \
#                 -D__INT_SIZE__=2 \
#                 -D__TID__=21776 \
#                 -D__ATTRIBUTES_NORETURN="" \
#                 -D__ATTRIBUTES="" \
#                 -D__no_bit_access="" \
#                 -D__no_init="" \
#                 -D__near="" \
#                 -D__intrinsic="" \
#                 -D__huge="" \
#                 -D__SIZE_T_TYPE__="unsigned int" \
#                 -D__WCHAR_T_TYPE__="unsigned char" \
#                 -D__PTRDIFF_T_TYPE__="char *"
#
#CC_DEFINES_QAC += ${CC_DEFINES_IAR}


