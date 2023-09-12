# SVN-Id: $$Id: tessy_opt.mk 72611 2018-03-07 10:00:52Z hugen999 $$
# SVN-Url: $$HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/config/tessy_opt.mk $$

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# Tessy unit test batch operation options. This is a user
# configuration file and intended to be modified.
#
######################################################################


########################################################################################
# USER settings 			                                                           #
########################################################################################

#projectname will be in the reports
TessyProjectName       =Tessy_project
# testcollection name will be in the reports
#CAUTION: no spaces after this Name
TessyCollectionName    =base

#use the variant variable in this path (no absulute path),
#will be used for normal import and SVN Check
restorepath = $(TessyPrj)/backup

requirementspath = $(TessyPrj)/requirements

#path of stubfolder
#all header with same name are delted from generated Header_Files folder
#CAUTION: folder and subfolder have to be included seperat in tessy_opt.mk for configuration file
stubpath = $(TessyPrj)/stubs

#This Include-Path is BEFORE all other Include-Path in default_configuration.xml 

TESSY_USER_INC_PATH = 

#==========================================================
# T E S S Y  D E F I N E S
#
# Note: CC_DEFINES_TESSY may define constants for Tessy
#       analysis & test execution. You may add here 
#       definitions controlling features impacting the
#       test execution. If Tessy tests are carried out
#       based on GNU compiler, you may specify here
#       target compiler intrinsic definitions (see QAC section)  
#==========================================================

CC_DEFLIST_TESSY = $(CC_DEFLIST) 
CC_DEFLIST_TESSY += #MY_UNIT_TEST_OPTION

# this must be an existing Doors Folder, doors_requirement export, will search automaticly in all 
# subfolders and export all requirements			 
Doors_Export_Folder = /Project/06_Software Requirements Specifications

# requirements will be exported with this View
# CAUTION: This view should only display requiremnts with useful text 
Doors_View = _LKRequTest

# Module list (SW Unit List) excel document location (for generation of tessy modules)
SWUnitListXLS = $(TessyPrj)/lists/DOC01725185-0000_ModulesListExample4.xls

#define your own test, use tessy_clean_up_usr_tbs to clean up testobjects to template
#CAUTION: Jenkins need a test execution and overview report (one or more)
#TessyUsrTbs = $(TessyPrj)/batch_test_usr.tbs


##############      OPTIONS                  ###########################################

# copy_header == ON --> automatic copy of all header in header_filtered into a folder for Tessy Include
#						whenever tessy_sync is executed
TESSY_COPY_HEADER=ON

# test_one_by_one == ON --> automatic test and create Overview Report for each module
#							not one for all
TEST_ONE_BY_ONE =ON

# import_requirements == ON --> automatic import all requirements from requirementspath
#
IMPORT_REQUIREMENTS = OFF

##############      ADVANCED OPTIONS         ###########################################
# only_import == ON --> do only the import not the tests
#					 
ONLY_IMPORT=OFF

# flatten == ON --> imports without folder structure (ignores parallel import) 
#
FLATTEN = ON

# HTTP-Timeout for time consuming actions
# in sec => 3600 = 1h
# 			86400 = 1d
TESSY_CMD_TIMEOUT=86400

# auto disconnect == ON --> automatic disconnect in advance of any connect
TESSY_AUTO_DISCONNECT=ON

# auto sync == ON --> Tessy environment config is synchronized whenever preparelists are
#                     updated (not useful in combination with header_copy on)
TESSY_AUTO_SYNC=OFF