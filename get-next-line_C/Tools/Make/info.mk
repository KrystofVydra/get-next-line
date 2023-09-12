# SVN-Id: $Id: info.mk 52032 2017-01-17 13:19:54Z ostwal01 $
# SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/info.mk $

######################################################################
#
# MAKEFILE TEMPLATE AEP2
#
# See /doc for detailed documentation
#
# Gather and print of information regarding config data and tool
# versions to the console view.
######################################################################



######################################################################
# Gather and print build process configuration and tool versions.
######################################################################

# Macros for printing variable lists to console or file
ConstLine = --------------------------------------------------
PrintTitle = echo -e "${ConstLine}\n ${1}\n${ConstLine}"
define PrintList
  for i in $1; do echo $$i; done;
  echo;
endef

.PHONY: print_info
print_info:
	$(call PrintTitle,\
		KOSTAL Build-Process Version $(BuildProcessVersion))
	echo

	$(call PrintTitle,\
		Make process core file checksum status)
# Always ignore exit code from md5sum. exit 0 prevents warning from
# make.exe.
	md5sum -c md5.txt; exit 0;
	echo

	$(call PrintTitle,Make Version)
	$(MAKE) --version | head -n 1
	echo

	$(call PrintTitle,Find Version)
	$(FINDBIN) --version | head -n 1
	echo

	$(call PrintTitle,Sed Version)
	$(SEDBIN) --version | head -n 1
	echo

	$(call PrintTitle,GNU CC Version)
	$(GCCBIN) --version | head -n 1
	echo

	$(call PrintTitle,Sources (blacklist-filtered))
	$(call PrintList, $(source_filtered))

	$(call PrintTitle,SourcesQAC (blacklist-filtered))
	$(call PrintList, $(SrcList_Qac))

	$(call PrintTitle,ObjectsQAC (blacklist-filtered))
	$(call PrintList, ${ObjList_Qac})

	$(call PrintTitle,StubsQAC)
	$(call PrintList, ${StubsDir_Qac})

	$(call PrintTitle,Header (blacklist-filtered))
	$(call PrintList,$(header_filtered))

	$(call PrintTitle,Assembler Sources (blacklist-filtered))
	$(call PrintList,$(asm_source_filtered))

	$(call PrintTitle,Blacklist)
	$(call PrintList,$(blacklist))

	$(call PrintTitle,Compiler Options)
	$(call PrintList,$(CFLAGS))

	$(call PrintTitle,Assembler Options)
	$(call PrintList,$(AFLAGS))

	$(call PrintTitle,Linker Options)
	$(call PrintList,$(LDFLAGS))

	$(call PrintTitle,IPath)
	$(call PrintList,$(IPath))


######################################################################
# Collect build process configuration and tool version and write to
# file and to console.
######################################################################

# Output redirect configuration. Set FileInfo to redirect output to
# that file.
BUILD_INFO_FILE = ${TargetSubDir}/build_info.txt

.PHONY: print_info_file
print_info_file:
	@echo "Project info is stored to file '$(FileInfo)'."
	${MAKE} print_info | tee ${FileInfo}


######################################################################
# Generate the checksums of all make process core files.
#
# The checksums are verified in print_info target.
######################################################################
md5.txt: makefile $(wildcard *.mk)
	@echo "Generating checksum of make process core files."
	md5sum makefile *.mk > $@
