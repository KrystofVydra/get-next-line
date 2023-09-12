# SVN-Id: $Id: utils.mk 52032 2017-01-17 13:19:54Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/utils.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# Collection of generic tool functions used in the make process.
######################################################################


######################################################################
# Check if a variable is defined.
#
# Usage:
#  $(call CheckDefined,VarName,HelpText)
#
# Example:
#   $(call CheckDefined,CFLAGS,Compiler settings)
#
# VarName: Name of the variable to check. If it is empty, an error
#   message is printed and make is stopped.
#
# HelpText: optional, is printed with the error message if the
#   variable is not defined.
#
#
# Copied from http://stackoverflow.com/questions/10858261/
######################################################################
CheckDefined = \
    $(strip $(foreach 1,$1, \
        $(call __CheckDefined,$1,$(strip $(value 2)))))
__CheckDefined = \
    $(if $($1),, \
      $(error Undefined variable '$1' $(if $2, ($2))))


######################################################################
# Check all variables in a list are defined.
#
# Usage:
#   $(call CheckAllDefined,VarList,HelpText)
#
# Example:
#   $(call CheckAllDefined,CFLAGS AFLAGS LDFLAGS,Compiler settings)
#
# VarList: List of variables to check. If one of the variables is
#   empty, an error message is printed and make is stopped.
#
# HelpText: optional, is printed with the error message if the
#   variable is not defined.
######################################################################
CheckAllDefined = \
    $(foreach VAR_NAME,${1},$(call CheckDefined,${VAR_NAME},${2}))


######################################################################
# Utility macro containing a single space.
######################################################################
SPACE = # end of line

######################################################################
# Find duplicate items in a list
#
# Usage:
#   DUPLS = $(call FindDuplicates, List)
#
# List: String list to be checked for duplicates.
#
# Example:
#   Sets DUPLS to 'A':
#   DUPLS = $(call FindDuplicates,A C B A D)
######################################################################
FindDuplicates = $(strip $(foreach v,$(sort ${1}),$(if $(filter-out 1,$(words $(filter $v,$(1)))),$v)))

