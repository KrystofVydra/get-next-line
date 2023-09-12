# SVN-Id: $Id: std_sw_trace.mk 52032 2017-01-17 13:19:54Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/std_sw_trace.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# Standard software trace automation.
######################################################################

# Creates a list of all header and c-files of the Framework,
# i.e. stubs and integration files are not included in this list. The
# list is written in two variants: one containing only filenames, one
# containing also the paths.

frameworkBlacklist = \
	${SourceDir}/Integration/% \
	${SourceDir}/Stubs/%

relevant_source_filtered     = $(filter-out $(frameworkBlacklist),$(source_filtered))
relevant_SourceNoPath        = $(notdir $(relevant_source_filtered))

relevant_header_filtered     = $(filter-out $(frameworkBlacklist),$(header_filtered))
relevant_HeaderNoPath        = $(notdir $(relevant_header_filtered))

.PHONY: outputsourcelist
outputsourcelist:
	@echo gathering sourcelist for output
	rm -f ${SrcListDir}/list_of_files_with_path.txt
	echo $(relevant_source_filtered) >> ${SrcListDir}/list_of_sourcesfiles.txt
	echo $(relevant_header_filtered) >> ${SrcListDir}/list_of_sourcesfiles.txt
	$(SEDBIN) -e 's/ /\
/g' \
		${SrcListDir}/list_of_sourcesfiles.txt > ${SrcListDir}/list_of_files_with_path.txt
	rm -f ${SrcListDir}/list_of_sourcesfiles.txt

	rm -f ${SrcListDir}/list_of_files_without_path.txt
	echo $(relevant_SourceNoPath) >> ${SrcListDir}/list_of_sourcesfiles.txt
	echo $(relevant_HeaderNoPath) >> ${SrcListDir}/list_of_sourcesfiles.txt
	$(SEDBIN) -e 's/ /\
/g' \
		${SrcListDir}/list_of_sourcesfiles.txt > ${SrcListDir}/list_of_files_without_path.txt
	rm -f ${SrcListDir}/list_of_sourcesfiles.txt

.PHONY: AutoConfigCreator
AutoConfigCreator:
	@echo run AutoConfigCreator
	$(MAKE) preparelists
	$(MAKE) outputsourcelist
	${BaseDir}/Tools/STD-SWTrace/AutoConfigCreator/AutoConfigCreator.exe -p ${BaseDir} -o "Tools/STD-SWTrace/Configurations/configuration.xml"

.PHONY: csValidate
csValidate:
	@echo run CSValidator
	${BaseDir}/Tools/STD-SWTrace/CSValidator/CSValidator.exe -p ${BaseDir}/Tools/Make -o "Target/${BUILDMODE}/bin/componentList.xml" ${BaseDir}/Tools/STD-SWTrace/Configurations/configuration.xml
