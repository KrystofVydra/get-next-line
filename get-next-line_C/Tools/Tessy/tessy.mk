########################################################################################
#                                                                                      # 
#  MAKEFILE TEMPLATE AEP2.1                                                            # 
#  Extension makefile for Tessy Unit Testing                                           # 
#                                                                                      #                                                 # 
#                                                                                      # 
########################################################################################

########################################################################################
# Basic settings and macros: VARIABLEDEFINITION                                        #
########################################################################################
TESSY_BIN = $(TESSY_PATH)/tessycmd.exe
SVN_BIN = $(SVN_PATH)/svn.exe
DOORS2TESSY_BIN = "$(DOORS2TESSY_PATH)/Doors2TessyInterfaceConsole.exe"
DOORS_BIN = "$(DOORS_PATH)/bin/doors.exe"

include config/tessy_opt.mk

TessyEnv 			   = "GNU GCC Eclipse CDT (Default)"

TessyConfigFile        = $(realpath $(TessyPrj))/config/default_configuration.xml

SED_FILTER_DRIVE       = s/\\/\\\([a-zA-Z]\\\)\\//\\\1:\\//
ConvertDrive           = $(shell echo $(1) | $(SEDBIN) -e $(SED_FILTER_DRIVE) )
#BaseDirAbs             = $(call ConvertDrive, $(abspath $(BaseDir)))
BaseDirAbs             = $(realpath $(BaseDir))

COMMA                  = ,
# produce a 'SPACE' literal
SPACE                  =
SPACE                  +=  
# define a macro to insert separator in space separated string list
insert-separator       = $(subst $(SPACE),$1,$(strip $2))

# define restorelist variable
# to restore not all: set here each module path seperatet by \ and newline after it e.g.:
#restorelist = ../../Tests/Example.tmb\
#			   ../../Tests/Example2.tmb
restorelist 			= $(wildcard $(restorepath)/*.tmb)

requirementslist		= $(wildcard $(requirementspath)/*.xml)

stublist 				= $(shell ls $(stubpath) | egrep -o "[A-z,0-9,_,\-]*\.h")

folderlist = $(sort $(shell echo $(restorelist)| egrep -o "$(TessyProjectName)\.[A-z,0-9,\(,\,),%,_]+\." | egrep -o "\.[A-z,0-9,\(,\),%,_]+\." | egrep -o "[A-z,0-9,\(,\),%,_]+"))

# define revision-numbers
ifneq ($(wildcard ${TessyPrj}/lists/OldRevisionNumber.txt),)
oldrevnum 			= $(shell cat $(TessyPrj)/lists/OldRevisionNumber.txt)
else
oldrevnum 			=
endif

ifneq ($(wildcard ${TessyPrj}/lists/NewRevisionNumber.txt),)
newrevnum 			= $(shell cat $(TessyPrj)/lists/NewRevisionNumber.txt)
else
newrevnum 			=
endif

# Derive list of comma separated include paths to be transfered to Tessy configuration
TessyIncludes          = $(abspath $(IncludePaths))

# set user path
TessyIncludesRoot     = $(subst \\,\/, $(TESSY_USER_INC_PATH))

ifeq ($(TESSY_COPY_HEADER),ON)
	TessyIncludesRoot      += $$(PROJECTROOT)/Tools/Tessy/Header_Files
else
# replace absolute paths where feasible with Tessy project root var
	TessyIncludesRoot      += $(strip $(subst $(BaseDirAbs),$$(PROJECTROOT),$(TessyIncludes)))
endif
TessyIncludesRootSep   = $(subst /,\/, $(call insert-separator,$(COMMA),$(TessyIncludesRoot)))

# Derive list of comma separated preprocessor definitions to be transfered to Tessy configuration
CC_DEFINES_TESSY       = $(subst ",,$(strip $(call insert-separator,$(COMMA),$(CC_DEFLIST_TESSY))))

#checking if a GUI_IS_ON.txt file is existing
#(global variable) [is set in tessy_batch and deleted in tessy_batch2]
ifneq ($(wildcard ${TessyPrj}/lists/GUI_IS_ON.txt),)
TESSY_GUI_ON 			= ON
else
TESSY_GUI_ON 			= OFF
endif

ifeq ($(CI_SERVER),ON)
#international LINK
BuildLinkWithSpace=http://debejenk002.de.kostal.int:80/
#add the ending of the national Link
BuildLinkWithSpace +=$(shell echo ${BUILD_URL} | egrep -o "job.*")
BuildLinkWithSpace +=artifact/
BuildLinkWithSpace +=Tools/Tessy/report/Tessy_html_content/
#delete Spaces
BuildLink = $(subst $(SPACE),,$(BuildLinkWithSpace))
#escape the slashes for the SED command
BuildLinkSED = $(subst /,\/,$(BuildLink))
JobName = ${JOB_NAME}
JobNameSED = $(subst /,\/,$(JobName))
ONLY_IMPORT=OFF
endif

restorepathSEDwithSpace = $(subst /,\/, $(shell echo $(abspath $(restorepath))))
restorepathSED = $(subst $(SPACE),,$(restorepathSEDwithSpace))

# Doors Requirement Export
ifneq ($(wildcard $(requirementspath)/RS_SW_URLs.txt),)
DoorsURLs 			= $(subst &,\&, $(subst ?,\?, $(subst /,\/, $(shell cat $(requirementspath)/RS_SW_URLs.txt))))
else
DoorsURLs			=
endif	

# for module generation
ifneq ($(wildcard ${TessyPrj}/lists/SWunitList.txt),)
SWUnitList			= $(subst $(COMMA), $(SPACE), $(shell cat ${TessyPrj}/lists/SWunitList.txt))
else
SWUnitList			=
endif

########################################################################################
# special target to publish Tessy project name, need by CI to open Tessy targeting the #
# right project.                                                                       #
########################################################################################

.PHONY: tessy_prepare_ci
tessy_prepare_ci:
	@echo "-p $(TessyProjectName)" > ${SrcListDir_Tessy}/TessyProjectName.txt

########################################################################################
# target expressing dependency of environment configuration to headerlist and          #
# tessy compiler options                                                               #
########################################################################################

$(TessyConfigFile): ${SrcListDir}/headerlist.mk tessy_opt.mk
ifeq ($(TESSY_AUTO_SYNC),ON)
	$(MUTE)$(MAKE) $(MAKE_SILENT) tessy_sync
endif

########################################################################################
# target to copy all relevant Header into one folder                                   #
########################################################################################
header_copy:
	@echo creating new folder: Header_Files
	$(MUTE)$(IGNORE) mkdir -p $(TessyPrj)/Header_Files
	$(MUTE)$(IGNORE) rm -r $(TessyPrj)/Header_Files
	$(MUTE)$(IGNORE) mkdir $(TessyPrj)/Header_Files
	@echo copy all headers from  header_filtered list
	$(MUTE)$(foreach file,$(header_filtered), cp $(file) $(TessyPrj)/Header_Files;)
	@echo remove the files named like stub files
	$(MUTE)$(IGNORE)$(foreach file,$(stublist), if [ -f $(TessyPrj)/Header_Files/$(file) ];then rm $(TessyPrj)/Header_Files/$(file);fi;)

########################################################################################
# target transferring of project include-paths and preprocessor defines                #
# to Tessy Environment configuration file                                              #
########################################################################################

tessy_sync: checktools_BASIC
ifeq ($(TESSY_COPY_HEADER),ON)
	@echo copy on
	$(MUTE)$(MAKE) header_copy
endif		
	@echo forwarding compiler defines to Tessy environment configuration
	$(MUTE)$(SEDBIN) -e 's/<property type="String"*.*/<property type="String" name="Compiler Defines" value="$(CC_DEFINES_TESSY)" flags="0x90040049"\/>/' \
	                  $(TessyPrj)/config/template_default_configuration.xml > tessy_env_temp.xml
	$(MUTE)mv -f tessy_env_temp.xml $(TessyPrj)/config/default_configuration.xml

	@echo forwarding include paths to Tessy environment configuration
	$(MUTE)$(SEDBIN) -e 's/<property type="Directory"*.*/<property type="Directory" name="Compiler Includes" value="$(TessyIncludesRootSep)" flags="0x90040049"\/>/' \
	                  -e 's/\//\\/g' -e 's/<\\/<\//g' -e 's/\\>/\/>/g' $(TessyPrj)/config/default_configuration.xml > tessy_env_temp.xml
	$(MUTE)mv -f tessy_env_temp.xml $(TessyPrj)/config/default_configuration.xml
	@echo setting project name in tessy.pdbx
	$(MUTE)$(SEDBIN) -e 's/name=*.*/name="$(TessyProjectName)"/' \
	                  $(TessyPrj)/tessy.pdbx > $(TessyPrj)/tessy_tmp.pdbx
	$(MUTE) mv -f $(TessyPrj)/tessy_tmp.pdbx $(TessyPrj)/tessy.pdbx  
	@echo setting configuration in tessy.pdbx
	$(MUTE)$(SEDBIN) -e 's/configuration=*.*/configuration="$$(PROJECTROOT)\\Tools\\Tessy\\config\\default_configuration.xml"/' \
	                  $(TessyPrj)/tessy.pdbx > $(TessyPrj)/tessy_tmp.pdbx
	$(MUTE) mv -f $(TessyPrj)/tessy_tmp.pdbx $(TessyPrj)/tessy.pdbx
	
	@echo setting restorepath in tessy.pdbx
	$(MUTE)$(SEDBIN) -e 's/backup=*.*/backup="$(restorepathSED)"/' \
	                  $(TessyPrj)/tessy.pdbx > $(TessyPrj)/tessy_tmp.pdbx
	$(MUTE) mv -f $(TessyPrj)/tessy_tmp.pdbx $(TessyPrj)/tessy.pdbx
########################################################################################
# central sequence handling Tessy batch processing         						       #
########################################################################################

.PHONY: tessy_batch
tessy_batch: checktools_BASIC checktools_TESSY
	@echo starting Tessy batchtest sequence

	$(MUTE)$(IGNORE) mkdir -p $(TessyPrj)/lists
	
	$(MUTE) rm -f $(TessyPrj)/lists/GUI_IS_ON.*  
	
	@echo starting Tessy instance headless with $(TESSY_CMDLINE_PATH)/tessyd.exe
	$(IGNORE)$(MUTE)$(TESSY_CMDLINE_PATH)/tessyd.exe --dont-breakaway-from-job -t 180 --file $(TessyPrj)/tessy.pdbx;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "GUI is maybe running ?!";\
	echo ON >> ${TessyPrj}/lists/GUI_IS_ON.txt;\
	fi

ifneq ($(TESSY_AUTO_DISCONNECT),)
	$(IGNORE)$(MUTE)$(TESSY_BIN) disconnect
endif

	@echo connecting Tessy instance
	$(IGNORE)$(MUTE)$(TESSY_BIN) connect;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi

	@echo selecting project $(TessyProjectName)
	$(IGNORE)$(MUTE)$(TESSY_BIN) select-project $(TessyProjectName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi

	@echo select Testcollection
	$(IGNORE)$(MUTE)$(TESSY_BIN) new-test-collection $(TessyCollectionName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then $(TESSY_BIN) select-test-collection $(TessyCollectionName); RET=$$?;\
	exit $$RET;\
	fi
ifeq ($(IMPORT_REQUIREMENTS),ON)
	@echo import requirements
	$(IGNORE)$(MUTE)$(foreach reqfile,$(requirementslist),\
		$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) import-requirement-document -file $(realpath $(reqfile)) -commit;\
		RET=$$?;if [ $$RET -eq "0" ];then echo success $(reqfile);else echo error $(reqfile);fi;\
	)
endif

ifeq ($(CI_SERVER),ON)
	@echo importing Modules
	$(MUTE)$(foreach restorefile,$(restorelist),\
		$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) restore-module -test-collection $(realpath $(restorefile));\
		RET=$$?;if [ $$RET -eq "0" ];then echo success $(restorefile);else echo error $(restorefile);fi;\
	)
else #NOT CI_SERVER
	@echo importing Modules
ifeq ($(FLATTEN),ON)
	$(IGNORE)$(MUTE)$(foreach restorefile,$(restorelist),\
		$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) restore-module -test-collection $(realpath $(restorefile));\
		RET=$$?;if [ $$RET -eq "0" ];then echo success $(restorefile);else echo error $(restorefile);fi;\
	)
else #FLATTEN_OFF
#   consider folder structure
#   generate new folder out of folderlist (names of the .tmb-files)
	$(IGNORE)$(MUTE)$(foreach foldername,$(folderlist),\
		$(TESSY_BIN) new-folder -test-collection $(foldername);\
	)
#   restore all modules to the right folder	
	$(IGNORE)$(MUTE)$(foreach restorefile,$(restorelist),\
		$(TESSY_BIN) select-test-collection $(TessyCollectionName);\
		$(TESSY_BIN) select-folder -test-collection $(shell echo $(restorefile)| egrep -o "$(TessyProjectName)\.[A-z,0-9,\(,\,),%,_]+\." | egrep -o "\.[A-z,0-9,\(,\),%,_]+\." | egrep -o "[A-z,0-9,\(,\),%,_]+");\
		$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) restore-module $(realpath $(restorefile));\
		RET=$$?;if [ $$RET -eq "0" ];then echo success $(restorefile);else echo error $(restorefile);fi;\
	)
endif #FLATTEN	
endif #NOT CI_SERVER
	
#	clean modulelist file
	$(MUTE)rm -f $(TessyPrj)/lists/TESSY_modulelist.*
	
#	prepare modulelist file
	$(MUTE)$(TESSY_BIN) list-modules -test-collection >> $(TessyPrj)/lists/TESSY_modulelist.txt	  
#	execute next (new) target to refresh moudulelist variable	
	$(MUTE)$(MAKE) tessy_batch2

tessy_batch2:
#   new target to refresh variables
#	refresh modulelist
	$(eval modulelist = $(shell cat $(TessyPrj)/lists/TESSY_modulelist.txt))

ifeq ($(CI_SERVER),ON)	
	@echo selecting envrivorment
	$(IGNORE)$(MUTE)$(foreach module,$(modulelist), \
				$(TESSY_BIN) select-module -test-collection $(module); \
				$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) set-environment "GNU GCC Eclipse CDT (Default)";\
				RET=$$?;if [ $$RET -eq "0" ];then echo success $(module);else echo error $(module);fi;\
	)
else #NOT CI_SERVER
	@echo selecting envrivorment
ifeq ($(FLATTEN),ON)
	$(IGNORE)$(MUTE)$(foreach module,$(modulelist), \
				$(TESSY_BIN) select-module -test-collection $(module); \
				$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) set-environment "GNU GCC Eclipse CDT (Default)";\
				RET=$$?;if [ $$RET -eq "0" ];then echo success $(module);else echo error $(module);fi;\
	)	
else #FLATTEN_OFF
#   consider folder structure
	$(IGNORE)$(MUTE)$(foreach restorefile,$(restorelist), \
		folder=$(shell echo $(restorefile)| egrep -o "$(TessyProjectName)\.[A-z,0-9,\(,\,),%,_]+\." | egrep -o "\.[A-z,0-9,\(,\),%,_]+\." | egrep -o "[A-z,0-9,\(,\),%,_]+");\
		module=$(shell echo $(restorefile)| egrep -o ".[A-z,0-9,\(,\),%,_]+\.tmb" | egrep -o "\.[A-z,0-9,\(,\),%,_]+\." | egrep -o "[A-z,0-9,\(,\),%,_]+");\
		module=$${module//%2E/\.};\
		$(TESSY_BIN) select-test-collection $(TessyCollectionName);\
		$(TESSY_BIN) select-folder -test-collection $$folder;\
		$(TESSY_BIN) select-module $$module;\
		$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) set-environment "GNU GCC Eclipse CDT (Default)";\
		RET=$$?;if [ $$RET -eq "0" ];then echo success $$module;else echo error $$module;fi;\
	)
endif #FLATTEN
endif #NOT CI_SERVER

ifneq ($(ONLY_IMPORT),ON)

ifeq ($(TEST_ONE_BY_ONE),ON)
	@echo running batchtest with generate test_batch.tbs
	$(MUTE)$(MAKE) tessy_test_one_by_one
else
#	tessy sync generates a batch_test.tbs-file with rigth testcollection name
	$(MUTE)$(MAKE) tessy_sync_tbs
	
	$(MUTE)$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) exec-test $(realpath ${TessyPrj})/batch_test.tbs;
	$(MUTE) rm ${TessyPrj}/batch_test.tbs
endif

#   generate ExecutionCoverageReport
ifeq ($(IMPORT_REQUIREMENTS),ON)
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)"\/>/' \
	                  $(TessyPrj)/batch_test_REQ_tpl.tbs > $(TessyPrj)/batch_test.tbs
#   change first requirement name	
	$(MUTE)$(SEDBIN) -e 's/<requirement name="*.*/<requirement name="$(firstword $(notdir $(basename $(requirementslist))))"\/>/' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs	                 
#   add all  other requirements to batch_test.tbs
	$(MUTE)$(foreach req, $(wordlist 2,$(words $(notdir $(basename $(requirementslist)))),$(notdir $(basename $(requirementslist)))),\
			$(SEDBIN) -e '/<\/requirements>/i \                <requirement name="$(req)"\/>' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
	)                 
	$(MUTE)$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) exec-test $(realpath ${TessyPrj})/batch_test.tbs;
	$(MUTE) rm ${TessyPrj}/batch_test.tbs
endif

#   generate html-Report

#   set testcollection name
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)"\/>/' \
	                  $(TessyPrj)/batch_test_HTML_report.tbs > $(TessyPrj)/batch_test.tbs                 
	$(MUTE)$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) exec-test $(realpath ${TessyPrj})/batch_test.tbs; 
	$(MUTE) rm ${TessyPrj}/batch_test.tbs;

ifeq ($(CI_SERVER),ON)
#   searching for absolute path in html report and replace it with an internet link
	$(MUTE)$(SEDBIN) -e 's/file.*Temp/$(BuildLinkSED)/g' \
					  $(TessyPrj)/report/TESSY_OverviewReport.html > TESSY_OverviewReport_temp.html 
	$(MUTE)mv -f TESSY_OverviewReport_temp.html $(TessyPrj)/report/TESSY_OverviewReport.html
endif

endif #import only

ifneq ($(TESSY_GUI_ON),ON)
	@echo shutting down Tessy instance
	$(IGNORE)$(MUTE)$(TESSY_CMDLINE_PATH)/tessyd.exe shutdown --force;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessyd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi
else
	$(MUTE)rm -f ${TessyPrj}/lists/GUI_IS_ON.*
endif

########################################################################################
#  functions for Tessy main programm                                                   #
########################################################################################

#   tessy sync generates a batch_test.tbs-file with rigth testcollection name
tessy_sync_tbs:
	$(eval modulelist = $(shell cat $(TessyPrj)/lists/TESSY_modulelist.txt))
	@echo tbs sync
ifeq ($(TEST_ALL),ON)
#   set testcollection name
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)"\/>/' \
	                  $(TessyPrj)/batch_test_tpl.tbs > $(TessyPrj)/batch_test.tbs
else
#   set testcollection name
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)">/' \
	                  $(TessyPrj)/batch_test_tpl.tbs > $(TessyPrj)/batch_test.tbs
#   set testcollection ending 
	$(MUTE)$(SEDBIN) -e '/<testcollection name=*.*/a \	\	</testcollection>' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; 
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs
#   set elements to test to the modules from the modulelist 
	$(MUTE)$(foreach module,$(modulelist),\
		$(SEDBIN) -e '/<\/testcollection>/i \	\	\	<module name="$(module)"/>' $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
		mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs;\
	)
endif

#   generates one overview report for each module
tessy_test_one_by_one:
ifeq ($(CI_SERVER),ON)
	$(eval modulelist = $(shell cat $(TessyPrj)/lists/TESSY_modulelist.txt))
#   generate tessy batch script for each module (batch_test.tbs)
#   set testcollection name	
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)">/' \
	                  $(TessyPrj)/batch_test_tpl.tbs > $(TessyPrj)/batch_test.tbs
	$(MUTE)$(SEDBIN) -e '/<testcollection name=*.*/a \	\	</testcollection>' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs;
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs

#   generate one template module element
	$(MUTE)$(SEDBIN) -e '/<\/testcollection>/i \	\	\	<module name="template"/>'\
					   $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs
#   go over all elements from module list and replace modulename (and report name) for each element
	$(MUTE)$(foreach module,$(modulelist),\
			$(SEDBIN) -e 's/<module name=*.*/<module name="$(module)"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<option key="reportFileNamePattern" value="TESSY_OverviewReport_*.*/<option key="reportFileNamePattern" value="TESSY_OverviewReport_$(module)"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<option key="reportFileNamePattern" value="TESSY_RequirementExecutionCoverageReport_*.*/<option key="reportFileNamePattern" value="TESSY_RequirementExecutionCoverageReport_$(module)"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<requirement name="*.*/<requirement name="$(module)"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) exec-test $(realpath ${TessyPrj})/batch_test.tbs;\
			RET=$$?;if [ $$RET -eq "0" ];then echo success testing $(module);else echo error $(module);fi;\
	)
	$(MUTE) rm ${TessyPrj}/batch_test.tbs
else #CI_SERVER OFF
#   generate tessy batch script for each module (batch_test.tbs)
#   set testcollection name	
	$(MUTE)$(SEDBIN) -e 's/<testcollection name=*.*/<testcollection name="$(TessyCollectionName)">/' \
	                  $(TessyPrj)/batch_test_tpl.tbs > $(TessyPrj)/batch_test.tbs 
	$(MUTE)$(SEDBIN) -e '/<testcollection name=*.*/a \	\	</testcollection>' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; 
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs
ifeq ($(FLATTEN),OFF)
#   generate one template folder element
	$(MUTE)$(SEDBIN) -e '/<\/testcollection>/i \	\	\	<folder name="template"/>'\
					   $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs					   
	$(MUTE)$(SEDBIN) -e '/<folder name=*.*/a \	\	\	</folder>' \
					  $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; 
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs	
#   generate one template module element
	$(MUTE)$(SEDBIN) -e '/<\/folder>/i \	\	\	\	<module name="template"/>'\
					   $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs	
else
#   generate one template module element
	$(MUTE)$(SEDBIN) -e '/<\/testcollection>/i \	\	\	<module name="template"/>'\
					   $(TessyPrj)/batch_test.tbs > batch_test_temp.tbs
	$(MUTE)mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs
endif
#   go over all elements from module list and replace modulename (folder name and report name) for each element
	$(MUTE)$(foreach restorefile,$(restorelist),\
			folder=$(shell echo $(restorefile)| egrep -o "$(TessyProjectName)\.[A-z,0-9,\(,\)]+\." | egrep -o "\.[A-z,0-9,\(,\)]+\." | egrep -o "[A-z,0-9,\(,\)]+");\
			module=$(shell echo $(restorefile)| egrep -o ".[A-z,0-9,\(,\)]+\.tmb" | egrep -o "\.[A-z,0-9,\(,\)]+\." | egrep -o "[A-z,0-9,\(,\)]+");\
			module=$${module//%2E/\.};\
			$(SEDBIN) -e 's/<folder name=*.*/<folder name="'"$$folder"'">/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<module name=*.*/<module name="'"$$module"'"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<option key="reportFileNamePattern" value="TESSY_OverviewReport_*.*/<option key="reportFileNamePattern" value="TESSY_OverviewReport_'"$$module"'"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<option key="reportFileNamePattern" value="TESSY_RequirementExecutionCoverageReport_*.*/<option key="reportFileNamePattern" value="TESSY_RequirementExecutionCoverageReport_'"$$module"'"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(SEDBIN) -e 's/<requirement name="*.*/<requirement name="'"$$module"'"\/>/' \
					$(TessyPrj)/batch_test.tbs > batch_test_temp.tbs; \
			mv -f batch_test_temp.tbs $(TessyPrj)/batch_test.tbs; \
			$(TESSY_BIN) -t $(TESSY_CMD_TIMEOUT) exec-test $(realpath ${TessyPrj})/batch_test.tbs; \
			RET=$$?;if [ $$RET -eq "0" ];then echo success testing $$module;else echo error $$module;fi;\
	)
	$(MUTE) rm ${TessyPrj}/batch_test.tbs
endif #CI_SERVER

########################################################################################
#  additional functions and automations                                                #
########################################################################################

#   generate a template .tbs-file from a file saved with the Tessy GUI 
tessy_clean_up_usr_tbs:
	@echo take user tbs and process it to batch_test_tpl.tbs
#   delete modules from elements
	$(MUTE)$(SEDBIN) -e '/<module name=*.*>/c\'\
					   $(TessyUsrTbs) > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs
#   delete folder from elements
	$(MUTE)$(SEDBIN) -e '/<folder name=*.*>/c\'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs

	$(MUTE)$(SEDBIN) -e '/<\/folder>/c\'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs
#   delete testcollection from elements
	$(MUTE)$(SEDBIN) -e '/<testcollection name=*.*>/c\'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs

	$(MUTE)$(SEDBIN) -e '/<\/testcollection>/c\'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs
#   add elements beginning if needed
	$(MUTE)$(SEDBIN) -e '/<elements\/>/i \	<elements>'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs
#   change elements ending
	$(MUTE)$(SEDBIN) -e 's/<elements\/>/<\/elements>/'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs
#   add testcollection
	$(MUTE)$(SEDBIN) -e '/<\/elements>/i \	\	<testcollection name="TestCollection"/>'\
					   $(TessyPrj)/batch_test_tpl.tbs > batch_test_tpl_temp.tbs
	$(MUTE)mv -f batch_test_tpl_temp.tbs $(TessyPrj)/batch_test_tpl.tbs

#   export of doors requirements to .xml-files which are readable for Tessy
doors_requirement_export:
	@echo starting automatic doors2tessy export	
#   create new URL document
	$(MUTE)$(MAKE) prepare_URL_document
#   start a new target to refresh variables
	$(MUTE)$(MAKE) doors_requirement_export2
	
doors_requirement_export2:
#   new target to refresh variables	
	$(MUTE)$(SEDBIN) -e 's/<VIEW_NAME>*.*/<VIEW_NAME>$(Doors_View)<\/VIEW_NAME>/' \
				$(TessyPrj)/config/D2Tconf.xml > $(TessyPrj)/D2Tconf_temp.xml
	$(MUTE)mv -f $(TessyPrj)/D2Tconf_temp.xml $(TessyPrj)/config/D2Tconf.xml	
	$(MUTE) mkdir -p requirements
	$(MUTE)$(foreach URL, $(DoorsURLs), \
		$(SEDBIN) -e 's/<URL_PH>*.*/<URL_PH>$(shell echo "${URL}" | egrep -o ",[^,]*" | egrep -o "[^,]*")<\/URL_PH>/' \
				$(TessyPrj)/config/D2Tconf.xml > $(TessyPrj)/D2Tconf_temp.xml; \
		mv -f $(TessyPrj)/D2Tconf_temp.xml $(TessyPrj)/config/D2Tconf.xml; \
		$(SEDBIN) -e 's/<TESSY_NAME>.*/<TESSY_NAME>$(shell echo "${URL}" | egrep -o "[^,]*," | egrep -o "[^,]*")<\/TESSY_NAME>/' \
				$(TessyPrj)/config/D2Tconf.xml > $(TessyPrj)/D2Tconf_temp.xml; \
		mv -f $(TessyPrj)/D2Tconf_temp.xml $(TessyPrj)/config/D2Tconf.xml; \
		$(SEDBIN) -e 's/<XML_Req_Url>.*/<XML_Req_Url>requirements\\$(shell echo "${URL}" | egrep -o "[^,]*," | egrep -o "[^,]*")\.xml<\/XML_Req_Url>/' \
				$(TessyPrj)/config/D2Tconf.xml > $(TessyPrj)/D2Tconf_temp.xml; \
		mv -f $(TessyPrj)/D2Tconf_temp.xml $(TessyPrj)/config/D2Tconf.xml; \
		RET=$$($(DOORS2TESSY_BIN) DoorsExport $(TessyPrj)/config/D2Tconf.xml | egrep -o "[0-9]*"); \
		if [ "$$RET" == "0" ] ; \
		then rm requirements/$(shell echo "${URL}" | egrep -o "[^,]*," | egrep -o "[^,]*")\.xml; echo no requirements; \
		else echo $$RET requirements exported; \
		fi; \
		echo success $(shell echo "${URL}" | egrep -o "[^,]*," | egrep -o "[^,]*"); \
	)
	$(MUTE)mv requirements/*.xml $(requirementspath)
	$(MUTE)rmdir requirements		

#   function for doors_requirement_export
prepare_URL_document:
	@echo export URLs from $(Doors_Export_Folder)
	$(MUTE)$(DOORS_BIN) -D "current = folder \"$(Doors_Export_Folder)\"; #include <../Tessy/config/export_requirements.dxl>"
	$(MUTE) mv RS_SW_URLs.txt $(requirementspath)/RS_SW_URLs.txt
	@echo prepare URL document
	$(MUTE)$(SEDBIN) -e 's/RS_SW_//' \
					$(requirementspath)/RS_SW_URLs.txt > $(TessyPrj)/RS_SW_URLs_tmp.txt
	$(MUTE)mv -f $(TessyPrj)/RS_SW_URLs_tmp.txt $(requirementspath)/RS_SW_URLs.txt
	$(MUTE)$(SEDBIN) -e 's/&/&amp;/g' \
					$(requirementspath)/RS_SW_URLs.txt > $(TessyPrj)/RS_SW_URLs_tmp.txt
	$(MUTE)mv -f $(TessyPrj)/RS_SW_URLs_tmp.txt $(requirementspath)/RS_SW_URLs.txt

#   target for generating empty Tessy modules out of the SW_Unit_List (with includes of .c files)	
tessy_module_generation:
	$(MUTE)$(SEDBIN) -e 's/.*\.vbs.*/$(subst /,\\, $(subst \,\\,$(TessyPrj)))\\config\\exportSources\.vbs $(subst /,\/, $(subst \,\\,$(SWUnitListXLS)))/g' \
					$(TessyPrj)/config/executeExportSources.bat > $(TessyPrj)/config/executeExportSources_tmp.bat
	$(MUTE)mv -f $(TessyPrj)/config/executeExportSources_tmp.bat $(TessyPrj)/config/executeExportSources.bat	

	@echo tessy module generation started
	$(TessyPrj)/config/executeExportSources.bat
	
	$(MUTE)mv -f SWUnitList.txt $(TessyPrj)/lists/SWUnitList.txt

	$(MUTE)$(IGNORE) mkdir -p $(TessyPrj)/lists
	
	$(MUTE) rm -f $(TessyPrj)/lists/GUI_IS_ON.*  
	
	@echo starting Tessy instance with $(TESSY_CMDLINE_PATH)/tessy.exe
	$(IGNORE)$(MUTE)$(TESSY_CMDLINE_PATH)/tessyd.exe --dont-breakaway-from-job -t 180 --file $(TessyPrj)/tessy.pdbx;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "GUI is maybe running ?!";\
	echo ON >> ${TessyPrj}/lists/GUI_IS_ON.txt;\
	fi
			
ifneq ($(TESSY_AUTO_DISCONNECT),)
	$(IGNORE)$(MUTE)$(TESSY_BIN) disconnect
endif

	@echo connecting Tessy instance
	$(IGNORE)$(MUTE)$(TESSY_BIN) connect;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi

	@echo selecting project $(TessyProjectName)
	$(IGNORE)$(MUTE)$(TESSY_BIN) select-project $(TessyProjectName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi 
		
	@echo select Testcollection
	$(IGNORE)$(MUTE)$(TESSY_BIN) new-test-collection $(TessyCollectionName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then $(TESSY_BIN) select-test-collection $(TessyCollectionName); RET=$$?;\
	exit $$RET;\
	fi

#	clean modulelist file
	$(MUTE)rm -f $(TessyPrj)/lists/TESSY_modulelist.*
	
	
#	prepare modulelist file
	$(MUTE)$(TESSY_BIN) list-modules -test-collection >> $(TessyPrj)/lists/TESSY_modulelist.txt	   	

ifneq ($(FLATTEN),ON)	#also search in subfolders
	$(MUTE)$(foreach folder,$(folderlist),\
		$(TESSY_BIN) select-folder -test-collection $(folder);\
		$(TESSY_BIN) list-modules >> $(TessyPrj)/lists/TESSY_modulelist.txt;\
	)
endif
#   start a new target to refresh variables
	$(MUTE)$(MAKE) tessy_module_generation2

tessy_module_generation2:
#   new target to refresh variables
	$(eval modulelist = $(shell cat $(TessyPrj)/lists/TESSY_modulelist.txt))
#   generation of new modules
ifneq ($(wildcard ${TessyPrj}/lists/SWUnitList.txt),)
	$(MUTE)$(IGNORE)$(foreach unit,$(SWUnitList), \
	if [ "$(suffix $(unit))" != ".c" ];\
	then if [ "$(unit)" == "$(findstring $(unit),$(modulelist))" ];\
	then echo no generation of $(unit), module is  imported already;\
	ACTIVE=1;\
	else echo add module $(unit);\
	$(TESSY_BIN) new-module -env $(TessyEnv) -test-collection $(unit); \
	ACTIVE=0;\
	fi;\
	else if [ $$ACTIVE == "0" ];\
	then echo try to add source $(shell find $(BaseDirAbs)/Source -name $(unit));\
	$(TESSY_BIN) add-source-file $(shell find $(BaseDirAbs)/Source -name $(unit));\
	fi;\
	fi;\
	)
endif

ifneq ($(TESSY_GUI_ON),ON)
	@echo shutting down Tessy instance
	$(IGNORE)$(MUTE)$(TESSY_CMDLINE_PATH)/tessyd.exe shutdown;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessyd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi
else
	$(MUTE)rm -f ${TessyPrj}/lists/GUI_IS_ON.*
endif

tessy_start:
	@echo starting Tessy instance headless
	${TESSYD_BIN} --dont-breakaway-from-job -t 180 --file $(TessyPrj)/tessy.pdbx;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo bad fucking thing is going on;exit $$RET;\
	fi

ifneq ($(TESSY_AUTO_DISCONNECT),)
	$(TESSY_BIN) disconnect
endif

	@echo connecting Tessy instance
	$(TESSY_BIN) connect;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi

	@echo selecting project $(TessyProjectName)
	$(TESSY_BIN) select-project $(TessyProjectName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessycmd.exe return code $$RET indicates tool problem.";\
	exit $$RET;\
	fi

	@echo select Testcollection
	$(TESSY_BIN) select-test-collection $(TessyCollectionName);\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then exit $$RET;\
	fi

tessy_shutdown:
	@echo shutting down Tessy instance
	${TESSYD_BIN} shutdown;\
	RET=$$?;\
	if [ $$RET -ne "0" ];\
	then echo .; echo "tessyd.exe return code $$RET indicates tool problem.";\
	fi
